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
      {"title": "Blackmores Digestive Enzymes Plus Capsule 60s", "image": Assets.enzymesplus},
      {"title": "Blackmores Bio Ace Plus Capsule 30s", "image": Assets.bioaceplus},
      {"title": "Blackmores Bio Zinc Capsule 168s", "image": Assets.biozinc},
      {"title": "Blackmores Buffered C Capsule 30s", "image": Assets.bufferedc},
      {"title": "EYS Bird's Nest With Rock Sugar", "image": Assets.birdnest},
      {"title": "EYS Pure Chicken Essence", "image": Assets.chickenessence},
      {"title": "HM Euphoria Longana Honey", "image": Assets.honey},
      {"title": "Brand's Essence of Chicken 70g x 30's", "image": Assets.brands},
    ],

    'Groceries': [
      {"title": "Nestle Koko Krunch 450g", "image": Assets.kokokrunch},
      {"title": "Saji Brand Cooking Oil 5kg", "image": Assets.saji},
      {"title": "Knife Cooking Oil 5kg", "image": Assets.knifeoil},
      {"title": "Maggi Curry Flavour Instant Noodles 79g x 5", "image": Assets.maggiekari},
      {"title": "Old Town 2 in 1 White Coffee (Coffee & Creamer) 375g", "image": Assets.oldtown},
      {"title": "Old Town 3-in-1 Hazelnut Instant White Coffee 570g", "image": Assets.oldtownhazelnut},
      {"title": "Yeo's Chicken Curry with Potatoes 280g", "image": Assets.yeoscurry},
      {"title": "Jasmine Super 5 White Rice Imported 5kg", "image": Assets.jasmine},
      {"title": "Ayam Brand Mackerel in Tomato Sauce 230g", "image": Assets.tomatosauce},
      {"title": "Cap Rambutan 5% Super Import White Rice 5kg", "image": Assets.rambutans},
      {"title": "Milo Original Chocolate Malt Drink 30g x 18", "image": Assets.milo},
      {"title": "Nestle Kit Kat Sharebag Value Pack 17g x 24", "image": Assets.kitkat},
      {"title": "Milo Soft Pack 2kg", "image": Assets.milo2kg},
    ],

    'Make Up': [
      {"title": "Garnier Skin Naturals Micellar Water Pink 125ml", "image": Assets.garnier},
      {"title": "Reihaku Hatomugi Whip Face Wash Cleansing Water (Make Up Remover) 200ml", "image": Assets.hatomugi},
      {"title": "Garnier Micellar Salicylic BHA 125ml", "image": Assets.garnierblue},
      {"title": "Silky White Bright Up Liquid Foundation 01 Light", "image": Assets.foundation},
      {"title": "Palladio Herbal Foundation Tube PFS01 Ivory", "image": Assets.palladio},
      {"title": "Palladio Herbal Foundation Tube PFS02 Porcelain", "image": Assets.palladio02},
      {"title": "Palladio Dual Wet & Dry Foundation WD400 Laurel Nude", "image": Assets.dryfoundation},
      {"title": "Palladio Dual Wet & Dry Foundation WD401 Ivory Myrrh", "image": Assets.dryfoundation401},
      {"title": "Rimmel Wonder'Ink Ultimate Waterproof Eyeliner", "image": Assets.eyeliner},
      {"title": "SilkyGirl Long-Wearing Eyeliner 01 Black Black", "image": Assets.eyelinerblack},
    
    ],
    'Pets Care': [
     {"title": "Dog Dry Food Chicken & Veg 3kg", "image": Assets.pedigree},
     {"title": "Cat Wet Food Flake Tuna in Gravy 85gm", "image": Assets.sheba},
     {"title": "Dog Oral Care Dentastix Toy 60g", "image": Assets.dogoral},
     {"title": "Pottty Here Training Aid Spray 8Oz", "image": Assets.naturvet},
     {"title": "Ear Wash Liquid 4Oz", "image": Assets.earwash},
     {"title": "Peony Anti-Bacteria Formula Pets Shampoo 400ml", "image": Assets.shampoo},
     {"title": "Unique Pet Shower Silicon Brush with Soap Container", "image": Assets.brush},
     
    ],

    'Hair Care': [
      {"title": "KUNDAL Honey & Macadamia Nature Shampoo - Cherry Blossom 500ml", "image": Assets.kundalshampoo},
      {"title": "Kundal Honey & Macadamia Hair Treatment - Cherry Blossom 500ml", "image": Assets.kundalhoney},
      {"title": "Grafen Perfume Hair Shampoo Emerald Blossom 500ml (Anti-Hair Loss)", "image": Assets.grafen},
      {"title": "Ryo Hair Loss Expert Scalp Massage Essence 80ml", "image": Assets.ryo},
      {"title": "Kundal Caffeine Scalp Care Tonic 100ml", "image": Assets.hairtonic},
      {"title": "Pantene 3Mm Conditioner 480Ml Keratin Silky Smooth", "image": Assets.pantene},
      {"title": "Amino Mason Treatment Night Recipe Sleek 450Ml", "image": Assets.amino},   
      {"title": "Ryo Damage Care And Nourishing Shampoo 480ml", "image": Assets.ryodamage},   
    
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
                      childAspectRatio: 2/3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
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
