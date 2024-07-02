import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  User? user;
  String? username;
  String? email;
  String? gender;
  String? birthday;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || username == null || email == null || gender == null || birthday == null) {
      return Center(child: CircularProgressIndicator());
    }

    String firstLetter = username![0].toUpperCase();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Text(
                      firstLetter,
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Welcome: $username',
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
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconTextColumn(Icons.mail, "0", "Inbox"),
                  _buildIconTextColumn(Icons.local_offer, "1", "eCoupon & eVoucher"),
                  _buildIconTextColumn(Icons.favorite, "0", "My Wish List"),
                  _buildIconTextColumn(Icons.notifications, "0", "Notify Me"),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add your membership link or action here
                },
                child: Text('Become a INNO store member'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to INNO store benefits page
                },
                child: Text('INNO store benefits'),
              ),
              SizedBox(height: 16),
              Text(
                'My Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconTextColumn(Icons.history, "Order History"),
                  _buildIconTextColumn(Icons.star, "Ratings & Reviews"),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Member Center',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to voucher page
                },
                child: Text('Voucher'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconTextColumn(IconData icon, String text, [String? subtext]) {
    return Column(
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 16)),
        if (subtext != null) ...[
          SizedBox(height: 2),
          Text(subtext, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ],
    );
  }
}
