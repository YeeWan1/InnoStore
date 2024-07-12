import 'package:flutter/material.dart';
import 'package:inno_store/category/products/all.dart';
import 'package:inno_store/category/products/nutrition.dart';
import 'package:inno_store/category/products/supplements.dart';
import 'package:inno_store/category/products/tonic.dart';
import 'package:inno_store/category/products/foot_treatment.dart';
import 'package:inno_store/category/products/traditional_medicine.dart';
import 'package:inno_store/category/products/groceries.dart';
import 'package:inno_store/category/products/coffee.dart';
import 'package:inno_store/category/products/dairy_product.dart';
import 'package:inno_store/category/products/makeup.dart';
import 'package:inno_store/category/products/petscare.dart';
import 'package:inno_store/category/products/haircare.dart';
import 'package:inno_store/category/locateitem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inno Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoryScreen(),
    );
  }
}

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'All';
  String searchText = '';

  final Map<String, List<Map<String, String>>> categoryProducts = {
    'All': allProducts,
    'Nutrition': nutritionProducts,
    'Supplements': supplementsProducts,
    'Tonic': tonicProducts,
    'Foot Treatment': footTreatmentProducts,
    'Traditional Medicine': traditionalMedicineProducts,
    'Groceries': groceriesProducts,
    'Coffee': coffeeProducts,
    'Dairy Product': dairyProductProducts,
    'Make Up': makeupProducts,
    'Pets Care': petsCareProducts,
    'Hair Care': hairCareProducts,
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredProducts = categoryProducts[selectedCategory]!
        .where((product) => product["title"]!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    filteredProducts.sort((a, b) => a["title"]!.compareTo(b["title"]!));

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
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2/3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (ctx, i) => ProductItem(
                      filteredProducts[i]["title"]!,
                      filteredProducts[i]["category"]!,
                      filteredProducts[i]["price"]!,
                      filteredProducts[i]["image"]!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.blue : Colors.black), // Change icon color when selected
            Text(
              title,
              style: TextStyle(fontSize: 12, color: isSelected ? Colors.blue : Colors.black), // Change text color when selected
              textAlign: TextAlign.center,
            ),
            Divider(height: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String imageUrl;

  ProductItem(this.title, this.category, this.price, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocateItem( // Update to LocateItem
              title: title,
              category: category,
              price: price,
              stockCount: 10, // Example: Assuming 10 items in stock
              imageUrl: imageUrl, // Pass imageUrl to LocateItem
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      category,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      price,
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
