import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inno_store/Cashier/cart_item.dart';

class MakePaymentScreen extends StatelessWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final String username;
  final VoidCallback onPaymentSuccess;

  MakePaymentScreen({
    required this.totalAmount,
    required this.cartItems,
    required this.username,
    required this.onPaymentSuccess,
  });

  Future<void> _handlePayment(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Debug statement to print user details
        print('Processing payment for user UID: ${user.uid}, Username: $username');

        await FirebaseFirestore.instance.collection('purchase_history').add({
          'userId': user.uid,
          'username': username,
          'items': cartItems.map((item) => item.toMap()).toList(),
          'totalPrice': totalAmount,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Debug statement to confirm successful write operation
        print('Purchase history successfully written to Firestore');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful! Thank you')),
        );

        onPaymentSuccess();
      } else {
        // Debug statement for null user
        print('User is null, unable to process payment');
      }
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  void _showPaymentSummary(BuildContext context, String paymentMethod) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Payment Method: $paymentMethod'),
            Text('Total Amount: RM ${totalAmount.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handlePayment(context);
            },
            child: Text('Pay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Online Banking'),
            onTap: () {
              _showPaymentSummary(context, 'Online Banking');
            },
          ),
          ListTile(
            leading: Image.asset('assets/cashier/visa.png', width: 50, height: 50),
            title: Text('Visa'),
            onTap: () {
              _showPaymentSummary(context, 'Visa');
            },
          ),
          ListTile(
            leading: Image.asset('assets/cashier/mastercard.png', width: 50, height: 50),
            title: Text('MasterCard'),
            onTap: () {
              _showPaymentSummary(context, 'MasterCard');
            },
          ),
          ListTile(
            leading: Image.asset('assets/cashier/touch_n_go.png', width: 50, height: 50),
            title: Text('Touch N Go'),
            onTap: () {
              _showPaymentSummary(context, 'Touch N Go');
            },
          ),
          ListTile(
            leading: Image.asset('assets/cashier/boost.png', width: 50, height: 50),
            title: Text('Boost'),
            onTap: () {
              _showPaymentSummary(context, 'Boost');
            },
          ),
          ListTile(
            leading: Image.asset('assets/cashier/grabpay.png', width: 50, height: 50),
            title: Text('GrabPay'),
            onTap: () {
              _showPaymentSummary(context, 'GrabPay');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/home');
        },
        child: Icon(Icons.home),
      ),
    );
  }
}
