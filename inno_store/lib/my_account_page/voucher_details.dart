import 'package:flutter/material.dart';
import 'coupon_voucher.dart'; // Import the coupon_voucher.dart file
import 'package:inno_store/Cashier/voucher.dart' as cashier;

class VoucherDetailsScreen extends StatelessWidget {
  final List<cashier.Voucher> vouchers;
  final Function(cashier.Voucher) removeVoucher;

  const VoucherDetailsScreen({Key? key, required this.vouchers, required this.removeVoucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: vouchers.length,
          itemBuilder: (context, index) {
            final voucher = vouchers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VoucherDetailScreen(
                        voucher: voucher,
                        removeVoucher: removeVoucher,
                      ),
                    ),
                  );
                },
                child: VoucherCard(voucher: voucher),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  final cashier.Voucher voucher;

  const VoucherCard({Key? key, required this.voucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              voucher.category,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              voucher.discount,
              style: const TextStyle(fontSize: 14),
            ),
            if (voucher.isExpiringSoon)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
            const SizedBox(height: 8),
            Text(
              voucher.expiryDate,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherDetailScreen extends StatelessWidget {
  final cashier.Voucher voucher;
  final Function(cashier.Voucher) removeVoucher;

  const VoucherDetailScreen({Key? key, required this.voucher, required this.removeVoucher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(voucher.category),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.card_giftcard,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                voucher.discount,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                voucher.expiryDate,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              voucher.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              voucher.terms,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Redeem Voucher'),
                        content: const Text('Once you redeem, the voucher will be used.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context); // Navigate back without removing the voucher
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              removeVoucher(voucher);
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(context); // Navigate back and remove the voucher
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Redeem'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
