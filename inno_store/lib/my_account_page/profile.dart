import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  String? username;
  String? email;
  String? gender;
  String? birthday;
  String? age;
  String? occupation;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      setState(() {
        user = currentUser;
        username = userDoc['username'] ?? "User";
        email = userDoc['email'] ?? currentUser.email;
        gender = userDoc['gender'] ?? "Not specified";
        birthday = userDoc['birthday'] ?? "Not specified";
        age = userDoc['age'] ?? "Not specified";
        occupation = userDoc['occupation'] ?? "Not specified";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || username == null || email == null || gender == null || birthday == null || age == null || occupation == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Gender: $gender',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Birthday: $birthday',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Occupation: $occupation',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
