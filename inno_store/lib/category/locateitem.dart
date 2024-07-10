import 'package:flutter/material.dart';
import 'package:inno_store/Map/map_screen.dart';

class LocateItem extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final int stockCount;
  final String imageUrl;

  LocateItem({
    required this.title,
    required this.category,
    required this.price,
    required this.stockCount,
    required this.imageUrl,
  });

  // Method to determine coordinates based on category
  Offset getCoordinatesForCategory(String category) {
    switch (category) {
      case 'Nutrition':
        return Offset(1.45, 0.55); // Coordinates for Nutrition
      case 'Supplement':
        return Offset(1.2, 0.55); // Coordinates for Supplement
      case 'Tonic':
        return Offset(1.05, 0.55); // Coordinates for Tonic
      case 'Foot Treatment':
        return Offset(0.75, 0.55); // Coordinates for Foot Treatment
      case 'Traditional Medicine':
        return Offset(0.6, 0.55); // Coordinates for Traditional Medicine
      case 'Coffee':
        return Offset(0.3, 0.55); // Coordinates for Coffee
      case 'Dairy Product':
        return Offset(0.15, 0.55); // Coordinates for Dairy Product
      case 'Groceries':
        return Offset(0.67, 0.9); // Coordinates for Groceries
      case 'Make Up':
        return Offset(1.15, 0.9); // Coordinates for Make Up
      case 'Pets Care':
        return Offset(1.15, 0.05); // Coordinates for Pets Care
      case 'Hair Care':
        return Offset(0.67, 0.05); // Coordinates for Hair Care
      default:
        return Offset(2.0, 2.0); // Default coordinates if category is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageUrl,
                fit: BoxFit.contain, // Show entire image without cropping
              ),
              SizedBox(height: 20),
              Text(
                title, // Display title without "Title:"
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Category: $category',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Price: $price',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'In Stock: $stockCount',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Offset coordinates = getCoordinatesForCategory(category);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        x: coordinates.dx, // Category-based x-coordinate for the black rectangle
                        y: coordinates.dy, // Category-based y-coordinate for the black rectangle
                      ),
                    ),
                  );
                },
                child: Text('Locate Item', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
