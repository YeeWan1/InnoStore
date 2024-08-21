import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inno_store/Cashier/cart_item.dart';

class MakePaymentScreen extends StatelessWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final String username;
  final VoidCallback onPaymentSuccess;
  final List<Map<String, dynamic>> appliedDiscounts;

  const MakePaymentScreen({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.username,
    required this.onPaymentSuccess,
    required this.appliedDiscounts,
  }) : super(key: key);

  Future<void> _handlePayment(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the in-time from Firestore
        DocumentSnapshot<Map<String, dynamic>> timeDoc = await FirebaseFirestore.instance
            .collection('time_spent_in_store')
            .doc(user.uid)
            .get();

        Timestamp inTime = timeDoc.data()?['in_time'];
        Timestamp outTime = Timestamp.now();

        // Calculate time spent in minutes
        int timeSpentMinutes = outTime.seconds - inTime.seconds;
        timeSpentMinutes = (timeSpentMinutes / 60).round();

        // Update Firestore with out-time and time spent
        await FirebaseFirestore.instance
            .collection('time_spent_in_store')
            .doc(user.uid)
            .update({
          'out_time': outTime,
          'time_spent_minutes': timeSpentMinutes,
        });

        // Add purchase history to Firestore
        await FirebaseFirestore.instance.collection('purchase_history').add({
          'userId': user.uid,
          'username': username,
          'items': cartItems.map((item) => item.toMap()).toList(),
          'totalPrice': totalAmount,
          'timestamp': FieldValue.serverTimestamp(),
          'discounts': appliedDiscounts,
        });

        // Show Payment Successful dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Payment Successful'),
            content: Text('Thank you for your purchase!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );

        onPaymentSuccess();
      } else {
        print('User is null, unable to process payment');
      }
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed. Please try again.')),
      );
    }
  }

  void _showPaymentSummary(BuildContext context, String paymentMethod) async {
    final shouldProceed = await showDialog<bool>(
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
              Navigator.of(context).pop(false); // User cancels payment
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // User confirms payment
            },
            child: Text('Pay'),
          ),
        ],
      ),
    );

    if (shouldProceed == true) {
      _handlePayment(context);
    }
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
