import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inno_store/Category/locateitem.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String imageUrl;
  final VoidCallback onAddToCart;

  ProductItem({
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.onAddToCart,
  });

  void _navigateToLocateItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocateItem(
          title: title,
          category: category,
          price: price,
          stockCount: 10, // Example: Assuming 10 items in stock
          imageUrl: imageUrl, // Pass imageUrl to LocateItem
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToLocateItem(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain, // Change to BoxFit.cover if you want to fill the container
                  ),
                ),
                Container(
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
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.add_circle, color: Colors.blue, size: 30),
                onPressed: onAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
