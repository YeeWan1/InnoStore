import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/Cashier/voucher.dart' as cashier;
import 'package:inno_store/my_account_page/voucher_details.dart';

class CouponVoucherPage extends StatefulWidget {
  @override
  _CouponVoucherPageState createState() => _CouponVoucherPageState();
}

class _CouponVoucherPageState extends State<CouponVoucherPage> {
  List<cashier.Voucher> vouchers = [];
  bool _initialized = false;

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

        if (snapshot.hasData) {
          if (!_initialized) {
            final profile = snapshot.data as Map<String, dynamic>;
            final gender = profile['gender']?.toLowerCase() ?? '';
            final age = int.tryParse(profile['age'] ?? '0') ?? 0;
            final occupation = profile['occupation']?.toLowerCase() ?? '';
            final redeemedVouchersList = List<String>.from(profile['redeemedVouchers'] ?? []);
            final usedVouchersList = List<String>.from(profile['usedVouchers'] ?? []);

            vouchers = [
              cashier.BasicVoucher(
                category: 'Free Parking Voucher',
                discount: 'Free 2-Hour Parking',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Valid with parking ticket or Touch n\' Go. ',
                terms: 'Ticket and Touch n\'Go card validation at Inno Store carpark. '
                       'Not valid for car wash, money changers, banking, ATM transactions. '
                       'and utility payments. Limited redemption for order made via Inno Store App. '
                       'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                       'at any time without any prior notice.',
              ),
              cashier.BasicVoucher(
                category: 'New User Discount',
                discount: '30% OFF Coupon',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: true,
                description: 'Valid for new user only.',
                terms: 'Coupon is valid for one-time use only. '
                       'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                       'at any time without any prior notice.',
              ),
            ];

            if (gender == 'female') {
              vouchers.add(cashier.FemaleVoucher(
                category: 'Make Up Discount',
                discount: '15% OFF',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Female. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App.'
                       'Selected products only. '
                       'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                       'at any time without any prior notice.',
              ));
            }

            if (age > 59) {
              vouchers.add(cashier.SeniorCitizenVoucher(
                category: 'Supplement Discount',
                discount: 'RM30 Off Supplements',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Senior Citizen. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App.'
                       'Selected products only. '
                       'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                       'at any time without any prior notice.',
              ));
            }

            if (occupation == 'student') {
              vouchers.add(cashier.StudentVoucher(
                category: 'Student Special Offer',
                discount: '25% for All Groceries',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Student. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App.'
                       'Selected products only. '
                       'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                       'at any time without any prior notice.',
              ));
            }

            // Filter out vouchers that have been redeemed or used
            vouchers = vouchers.where((voucher) => 
              !redeemedVouchersList.contains(voucher.category) &&
              !usedVouchersList.contains(voucher.category)
            ).toList();

            _initialized = true;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Coupon & Vouchers'),
            backgroundColor: Colors.blue,
          ),
          body: VoucherDetailsScreen(vouchers: vouchers, removeVoucher: removeVoucher),
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

  void removeVoucher(cashier.Voucher voucher) async {
    setState(() {
      vouchers.removeWhere((v) => v.category == voucher.category);
    });
    await markVoucherAsRedeemed(voucher); // Correctly store in redeemedVouchers
  }

  Future<void> markVoucherAsRedeemed(cashier.Voucher voucher) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'redeemedVouchers': FieldValue.arrayUnion([voucher.category]) // Corrected field
      });
    }
  }
}
