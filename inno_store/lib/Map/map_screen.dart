import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  // Define the red dot's coordinates
  final double x = 0.0; // x-coordinate of the red dot
  final double y = 0.0; // y-coordinate of the red dot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define the aspect ratio of the floorplan image
            final aspectRatio = 1.5 / 1.0; // Width / Height

            // Calculate the dimensions of the floorplan
            final floorplanWidth = constraints.maxWidth * 1.0;
            final floorplanHeight = floorplanWidth / aspectRatio;

            // Calculate the size of the red dot
            final dotSize = 10.0; // Size of the red dot

            // Map the coordinates to the new coordinate system
            double mapCoordinate(double value, double minValue, double maxValue, double minPixel, double maxPixel) {
              return (value - minValue) / (maxValue - minValue) * (maxPixel - minPixel) + minPixel;
            }

            final dotLeft = mapCoordinate(x, -0.2, 1.7, 0.0, floorplanWidth);
            final dotBottom = mapCoordinate(y, -0.2, 1.2, 0.0, floorplanHeight);

            return Center(
              child: InteractiveViewer(
                constrained: true,
                minScale: 1.0,
                maxScale: 1.5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: floorplanWidth,
                      height: floorplanHeight,
                      child: Image.asset(
                        'assets/map/floorplan.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: dotLeft - dotSize / 2,
                      bottom: dotBottom - dotSize / 2,
                      child: Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}