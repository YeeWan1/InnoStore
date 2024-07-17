// lib/Cashier/cart_item.dart
class CartItem {
  final String title;
  final String price;
  final String category;
  int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.category,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      price: map['price'],
      category: map['category'],
      quantity: map['quantity'],
    );
  }
}
