import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  final String username;
  final List<String> imgList = [
    'https://via.placeholder.com/600x400?text=Buy+1+Free+1',
    'https://via.placeholder.com/600x400?text=20%+Off',
    'https://via.placeholder.com/600x400?text=Free+Shipping',
  ];

  HomePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hello, $username!',
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
            color: Colors.pink,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text(
                  'Kaw Kaw Deals',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(
                  '30% OFF\n27 Jun - 1 Jul 2024',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: imgList.map((item) => Container(
              child: Center(
                child: Image.network(item, fit: BoxFit.cover, width: 1000),
              ),
            )).toList(),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            children: [
              _buildIconCard(Icons.local_offer, 'Kaw Kaw Deals'),
              _buildIconCard(Icons.health_and_safety, 'Health'),
              _buildIconCard(Icons.person, 'Personal Care'),
              _buildIconCard(Icons.spa, 'Skincare'),
              _buildIconCard(Icons.brush, 'Cosmetics'),
              _buildIconCard(Icons.card_giftcard, 'Coupon Zone'),
              _buildIconCard(Icons.local_hospital, 'Health 45+'),
              _buildIconCard(Icons.face, 'Beauty Profile'),
              _buildIconCard(Icons.eco, 'Sustainable Choices'),
              _buildIconCard(Icons.content_cut, 'Haircare Finder'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconCard(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
