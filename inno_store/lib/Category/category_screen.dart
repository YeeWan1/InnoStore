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
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];

  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    productService.fetchProducts().listen((products) {
      setState(() {
        allProducts = products;
        filterProducts();
      });
    });
  }

  void filterProducts() {
    filteredProducts = allProducts
        .where((product) =>
            selectedCategory == 'all' ||
            product["category"]?.toLowerCase() == selectedCategory)
        .where((product) => product["title"]
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    filteredProducts.sort((a, b) => a["title"].compareTo(b["title"]));
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      var existingItem = cartItems.firstWhere(
        (item) => item.title == product['title'],
        orElse: () => CartItem(title: '', price: '', category: '', quantity: 0),
      );
      if (existingItem.title.isNotEmpty) {
        existingItem.quantity += 1;
      } else {
        cartItems.add(CartItem(
          title: product['title'],
          price: product['price'],
          category: product['category'],
          quantity: 1,
        ));
      }

      int currentQuantity = product['quantity'];
      int newQuantity = currentQuantity - 1;
      product['quantity'] = newQuantity;
      productService.updateProductQuantity(product['title'], newQuantity);
    });
  }

  void navigateToLocateItem(Map<String, dynamic> product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocateItem(
          title: product['title'],
          category: product['category'],
          price: product['price'],
          stockCount: product['quantity'],
          imageUrl: product['image'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        filterProducts();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 3.2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (ctx, i) => ProductItem(
                      title: filteredProducts[i]["title"],
                      category: filteredProducts[i]["category"],
                      price: filteredProducts[i]["price"],
                      imageUrl: filteredProducts[i]["image"],
                      quantity: filteredProducts[i]["quantity"],
                      onAddToCart: () => addToCart(filteredProducts[i]),
                      onTap: () => navigateToLocateItem(filteredProducts[i]),
                    ),
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
          filterProducts();
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
