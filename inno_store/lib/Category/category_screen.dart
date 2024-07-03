import 'package:flutter/material.dart';
import 'package:inno_store/assets.dart';  // Add this import

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
  String selectedCategory = 'Health Care';
  String searchText = '';

  final Map<String, List<Map<String, String>>> categoryProducts = {
    'Health Care': [
      {"title": "Swisse Ultiboost Vitamin C + Manuka Honey 120 Tablets", "image": Assets.vitaminc},
      {"title": "Swisse Ultiboost High Strength Krill Oil 30 Capsules", "image": Assets.krilloil},
    ],
    // other categories...

    'Groceries': [
      {"title": "Nestle Koko Krunch 450g", "image": Assets.kokokrunch},
      // add more products
    ],


    'Make Up': [
    
      // add more products
    ],
    'Pets Care': [
     
      // add more products
    ],
    'Household and Lifestyle': [
     
      // add more products
    ],
    'Hair Care': [
   
      // add more products
    ],
  };

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredProducts = categoryProducts[selectedCategory]!
        .where((product) => product["title"]!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            child: Drawer(
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
                  buildCategoryItem('Health Care', Icons.local_hospital),
                  buildCategoryItem('Groceries', Icons.shopping_cart),
                  buildCategoryItem('Make Up', Icons.brush),
                  buildCategoryItem('Pets Care', Icons.pets),
                  buildCategoryItem('Household and Lifestyle', Icons.home),
                  buildCategoryItem('Hair Care', Icons.face),
                ],
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
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (ctx, i) => ProductItem(
                      filteredProducts[i]["title"]!,
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
  final String imageUrl;

  ProductItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
