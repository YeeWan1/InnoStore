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
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
        _username = userDoc['username'] ?? _currentUser!.email ?? 'Anonymous';

        final querySnapshot = await _helpRequests
            .where('userId', isEqualTo: _currentUser!.uid)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            _requestId = querySnapshot.docs.first.id;
            _loading = false;
          });
        } else {
          DocumentReference newRequest = await _helpRequests.add({
            'userId': _currentUser!.uid,
            'username': _username,
            'message': 'Initial help request',
            'timestamp': Timestamp.now(),
            'status': 'Pending',
          });
          setState(() {
            _requestId = newRequest.id;
            _loading = false;
          });
        }
      } catch (e) {
        setState(() {
          _loading = false;
          _error = true;
        });
      }
    } else {
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
