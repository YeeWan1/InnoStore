import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/Home/home_page.dart';
import 'package:inno_store/Map/map_screen.dart';
import 'package:inno_store/Category/category_screen.dart';
import 'package:inno_store/Request_Help/request_help_screen.dart';
import 'package:inno_store/my_account_page/my_account_screen.dart';

class MainHomePage extends StatefulWidget {
  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  User? user;
  String? username;

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
      });
    }
  }

  static List<Widget> _widgetOptions(String username) => <Widget>[
    HomePage(username: username),
    MapScreen(x: 0.0, y: 0.0),
    CategoryScreen(),
    RequestHelpScreen(),
    MyAccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || username == null) {
      return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching user data
    }

    // Generate the list of widget options with the username
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
              child: Container(
                color: _selectedIndex == idx ? Colors.grey[200] : Colors.white,
                child: widget,
              ),
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
            label: 'Request Help',
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
