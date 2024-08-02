import 'package:inno_store/Cashier/voucher.dart' as cashier;

class CartItem {
  final String title;
  final String price;
  final String category;
  int quantity;
  cashier.Voucher? appliedVoucher;

  CartItem({
    required this.title,
    required this.price,
    required this.category,
    this.quantity = 1,
    this.appliedVoucher,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'quantity': quantity,
      'appliedVoucher': appliedVoucher?.toMap(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      price: map['price'],
      category: map['category'],
      quantity: map['quantity'],
      appliedVoucher: map['appliedVoucher'] != null
          ? cashier.Voucher.fromMap(map['appliedVoucher'])
          : null,
    );
  }
}
