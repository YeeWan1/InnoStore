import 'package:flutter/material.dart';
import 'package:inno_store/Cashier/cart_item.dart';
import 'package:inno_store/Cashier/voucher.dart' as cashier;
import 'package:inno_store/services/product_service.dart';
import 'package:inno_store/Category/locateitem.dart';
import 'package:inno_store/Category/product_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inno_store/my_account_page/voucher_details.dart';
import 'package:inno_store/my_account_page/coupon_voucher.dart';

class CategoryScreen extends StatefulWidget {
  final Function(List<CartItem>, List<cashier.Voucher>) navigateToPayment;

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
  List<cashier.Voucher> redeemedVouchers = [];

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
    fetchRedeemedVouchers();
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

  Future<void> fetchRedeemedVouchers() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        setState(() {
            List<String> redeemedVoucherCategories = (userDoc['redeemedVouchers'] as List<dynamic>?)
                ?.map((item) => item as String)
                .toList() ?? [];
            redeemedVouchers = redeemedVoucherCategories.toSet().map<cashier.Voucher>((category) {
                switch (category) {
                    case 'Make Up Discount':
                        return cashier.FemaleVoucher(
                            category: 'Make Up Discount',
                            discount: '15% OFF',
                            expiryDate: 'Expires on 1 Dec 2024', // Updated date
                            isExpiringSoon: false,
                            description: 'Special to Female. Valid from 10/8/2024 to 1/12/2024 only.',
                            terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
                        );
                    case 'Student Special Offer':
                        return cashier.StudentVoucher(
                            category: 'Student Special Offer',
                            discount: '25% for All Groceries',
                            expiryDate: 'Expires on 1 Dec 2024', // Updated date
                            isExpiringSoon: false,
                            description: 'Special to Student. Valid from 10/8/2024 to 1/12/2024 only.',
                            terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
                        );
                    case 'Supplement Discount':
                        return cashier.SeniorCitizenVoucher(
                            category: 'Supplement Discount',
                            discount: 'RM30 Off Supplements',
                            expiryDate: 'Expires on 1 Dec 2024', // Updated date
                            isExpiringSoon: false,
                            description: 'Special to Senior Citizen. Valid from 10/8/2024 to 1/12/2024 only.',
                            terms: 'Limited redemption for order made via Inno Store App. Selected products only. Inno Store reserves the right to amend the Terms & Conditions of this promotion at any time without any prior notice.',
                        );
                    default:
                        throw Exception('Unknown voucher category');
                }
            }).toList();
        });
    }
  }

  Future<void> checkForVoucherNotification() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      final gender = userDoc['gender']?.toLowerCase() ?? '';
      final age = int.tryParse(userDoc['age'] ?? '0') ?? 0;
      final occupation = userDoc['occupation']?.toLowerCase() ?? '';
      final redeemedVouchersList = List<String>.from(userDoc['redeemedVouchers'] ?? []);

      if (selectedCategory == 'make up' && gender == 'female' && !redeemedVouchersList.contains('Make Up Discount')) {
        showVoucherNotification(
          'Make Up Discount',
          'You have a special discount for Make Up products!',
          cashier.FemaleVoucher(
            category: 'Make Up Discount',
            discount: '15% OFF',
            expiryDate: 'Expires on 1 Dec 2024',
            isExpiringSoon: false,
            description: 'Special to Female. Valid from 10/8/2024 to 1/12/2024 only.',
            terms: 'Limited redemption for order made via Inno Store App.'
                   'Selected products only. '
                   'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                   'at any time without any prior notice.',
          ),
        );
      } else if (selectedCategory == 'groceries' && occupation == 'student' && !redeemedVouchersList.contains('Student Special Offer')) {
        showVoucherNotification(
          'Student Special Offer',
          'You have a special discount for Groceries!',
          cashier.StudentVoucher(
            category: 'Student Special Offer',
            discount: '25% for All Groceries',
            expiryDate: 'Expires on 1 Dec 2024',
            isExpiringSoon: false,
            description: 'Special to Student. Valid from 10/8/2024 to 1/12/2024 only.',
            terms: 'Limited redemption for order made via Inno Store App.'
                   'Selected products only. '
                   'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                   'at any time without any prior notice.',
          ),
        );
      } else if (selectedCategory == 'supplement' && age > 59 && !redeemedVouchersList.contains('Supplement Discount')) {
        showVoucherNotification(
          'Supplement Discount',
          'You have a special discount for Supplement products!',
          cashier.SeniorCitizenVoucher(
            category: 'Supplement Discount',
            discount: 'RM30 Off Supplements',
            expiryDate: 'Expires on 1 Dec 2024',
            isExpiringSoon: false,
            description: 'Special to Senior Citizen. Valid from 10/8/2024 to 1/12/2024 only.',
            terms: 'Limited redemption for order made via Inno Store App.'
                   'Selected products only. '
                   'Inno Store reserves the right to amend the Terms & Conditions of this promotion '
                   'at any time without any prior notice.',
          ),
        );
      }
    }
  }

  void showVoucherNotification(String title, String message, cashier.Voucher voucher) {
    if (!redeemedVouchers.any((v) => v.category == voucher.category)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              Text("Your Voucher", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Divider(),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  redeemedVouchers.add(voucher);
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VoucherDetailScreen(
                      voucher: voucher,
                      removeVoucher: (v) async {
                        await markVoucherAsRedeemed(v);
                      },
                    ),
                  ),
                );
              },
              child: Text('View'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> markVoucherAsRedeemed(cashier.Voucher voucher) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'redeemedVouchers': FieldValue.arrayUnion([voucher.category])
      });
    }
    setState(() {
      redeemedVouchers.add(voucher); // Ensure local state is also updated
    });
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
          widget.navigateToPayment(cartItems, redeemedVouchers);
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
          checkForVoucherNotification(); // Ensure notification check runs when category is changed
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
