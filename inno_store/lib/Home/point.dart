import 'package:flutter/material.dart';

class PointPage extends StatefulWidget {
  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  int _currentPoints = 778;
  double _purchaseAmount = 0;
  int _pointsEarned = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points Reward Page'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.purple.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/point.png', width: 40), // Update the icon path
                SizedBox(width: 8),
                Text(
                  '$_currentPoints',
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '$_currentPoints point(s) expiring on 31-10-2024',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Purchase Amount (RM)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _purchaseAmount = double.tryParse(value) ?? 0;
                  _pointsEarned = _purchaseAmount.toInt();
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'You will earn $_pointsEarned points based on your purchase.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentPoints += _pointsEarned;
                  });
                },
                child: Text('Redeem Points'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}