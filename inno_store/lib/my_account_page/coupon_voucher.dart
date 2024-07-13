import 'package:flutter/material.dart';
import 'profile.dart'; // Import the profile.dart file
import 'voucher_details.dart'; // Import the voucher_details.dart file
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CouponVoucherPage extends StatefulWidget {
  @override
  _CouponVoucherPageState createState() => _CouponVoucherPageState();
}

class _CouponVoucherPageState extends State<CouponVoucherPage> {
  List<Voucher> vouchers = [];
  bool _initialized = false; // Track if vouchers have been initialized

  void removeVoucher(Voucher voucher) {
    setState(() {
      vouchers.remove(voucher);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Coupon & Vouchers'),
              backgroundColor: Colors.blue,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Coupon & Vouchers'),
              backgroundColor: Colors.blue,
            ),
            body: Center(child: Text('Error loading profile data')),
          );
        }

        if (!_initialized) {
          final profile = snapshot.data as Map<String, dynamic>;
          final gender = profile['gender']?.toLowerCase() ?? '';
          final age = int.tryParse(profile['age'] ?? '0') ?? 0;
          final occupation = profile['occupation']?.toLowerCase() ?? '';

          vouchers = [
            BasicVoucher(
              category: 'Free Parking Voucher',
              discount: 'Free 2-Hour Parking',
              expiryDate: 'Expires on 05 Aug 2024',
              isExpiringSoon: false,
              description: 'Valid with parking ticket or Touch n\' Go. ',
              terms: 'Ticket and Touch n\'Go card validation at Inno Store carpark. '
                     'Not valid for car wash, money changers, banking, ATM transactions. '
                     'and utility payments. Limited redemption for order made via Inno Store App. '
                     'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                     'at any time without any prior notice.',
            ),
            BasicVoucher(
              category: 'New User Discount',
              discount: '30% OFF Coupon',
              expiryDate: 'Expires on 15 Jul 2024',
              isExpiringSoon: true,
              description: 'Valid for new user only.',
              terms: 'Coupon is valid for one-time use only. '
                     'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                     'at any time without any prior notice.',
            ),
          ];

          if (gender == 'female') {
            vouchers.add(FemaleVoucher(
              category: 'Make Up Discount',
              discount: 'Buy 2 Free 1',
              expiryDate: 'Expires on 31 Jul 2024',
              isExpiringSoon: false,
              description: 'Special to Female. Valid from 1/7/2024 to 31/7/2024 only.',
              terms: 'Limited redemption for order made via Inno Store App.'
                     'Selected products only. '
                     'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                     'at any time without any prior notice.',
            ));
          }

          if (age > 59) {
            vouchers.add(SeniorCitizenVoucher(
              category: 'Brand Coupon',
              discount: 'RM30 Off Supplement (Blackmores)',
              expiryDate: 'Expires on 06 Aug 2024',
              isExpiringSoon: false,
              description: 'Special to Senior Citizen. Valid from 7/7/2024 to 6/8/2024 only.',
              terms: 'Limited redemption for order made via Inno Store App.'
                     'Selected products only. '
                     'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                     'at any time without any prior notice.',
            ));
          }

          if (occupation == 'student') {
            vouchers.add(StudentVoucher(
              category: 'Student Special Offer',
              discount: '25% for All Groceries',
              expiryDate: 'Expires on 15 Aug 2024',
              isExpiringSoon: false,
              description: 'Special to Student. Valid from 16/7/2024 to 15/8/2024 only.',
              terms: 'Limited redemption for order made via Inno Store App.'
                     'Selected products only. '
                     'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                     'at any time without any prior notice.',
            ));
          }

          _initialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Coupon & Vouchers'),
            backgroundColor: Colors.blue,
          ),
          body: VoucherDetailsScreen(vouchers: vouchers, removeVoucher: removeVoucher), // Pass filtered vouchers to the screen
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
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
