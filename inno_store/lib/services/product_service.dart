import 'package:firebase_database/firebase_database.dart';

class ProductService {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  Stream<List<Map<String, dynamic>>> fetchProducts() {
    return _productsRef.onValue.map((event) {
      if (event.snapshot.value == null) {
        return [];
      } else {
        final List<Map<String, dynamic>> products = [];
        final productList = List<dynamic>.from(event.snapshot.value as List<dynamic>);
        for (var value in productList) {
          final Map<String, dynamic> product = Map<String, dynamic>.from(value);
          products.add({
            "title": product["title"],
            "category": product["category"],
            "price": product["price"],
            "image": product["image"],
            "quantity": product["quantity"] is int ? product["quantity"] : int.tryParse(product["quantity"].toString()) ?? 0, // Ensure quantity is handled as int
          });
        }
        return products;
      }
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
