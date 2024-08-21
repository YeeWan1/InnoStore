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
  final List<Map<String, String>> imgList = [
    {'path': 'assets/40%.jpg', 'title': '40% Off'},
    {'path': 'assets/20%.jpg', 'title': '20% Off'},
    {'path': 'assets/member.jpg', 'title': 'Member Discount'},
  ];

  final List<Map<String, String>> voucherList = [];
  final Set<String> redeemedVouchers = {};

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

  void _redeemVoucher(Map<String, String> voucher) {
    setState(() {
      voucherList.add(voucher);
      redeemedVouchers.add(voucher['path']!);
    });
    Navigator.pop(context);
  }

  void _showRedeemDialog(Map<String, String> voucher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Redeem Voucher"),
          content: Text("Do you want to redeem this voucher?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Redeem"),
              onPressed: () {
                _redeemVoucher(voucher);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyRedeemedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "This voucher has already been redeemed.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _updatePoints(int newPoints) {
    setState(() {
      _currentPoints = newPoints;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 54, 181, 244), Color.fromARGB(255, 167, 175, 76)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MEMBER DAY',
                    style: TextStyle(color: Colors.black, fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '30% OFF',
                    style: TextStyle(color: Colors.yellow, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'min spend RM100',
                    style: TextStyle(color: Color.fromARGB(255, 2, 66, 118), fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: double.infinity,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imgList.map((item) => GestureDetector(
                  onTap: () {
                    if (redeemedVouchers.contains(item['path'])) {
                      _showAlreadyRedeemedDialog();
                    } else {
                      _showRedeemDialog(item);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(item['path']!, fit: BoxFit.cover, width: 1000),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(200, 0, 0, 0),
                                    Color.fromARGB(0, 0, 0, 0)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: Text(
                                item['title']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Vouchers'),
                  ...voucherList.map((voucher) => _buildVoucherCard(voucher['title']!, voucher['path']!)).toList(),
                  SizedBox(height: 8),
                  _buildSectionTitle('Points'),
                  _buildPointsInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
      ),
    );
  }

  Widget _buildVoucherCard(String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        leading: Image.asset(imagePath, fit: BoxFit.contain, width: 50),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPointsInfo(BuildContext context) {
    return Column(
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
            backgroundColor: Colors.orange, // Button color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
