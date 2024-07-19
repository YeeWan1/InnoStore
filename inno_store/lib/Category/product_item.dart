import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String imageUrl;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  ProductItem({
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Category: $category'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Price: $price'),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onAddToCart,
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
