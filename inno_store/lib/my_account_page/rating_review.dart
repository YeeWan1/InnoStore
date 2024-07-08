import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingReviewPage extends StatefulWidget {
  @override
  _RatingReviewPageState createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  User? user;
  String? username;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        username = userDoc['username'] ?? 'Anonymous';
      });
    }
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('reviews')
            .add({
          'userId': user?.uid,
          'username': username ?? 'Anonymous', // Use fetched username
          'rating': _rating,
          'review': _reviewController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _reviewController.clear();
        setState(() {
          _rating = 0.0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: $e')),
        );
      }
    }
  }

  Stream<QuerySnapshot> _fetchReviews() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rating and Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(labelText: 'Write a review'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a review';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text('Rating:'),
                      Slider(
                        value: _rating,
                        onChanged: (newRating) {
                          setState(() {
                            _rating = newRating;
                          });
                        },
                        divisions: 5,
                        label: _rating.toString(),
                        min: 0,
                        max: 5,
                      ),
                      Text(_rating.toString()),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _fetchReviews(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final reviews = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ListTile(
                        title: Text(review['username']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rating: ${review['rating']}'),
                            Text(review['review']),
                          ],
                        ),
                        trailing: Text(
                          (review['timestamp'] as Timestamp).toDate().toString(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
