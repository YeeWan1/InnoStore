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
      case 'Health Care':
        return Offset(0.35, 0.4); // Coordinates for green region
      case 'Groceries':
        return Offset(0.35, 0.7); // Coordinates for yellow region
      case 'Make Up':
        return Offset(1.25, 0.92); // Coordinates for blue region
      case 'Pets Care':
        return Offset(1.34, 0.6); // Coordinates for orange region
      case 'Hair Care':
        return Offset(1.0, 0.6); // Coordinates for purple region
      default:
        return Offset(0.0, 0.0); // Default coordinates if category is unknown
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
                        x: coordinates.dx,
                        y: coordinates.dy,
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
