import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/make_payment.dart';
import 'cart_item.dart';

class PayScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final String username;
  final VoidCallback onClearCart;

  PayScreen({
    required this.cartItems,
    required this.username,
    required this.onClearCart,
  });

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  double get totalPrice {
    double total = 0.0;
    widget.cartItems.forEach((item) {
      total += double.parse(item.price.replaceAll('RM ', '')) * item.quantity;
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
                    title: Text('${index + 1}) ${item.title}'),
                    subtitle: Text('RM ${item.price} x ${item.quantity}'),
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
                        onPaymentSuccess: widget.onClearCart,
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
