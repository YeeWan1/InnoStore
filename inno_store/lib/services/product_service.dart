import 'package:firebase_database/firebase_database.dart';

class ProductService {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return _productsRef.onValue.map((event) {
      final data = event.snapshot.value;
      final List<Map<String, dynamic>> products = [];

      if (data is List) {
        // Handle case where data is a List
        for (var value in data) {
          if (value != null) {
            final Map<String, dynamic> product = Map<String, dynamic>.from(value);
            products.add({
              "title": product["title"],
              "category": product["category"],
              "price": product["price"],
              "image": product["image"],
              "quantity": product["quantity"] is int ? product["quantity"] : int.tryParse(product["quantity"].toString()) ?? 0,
            });
          }
        }
      } else if (data is Map) {
        // Handle case where data is a Map
        data.forEach((key, value) {
          final Map<String, dynamic> product = Map<String, dynamic>.from(value);
          products.add({
            "title": product["title"],
            "category": product["category"],
              "price": product["price"],
              "image": product["image"],
              "quantity": product["quantity"] is int ? product["quantity"] : int.tryParse(product["quantity"].toString()) ?? 0,
            });
          });
        }

        return products;
      });
    }

  Future<void> updateProductQuantity(String title, int newQuantity) async {
    final query = _productsRef.orderByChild('title').equalTo(title);
    final snapshot = await query.get();
    if (snapshot.exists) {
      final key = snapshot.children.first.key;
      await _productsRef.child(key!).update({'quantity': newQuantity});
    }
  }
}
