import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/Home/home_page.dart';
import 'package:inno_store/Map/map_screen.dart';
import 'package:inno_store/Category/category_screen.dart';
import 'package:inno_store/Customer_Support/customer_support_screen.dart';
import 'package:inno_store/my_account_page/my_account_screen.dart';

class MainHomePage extends StatefulWidget {
  final int initialIndex;
  final double x;
  final double y;
  final List<Offset> path;

  MainHomePage({
    this.initialIndex = 0,
    this.x = 2.0,
    this.y = 2.0,
    this.path = const [],
  });

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  User? user;
  String? username;
  bool isLoading = true;
  late double x;
  late double y;
  late List<Offset> path;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    x = widget.x;
    y = widget.y;
    path = widget.path;
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

  static List<Widget> _widgetOptions(String username, double x, double y, List<Offset> path) => <Widget>[
    HomePage(username: username),
    MapScreen(x: x, y: y, path: path), // Use the passed coordinates and path
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

    List<Widget> widgetOptions = _widgetOptions(username!, x, y, path);

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
