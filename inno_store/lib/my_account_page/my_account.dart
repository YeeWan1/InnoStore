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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      setState(() {
        user = currentUser;
        username = userDoc['username'] ?? "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
        //title: Text(''),
      //),
      body: user == null || username == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome $username!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, size: 30),
                          onPressed: () {
                            // Navigate to settings page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyAccountPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Have a nice day',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Become a INNO Store member',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Handle membership linking/applying
                            },
                            child: Text('Link up / Apply for Membership'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // This should be backgroundColor
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      children: [
                        _buildIconCard(Icons.inbox, 'Inbox', 0),
                        _buildIconCard(Icons.card_giftcard, 'eCoupon', 1),
                        _buildIconCard(Icons.favorite, 'My Wish List', 0),
                        _buildIconCard(Icons.notifications, 'Notify Me', 0),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Beauty Profile',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Finished the task to see recommendations...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'My Order',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: [
                        _buildIconCard(Icons.history, 'Order History', 0),
                        _buildIconCard(Icons.repeat, 'Reorder', 0),
                        _buildIconCard(Icons.rate_review, 'Ratings & Reviews', 0),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Member Center',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      children: [
                        _buildIconCard(Icons.account_balance_wallet, 'Point Balance', 0),
                        _buildIconCard(Icons.local_offer, 'Member Offer', 0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildIconCard(IconData icon, String label, int count) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, size: 40),
            if (count > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$count',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
