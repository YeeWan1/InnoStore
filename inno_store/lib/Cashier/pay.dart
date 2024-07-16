import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/make_payment.dart'; // Ensure this import is correct

class PayScreen extends StatefulWidget {
  final List<Map<String, String>> cartItems;
  final String username;
  final VoidCallback onClearCart; // Add this callback

  PayScreen({
    required this.cartItems,
    required this.username,
    required this.onClearCart, // Ensure this is required
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
            Text(
              'Cart Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item['title']!),
                    subtitle: Text(item['price']!),
                  );
                },
              ),
            ),
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
                        onPaymentSuccess: () {
                          widget.onClearCart(); // Clear the cart after payment
                        },
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
