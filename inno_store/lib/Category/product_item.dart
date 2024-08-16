import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProductItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String imageUrl;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  ProductItem({
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.onAddToCart,
    required this.onTap,
  });

  bool _isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _getImageWidget(String imagePath) {
    if (_isBase64(imagePath)) {
      Uint8List bytes = base64Decode(imagePath);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: Icon(Icons.error));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Hero(
                        tag: title,
                        child: _getImageWidget(imageUrl),
                      ),
                      if (quantity == 0)  // Display "Out of Stock" if quantity is 0
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                'Out of Stock',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.blue),
                          onPressed: quantity > 0 ? onAddToCart : null,  // Disable adding to cart if out of stock
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    price,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Quantity: $quantity',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
