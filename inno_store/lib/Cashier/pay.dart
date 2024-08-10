import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/Cashier/make_payment.dart';
import 'package:inno_store/Cashier/voucher.dart' as cashier;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PayScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final String username;
  final VoidCallback onClearCart;
  final List<cashier.Voucher> redeemedVouchers;

  PayScreen({
    Key? key,
    required this.cartItems,
    required this.username,
    required this.onClearCart,
    this.redeemedVouchers = const [],
  }) : super(key: key);

  @override
  _PayScreenState createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  List<cashier.Voucher> selectedVouchers = [];
  List<cashier.Voucher> availableVouchers = [];
  List<Map<String, dynamic>> appliedDiscounts = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableVouchers();
  }

  double get totalPrice {
    double total = 0.0;
    widget.cartItems.forEach((item) {
      total += double.parse(item.price.replaceAll('RM ', '')) * item.quantity;
    });
    return total;
  }

  double calculateDiscountAmount(cashier.Voucher voucher) {
    double discount = 0.0;
  
    for (var item in widget.cartItems) {
      double itemPrice = double.parse(item.price.replaceAll('RM ', '')) * item.quantity;

      // Apply discount based on voucher type
      if (voucher is cashier.NewUserVoucher) {
        discount += itemPrice * 0.30; // 30% off total
      } 
      else if (voucher is cashier.FemaleVoucher && item.category.toLowerCase() == 'make up') {
        discount += itemPrice * 0.15; // 15% off Make Up products
      } 
      else if (voucher is cashier.SeniorCitizenVoucher && item.category.toLowerCase() == 'supplement') {
        discount += itemPrice > 30.0 ? 30.0 : itemPrice; // RM 30 off Supplement products or full price if less
      } 
      else if (voucher is cashier.StudentVoucher && item.category.toLowerCase() == 'groceries') {
        discount += itemPrice * 0.25; // 25% off Groceries products
      }
    }
  
    return discount;
  }

  double get discountAmount {
    double totalDiscount = 0.0;
    appliedDiscounts.clear();  // Clear previous applied discounts
    
    for (var voucher in selectedVouchers) {
      double discount = calculateDiscountAmount(voucher);
      totalDiscount += discount;
      appliedDiscounts.add({
        'voucher': voucher.category,
        'amount': discount,
      });
    }
    
    return totalDiscount;
  }

  double get discountedPrice {
    return totalPrice - discountAmount;
  }

  Future<void> fetchAvailableVouchers() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      setState(() {
        List<String> redeemedVoucherCategories = (userDoc['redeemedVouchers'] as List<dynamic>?)
            ?.map((item) => item as String)
            .toList() ?? [];
        availableVouchers = redeemedVoucherCategories.map<cashier.Voucher>((category) {
          switch (category) {
            case 'Make Up Discount':
              return cashier.FemaleVoucher(
                category: 'Make Up Discount',
                discount: '15% OFF',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Female. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
              );
            case 'Student Special Offer':
              return cashier.StudentVoucher(
                category: 'Student Special Offer',
                discount: '25% for All Groceries',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Student. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
              );
            case 'Supplement Discount':
              return cashier.SeniorCitizenVoucher(
                category: 'Supplement Discount',
                discount: 'RM30 Off Supplements',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Special to Senior Citizen. Valid from 10/8/2024 to 1/12/2024 only.',
                terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
              );
            case 'New User Discount':
              return cashier.NewUserVoucher(
                category: 'New User Discount',
                discount: '30% OFF Coupon',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: true,
                description: 'Valid for new user only.',
                terms: 'Coupon is valid for one-time use only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
              );
            case 'Free Parking Voucher':
              return cashier.BasicVoucher(
                category: 'Free Parking Voucher',
                discount: 'Free 2-Hour Parking',
                expiryDate: 'Expires on 1 Dec 2024',
                isExpiringSoon: false,
                description: 'Valid with parking ticket or Touch n\' Go. ',
                terms: 'Ticket and Touch n\'Go card validation at Inno Store carpark. Not valid for car wash, money changers, banking, ATM transactions, and utility payments. Limited redemption for order made via Inno Store App. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
              );
            default:
              throw Exception('Unknown voucher category');
          }
        }).toList();
      });
    }
  }

  void _selectVoucher(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Select Voucher / Coupon'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: availableVouchers.map((voucher) {
                    return CheckboxListTile(
                      title: Text('${voucher.category}\n${voucher.discount}'),
                      value: selectedVouchers.contains(voucher),
                      onChanged: (bool? value) {
                        setStateDialog(() {
                          if (value == true && !selectedVouchers.contains(voucher)) {
                            selectedVouchers.add(voucher);
                          } else {
                            selectedVouchers.remove(voucher);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedVouchers = List.from(selectedVouchers);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Ensures UI update after dialog is closed
      setState(() {});
    });
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
              'Total: RM ${discountedPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (selectedVouchers.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedVouchers.map((voucher) {
                  double voucherDiscount = calculateDiscountAmount(voucher);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voucher Applied: ${voucher.category}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      Text(
                        'You saved: RM ${voucherDiscount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  );
                }).toList(),
              ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Voucher / Coupon'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => _selectVoucher(context),
              ),
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
                    subtitle: Text(
                      'RM ${item.price.replaceAll('RM ', '')} x ${item.quantity}',
                    ),
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
                        totalAmount: discountedPrice,
                        cartItems: widget.cartItems,
                        username: widget.username,
                        appliedDiscounts: appliedDiscounts,
                        onPaymentSuccess: () {
                          widget.onClearCart();
                          setState(() {
                            availableVouchers = availableVouchers.where((voucher) => !selectedVouchers.contains(voucher)).toList();
                            selectedVouchers.clear(); // Clear selected vouchers after payment
                          });
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
