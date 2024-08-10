import 'package:inno_store/Cashier/voucher.dart' as cashier;

class CartItem {
  final String title;
  final String price;
  final String category;
  int quantity;
  List<cashier.Voucher> appliedVouchers;

  CartItem({
    required this.title,
    required this.price,
    required this.category,
    this.quantity = 1,
    this.appliedVouchers = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'quantity': quantity,
      'appliedVouchers': appliedVouchers.map((voucher) => voucher.toMap()).toList(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      price: map['price'],
      category: map['category'],
      quantity: map['quantity'],
      appliedVouchers: (map['appliedVouchers'] as List<dynamic>?)
              ?.map((voucherMap) => cashier.Voucher.fromMap(voucherMap))
              .toList() ??
          [],
    );
  }
}
