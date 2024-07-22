import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile.dart';
import 'coupon_voucher.dart';
import 'purchase_history.dart';
import 'notification.dart';
import 'rating_review.dart';
import 'password.dart'; 

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
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
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
                    icon: Icon(Icons.logout, color: Colors.blue),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Hello, $username! Have a nice day :)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 16),
              _buildMenuOption(Icons.person, 'Profile', context, ProfilePage()),
              _buildMenuOption(Icons.local_offer, 'Coupon & Vouchers', context, CouponVoucherPage()),
              _buildMenuOption(Icons.history, 'Purchase History', context, PurchaseHistoryPage()),
              _buildMenuOption(Icons.notifications, 'Notifications', context, NotificationPage(), notificationCount: 5),
              _buildMenuOption(Icons.star, 'Rating and Review', context, RatingReviewPage()),
              _buildMenuOption(Icons.lock, 'Passwords', context, PasswordPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, BuildContext context, Widget page, {int notificationCount = 0}) {
    return ListTile(
      leading: Icon(icon, size: 40, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 18, color: Colors.black87)),
      trailing: notificationCount > 0 
        ? CircleAvatar(
            backgroundColor: Colors.red,
            radius: 12,
            child: Text(
              notificationCount.toString(),
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
