import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/services/product_service.dart';
import 'package:inno_store/Category/locateitem.dart';
import 'package:inno_store/Category/product_item.dart';

class CategoryScreen extends StatefulWidget {
  final Function(List<CartItem>) navigateToPayment;

  const CategoryScreen({required this.navigateToPayment});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'all';
  String searchText = '';
  List<CartItem> cartItems = [];

  void addToCart(Map<String, String> product) {
    setState(() {
      var existingItem = cartItems.firstWhere(
          (item) => item.title == product['title'],
          orElse: () => CartItem(title: '', price: '', category: '', quantity: 0));
      if (existingItem.title.isNotEmpty) {
        existingItem.quantity += 1;
      } else {
        cartItems.add(CartItem(
          title: product['title']!,
          price: product['price']!,
          category: product['category']!,
          quantity: 1, // Add initial quantity
        ));
      }
    });
  }

  void navigateToLocateItem(Map<String, String> product) {
    print("Navigating to LocateItem with image URL: ${product['image']}");
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocateItem(
          title: product['title']!,
          category: product['category']!,
          price: product['price']!,
          stockCount: int.parse(product['quantity']!), // Update with actual stock count
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
                    buildCategoryItem('all', Icons.all_inclusive, 'All'),
                    buildCategoryItem('nutrition', Icons.local_dining, 'Nutrition'),
                    buildCategoryItem('supplement', Icons.medical_services, 'Supplements'),
                    buildCategoryItem('tonic', Icons.local_drink, 'Tonic'),
                    buildCategoryItem('foot treatment', Icons.spa, 'Foot Treatment'),
                    buildCategoryItem('traditional medicine', Icons.healing, 'Traditional Medicine'),
                    buildCategoryItem('groceries', Icons.shopping_cart, 'Groceries'),
                    buildCategoryItem('coffee', Icons.local_cafe, 'Coffee'),
                    buildCategoryItem('dairy product', Icons.local_drink, 'Dairy Product'),
                    buildCategoryItem('make up', Icons.brush, 'Make Up'),
                    buildCategoryItem('pets care', Icons.pets, 'Pets Care'),
                    buildCategoryItem('hair care', Icons.face, 'Hair Care'),
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
                              selectedCategory == 'all' ||
                              product["category"]?.toLowerCase() == selectedCategory)
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
                          childAspectRatio: 2 / 3.2,
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

  Widget buildCategoryItem(String category, IconData icon, String displayTitle) {
    bool isSelected = category == selectedCategory;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.blue : Colors.black),
            Text(
              displayTitle,
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
