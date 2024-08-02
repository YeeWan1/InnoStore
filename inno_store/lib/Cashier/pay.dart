import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/make_payment.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/Cashier/voucher.dart' as cashier;

class PayScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final String username;
  final VoidCallback onClearCart;
  final cashier.Voucher? appliedVoucher;

  PayScreen({
    required this.cartItems,
    required this.username,
    required this.onClearCart,
    this.appliedVoucher,
  });

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  double get totalPrice {
    double total = 0.0;
    double discount = 0.0;

    for (var item in widget.cartItems) {
      double itemPrice = double.parse(item.price.replaceAll('RM ', ''));
      double itemTotal = itemPrice * item.quantity;

      if (widget.appliedVoucher != null) {
        if (widget.appliedVoucher!.category == 'New User Discount') {
          discount += itemTotal * 0.3;
        } else if (widget.appliedVoucher!.category == 'Student Special Offer' &&
            item.category.toLowerCase() == 'groceries') {
          discount += itemTotal * 0.25;
        }
      }

      total += itemTotal;
    }

    return total - discount;
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
            if (widget.appliedVoucher != null)
              Text(
                'Voucher Applied: ${widget.appliedVoucher!.discount}',
                style: TextStyle(fontSize: 16, color: Colors.green),
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
                        appliedVoucher: widget.appliedVoucher,
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
