import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/Home/home_page.dart';
import 'package:inno_store/Map/map_screen.dart';
import 'package:inno_store/Category/category_screen.dart';
import 'package:inno_store/Customer_Support/customer_support_screen.dart';
import 'package:inno_store/my_account_page/my_account_screen.dart';
import 'package:inno_store/Cashier/pay.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/Cashier/voucher.dart' as cashier;

class MainHomePage extends StatefulWidget {
  final int initialIndex;
  final ValueNotifier<List<Offset>> pathNotifier;
  final double x;
  final double y;
  final String destinationCategory;

  MainHomePage({
    this.initialIndex = 0,
    required this.pathNotifier,
    this.x = 2.0,
    this.y = 2.0,
    required this.destinationCategory,
  });

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  User? user;
  String? username;
  String? userId;
  bool isLoading = true;
  late double x;
  late double y;
  late List<Offset> path;
  List<CartItem> cartItems = [];
  List<cashier.Voucher> redeemedVouchers = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    x = widget.x;
    y = widget.y;
    path = widget.pathNotifier.value;
    fetchUser();
    widget.pathNotifier.addListener(_onPathChanged);
  }

  @override
  void dispose() {
    widget.pathNotifier.removeListener(_onPathChanged);
    super.dispose();
  }

  Future<void> fetchUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
        setState(() {
          user = currentUser;
          userId = currentUser.uid; // Store the userId
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

  void _onPathChanged() {
    setState(() {
      path = widget.pathNotifier.value;
    });
  }

  List<Widget> _widgetOptions(String username, String userId, double x, double y, List<Offset> path) {
    return <Widget>[
      HomePage(username: username, userId: userId), // Pass userId to HomePage
      MapScreen(
        x: x,
        y: y,
        path: path,
        destinationCategory: widget.destinationCategory,
      ),
      CategoryScreen(
        navigateToPayment: (items, vouchers) {
          setState(() {
            cartItems = items;
            redeemedVouchers = vouchers;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayScreen(
                cartItems: cartItems,
                username: username,
                onClearCart: _clearCart,
                redeemedVouchers: redeemedVouchers, // Pass the vouchers
              ),
            ),
          );
        },
      ),
      CustomerSupportScreen(),
      MyAccountPage(),
    ];
  }

  void _clearCart() {
    setState(() {
      cartItems.clear();
      redeemedVouchers = []; // Clear the vouchers when the cart is cleared
    });
  }

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

    if (username == null || userId == null) { // Ensure both username and userId are available
      return Scaffold(
        body: Center(child: Text("Failed to fetch user data")),
      );
    }

    List<Widget> widgetOptions = _widgetOptions(username!, userId!, x, y, path);

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
