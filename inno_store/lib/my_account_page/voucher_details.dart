import 'package:flutter/material.dart';
import 'coupon_voucher.dart'; // Import the coupon_voucher.dart file

class VoucherDetailsScreen extends StatelessWidget {
  final List<Voucher> vouchers;
  final Function(Voucher) removeVoucher;

  VoucherDetailsScreen({required this.vouchers, required this.removeVoucher});

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

abstract class Voucher {
  final String category;
  final String discount;
  final String expiryDate;
  final bool isExpiringSoon;
  final String description;
  final String terms;

  Voucher({
    required this.category,
    required this.discount,
    required this.expiryDate,
    required this.isExpiringSoon,
    required this.description,
    required this.terms,
  });
}

class BasicVoucher extends Voucher {
  BasicVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );
}

class FemaleVoucher extends Voucher {
  FemaleVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );
}

class SeniorCitizenVoucher extends Voucher {
  SeniorCitizenVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );
}

class StudentVoucher extends Voucher {
  StudentVoucher({
    required String category,
    required String discount,
    required String expiryDate,
    required bool isExpiringSoon,
    required String description,
    required String terms,
  }) : super(
          category: category,
          discount: discount,
          expiryDate: expiryDate,
          isExpiringSoon: isExpiringSoon,
          description: description,
          terms: terms,
        );
}

class VoucherCard extends StatelessWidget {
  final Voucher voucher;

  const VoucherCard({required this.voucher});

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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              voucher.discount,
              style: TextStyle(fontSize: 14),
            ),
            if (voucher.isExpiringSoon)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Expiring Soon',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(height: 8),
            Text(
              voucher.expiryDate,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class VoucherDetailScreen extends StatelessWidget {
  final Voucher voucher;
  final Function(Voucher) removeVoucher;

  const VoucherDetailScreen({required this.voucher, required this.removeVoucher});

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
            Center(
              child: Icon(
                Icons.card_giftcard,
                size: 80,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                voucher.discount,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                voucher.expiryDate,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              voucher.description,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              voucher.terms,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Redeem Voucher'),
                        content: Text('Once you redeem, the voucher will be used.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context); // Navigate back without removing the voucher
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              removeVoucher(voucher);
                              Navigator.pop(context); // Close the dialog
                              Navigator.pop(context); // Navigate back and remove the voucher
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Redeem'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
