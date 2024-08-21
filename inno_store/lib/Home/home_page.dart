import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inno_store/Home/point.dart';
import 'package:inno_store/Home/welcome_dialog.dart'; // Import the welcome dialog

class HomePage extends StatefulWidget {
  final String username;
  final String userId; // Add userId to pass to WelcomeDialog

  const HomePage({required this.username, required this.userId, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPoints = 778; // Initialize with your starting points

  final List<Map<String, String>> mostPopularList = [
    {'path': 'assets/products/nutrition/birdnest.jpg'},
    {'path': 'assets/products/groceries/kitkat.jpg'},
    {'path': 'assets/products/supplements/krilloil.png'},
    {'path': 'assets/products/makeup/dryfoundation.jpg'},
    {'path': 'assets/products/supplements/bioaceplus.jpg'},
  ];

  final List<Map<String, String>> bestSellerList = [
    {'path': 'assets/products/coffee/oldtownhazelnut.jpg'},
    {'path': 'assets/products/traditional_medicine/kapak.jpg'},
    {'path': 'assets/products/supplements/bufferedc.jpg'},
    {'path': 'assets/products/coffee/oldtown.jpg'},
    {'path': 'assets/products/groceries/kokokrunch.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return WelcomeDialog(username: widget.username, userId: widget.userId);
      },
    ).then((isInStore) {
      if (isInStore != null && isInStore) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Welcome to INNO store!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Feel free to visit us at INNO store!'),
        ));
      }
    });
  }

  void _updatePoints(int newPoints) {
    setState(() {
      _currentPoints = newPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 8),
            _buildSection('MOST POPULAR', mostPopularList),
            SizedBox(height: 16),
            _buildSection('BEST SELLER', bestSellerList),
            SizedBox(height: 16),
            _buildPointsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Hello, ${widget.username}!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.account_circle, size: 40, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, String>> productList) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title),
          SizedBox(height: 8),
          _buildProductCarousel(productList),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProductCarousel(List<Map<String, String>> productList) {
    return Container(
      height: 200,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          height: double.infinity,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.5,
          aspectRatio: 2.0,
          autoPlayInterval: Duration(seconds: 3),
        ),
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return Stack(
            children: [
              _buildProductCard(productList[itemIndex]['path']!),
              _buildRankBadge(itemIndex + 1),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProductCard(String imagePath) {
    return Container(
      width: 140,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    String assetPath;
    if (rank == 1) {
      assetPath = 'assets/goldcrown.png';
    } else if (rank == 2) {
      assetPath = 'assets/silvercrown.png';
    } else if (rank == 3) {
      assetPath = 'assets/bronzecrown.png';
    } else {
      return Positioned(
        top: 8,
        left: 8,
        child: CircleAvatar(
          backgroundColor: Colors.black54,
          child: Text(
            '$rank',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Positioned(
      top: 8,
      left: 8,
      child: Image.asset(
        assetPath,
        width: 40,
        height: 40,
      ),
    );
  }

  Widget _buildPointsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Points'),
          SizedBox(height: 8),
          _buildPointsInfo(),
        ],
      ),
    );
  }

  Widget _buildPointsInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset('assets/point.png', width: 40),
            title: Text('Your Points', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('You have $_currentPoints points'),
            onTap: () async {
              final updatedPoints = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PointPage(
                    currentPoints: _currentPoints,
                    onPointsUpdated: _updatePoints,
                  ),
                ),
              );

              if (updatedPoints != null) {
                setState(() {
                  _currentPoints = updatedPoints;
                });
              }
            },
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              final updatedPoints = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PointPage(
                    currentPoints: _currentPoints,
                    onPointsUpdated: _updatePoints,
                  ),
                ),
              );

              if (updatedPoints != null) {
                setState(() {
                  _currentPoints = updatedPoints;
                });
              }
            },
            child: Text('Redeem Points'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent, // Button color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
