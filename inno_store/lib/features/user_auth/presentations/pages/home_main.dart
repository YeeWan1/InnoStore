import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/Home/home_page.dart';
import 'package:inno_store/Map/map_screen.dart';
import 'package:inno_store/Category/category_screen.dart';
import 'package:inno_store/Customer_Support/customer_support_screen.dart';
import 'package:inno_store/my_account_page/my_account_screen.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  User? user;
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        setState(() {
          user = currentUser;
          username = userDoc['username'] ?? "User";
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  static List<Widget> _widgetOptions(String username) => <Widget>[
    HomePage(username: username),
    MapScreen(x: 2.0, y: 2.0),
    CategoryScreen(),
    CustomerSupportScreen(),
    MyAccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (username == null) {
      return Scaffold(
        body: Center(child: Text("Failed to fetch user data")),
      );
    }

    List<Widget> widgetOptions = _widgetOptions(username!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inno Store'),
      ),
      body: Stack(
        children: widgetOptions.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget widget = entry.value;

          return Offstage(
            offstage: _selectedIndex != idx,
            child: TickerMode(
              enabled: _selectedIndex == idx,
              child: widget,
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
