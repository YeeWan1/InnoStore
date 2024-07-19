import 'package:firebase_database/firebase_database.dart';

class ProductService {
  final DatabaseReference _productsRef = FirebaseDatabase.instance.ref().child('products');

  Stream<List<Map<String, String>>> fetchProducts() {
    return _productsRef.onValue.map((event) {
      if (event.snapshot.value == null) {
        return [];
      } else {
        final List<Map<String, String>> products = [];
        final productList = List<dynamic>.from(event.snapshot.value as List<dynamic>);
        for (var value in productList) {
          final Map<String, dynamic> product = Map<String, dynamic>.from(value);
          products.add({
            "title": product["title"],
            "category": product["category"],
            "price": product["price"],
            "image": product["image"],
          });
        }
        return products;
      }
    });
  }
}
