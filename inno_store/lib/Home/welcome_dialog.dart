import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeDialog extends StatelessWidget {
  final String username;
  final String userId;

  const WelcomeDialog({Key? key, required this.username, required this.userId}) : super(key: key);

  Future<void> _recordInTime() async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance.collection('time_spent_in_store').doc(userId);

      await docRef.set({
        'userId': userId,
        'username': username,
        'in_time': FieldValue.serverTimestamp(), // Record the in-time
      }, SetOptions(merge: true)); // Merge with existing data if any
    } catch (e) {
      print('Error recording in-time: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Welcome!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Are you currently in the INNO store?'),
          SizedBox(height: 10),
          Text('Do you want to start purchasing?'), // Additional statement
        ],
      ),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false); // Return false to indicate not in store
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () async {
            await _recordInTime(); // Record in-time when the user presses "Yes"
            Navigator.of(context).pop(true); // Return true to indicate in store and ready to purchase
          },
        ),
      ],
    );
  }
}
