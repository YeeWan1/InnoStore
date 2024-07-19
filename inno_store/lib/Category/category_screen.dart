import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/services/product_service.dart';
import 'package:inno_store/Category/locateitem.dart';
import 'package:inno_store/Category/product_item.dart';

class CategoryScreen extends StatefulWidget {
  final Function(List<CartItem>) navigateToPayment;

  CategoryScreen({required this.navigateToPayment});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'All';
  String searchText = '';
  List<CartItem> cartItems = [];

  void addToCart(Map<String, String> product) {
    setState(() {
      var existingItem = cartItems.firstWhere(
          (item) => item.title == product['title'],
          orElse: () => CartItem(title: '', price: '', category: ''));
      if (existingItem.title.isNotEmpty) {
        existingItem.quantity += 1;
      } else {
        cartItems.add(CartItem(
          title: product['title']!,
          price: product['price']!,
          category: product['category']!,
        ));
      }
    });
  }

  void navigateToLocateItem(Map<String, String> product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocateItem(
          title: product['title']!,
          category: product['category']!,
          price: product['price']!,
          stockCount: 10, // Placeholder value, update with actual stock count
          imageUrl: product['image']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProductService productService = ProductService();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.blue,
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    buildCategoryItem('All', Icons.all_inclusive),
                    buildCategoryItem('Nutrition', Icons.local_dining),
                    buildCategoryItem('Supplements', Icons.medical_services),
                    buildCategoryItem('Tonic', Icons.local_drink),
                    buildCategoryItem('Foot Treatment', Icons.spa),
                    buildCategoryItem('Traditional Medicine', Icons.healing),
                    buildCategoryItem('Groceries', Icons.shopping_cart),
                    buildCategoryItem('Coffee', Icons.local_cafe),
                    buildCategoryItem('Dairy Product', Icons.local_drink),
                    buildCategoryItem('Make Up', Icons.brush),
                    buildCategoryItem('Pets Care', Icons.pets),
                    buildCategoryItem('Hair Care', Icons.face),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, String>>>(
                    stream: productService.fetchProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No products available"));
                      }

                      List<Map<String, String>> filteredProducts = snapshot.data!
                          .where((product) =>
                              selectedCategory == 'All' ||
                              product["category"] == selectedCategory)
                          .where((product) => product["title"]!
                              .toLowerCase()
                              .contains(searchText.toLowerCase()))
                          .toList();

                      filteredProducts.sort((a, b) =>
                          a["title"]!.compareTo(b["title"]!));

                      return GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2 / 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (ctx, i) => ProductItem(
                          title: filteredProducts[i]["title"]!,
                          category: filteredProducts[i]["category"]!,
                          price: filteredProducts[i]["price"]!,
                          imageUrl: filteredProducts[i]["image"]!,
                          onAddToCart: () => addToCart(filteredProducts[i]),
                          onTap: () => navigateToLocateItem(filteredProducts[i]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.navigateToPayment(cartItems);
        },
        child: Icon(Icons.payment),
      ),
    );
  }

  Widget buildCategoryItem(String title, IconData icon) {
    bool isSelected = title == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.blue : Colors.black),
            Text(
              title,
              style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue : Colors.black),
              textAlign: TextAlign.center,
            ),
            Divider(height: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
