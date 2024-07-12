import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerSupportScreen extends StatefulWidget {
  @override
  _CustomerSupportScreenState createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final CollectionReference _helpRequests = FirebaseFirestore.instance.collection('help_requests');
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  String? _requestId;
  bool _loading = true;
  bool _error = false;
  String? _username;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    if (_currentUser != null) {
      print('User ID: ${_currentUser!.uid}, Email: ${_currentUser!.email}');
      try {
        // Fetch username from the 'users' collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
        _username = userDoc['username'] ?? _currentUser!.email ?? 'Anonymous';
        print('Fetched username: $_username');

        print('Fetching help requests for user: ${_currentUser!.uid}');
        final querySnapshot = await _helpRequests
            .where('userId', isEqualTo: _currentUser!.uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        print('Query snapshot: ${querySnapshot.docs.length} documents found.');
        for (var doc in querySnapshot.docs) {
          print('Document ID: ${doc.id}, Data: ${doc.data()}');
        }

        if (querySnapshot.docs.isNotEmpty) {
          print('Help request found for user: ${_currentUser!.uid}');
          setState(() {
            _requestId = querySnapshot.docs.first.id;
            _loading = false;
          });
        } else {
          print('No help request found. Creating a new one for user: ${_currentUser!.uid}');
          DocumentReference newRequest = await _helpRequests.add({
            'userId': _currentUser!.uid,
            'username': _username,
            'message': 'Initial help request',
            'timestamp': Timestamp.now(),
            'status': 'Pending',
          });
          print('New help request created with ID: ${newRequest.id}');
          setState(() {
            _requestId = newRequest.id;
            _loading = false;
          });
        }
      } catch (e) {
        print('Error initializing chat: $e');
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } else {
      print('User is not authenticated');
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty && _requestId != null) {
      try {
        await _helpRequests.doc(_requestId).collection('messages').add({
          'sender': _username,
          'text': _messageController.text,
          'timestamp': Timestamp.now(),
        });
        print('Message sent: ${_messageController.text}');
        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isUserMessage = data['sender'] == _username;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(data['text']),
      ),
    );
  }

  Widget _buildMessageList() {
    if (_requestId == null) {
      return Center(child: Text('No chat available.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _helpRequests.doc(_requestId).collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Customer Support'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Customer Support'),
        ),
        body: Center(child: Text('Error loading chat. Please try again later.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
