import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inno_store/Home/point.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hello, ${widget.username}!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle, size: 40),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 244, 143, 54), Colors.green],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
            SizedBox(height: 8), // Add space between the sections
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
                    child: Center(
                      child: Image.asset(item['path']!, fit: BoxFit.contain, width: 1000),
                    ),
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 8), // Add space between the sections
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
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVoucherCard(String title, String imagePath) {
    return Card(
      child: ListTile(
        leading: Image.asset(imagePath, fit: BoxFit.contain, width: 50),
        title: Text(title),
      ),
    );
  }

  Widget _buildPointsInfo(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset('assets/point.png', width: 40), // Update the icon path
          title: Text('Your Points'),
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
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Page')),
    );
  }
}
