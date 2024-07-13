import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inno_store/Cashier/make_payment.dart'; // Ensure this import is correct

class PayScreen extends StatefulWidget {
  final List<Map<String, String>> cartItems;
  final String username;

  PayScreen({
    required this.cartItems,
    required this.username,
  });

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  double get totalPrice {
    double total = 0.0;
    widget.cartItems.forEach((item) {
      total += double.parse(item['price']!.replaceAll('RM ', ''));
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: RM ${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MakePaymentScreen(
                        totalAmount: totalPrice,
                        cartItems: widget.cartItems,
                        username: widget.username,
                      ),
                    ),
                  );
                },
                child: Text('Make Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
