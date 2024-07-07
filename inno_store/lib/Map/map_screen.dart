import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final double x;
  final double y;

  MapScreen({
    required this.x,
    required this.y,
  });

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

            // Define the first selectable region coordinates
            final region1TopLeft = Offset(
              mapCoordinate(1.4, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.35, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region1BottomRight = Offset(
              mapCoordinate(1.5, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.7, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the second selectable region coordinates
            final region2TopLeft = Offset(
              mapCoordinate(1.05, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.1, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region2BottomRight = Offset(
              mapCoordinate(1.5, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.2, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the third selectable region coordinates
            final region3TopLeft = Offset(
              mapCoordinate(0.3, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.3, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region3BottomRight = Offset(
              mapCoordinate(0.7, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.4, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the fourth selectable region coordinates
            final region4TopLeft = Offset(
              mapCoordinate(0.3, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.55, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region4BottomRight = Offset(
              mapCoordinate(0.7, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.65, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the fifth selectable region coordinates
            final region5TopLeft = Offset(
              mapCoordinate(1.1, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.9, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region5BottomRight = Offset(
              mapCoordinate(1.4, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(1.0, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the sixth selectable region coordinates
            final region6TopLeft = Offset(
              mapCoordinate(0.4, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.9, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region6BottomRight = Offset(
              mapCoordinate(0.7, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(1.0, 0.0, 1.2, 0.0, floorplanHeight),
            );

            // Define the seventh selectable region coordinates
            final region7TopLeft = Offset(
              mapCoordinate(1.1, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.35, 0.0, 1.2, 0.0, floorplanHeight),
            );
            final region7BottomRight = Offset(
              mapCoordinate(1.2, 0.0, 1.7, 0.0, floorplanWidth),
              mapCoordinate(0.7, 0.0, 1.2, 0.0, floorplanHeight),
            );

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
                    Positioned(
                      left: region1TopLeft.dx,
                      top: region1TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the first selectable region
                          print('First selectable region tapped!');
                        },
                        child: Container(
                          width: region1BottomRight.dx - region1TopLeft.dx,
                          height: region1BottomRight.dy - region1TopLeft.dy,
                          color: Colors.orange.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region2TopLeft.dx,
                      top: region2TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the second selectable region
                          print('Second selectable region tapped!');
                        },
                        child: Container(
                          width: region2BottomRight.dx - region2TopLeft.dx,
                          height: region2BottomRight.dy - region2TopLeft.dy,
                          color: Colors.blue.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region3TopLeft.dx,
                      top: region3TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the third selectable region
                          print('Third selectable region tapped!');
                        },
                        child: Container(
                          width: region3BottomRight.dx - region3TopLeft.dx,
                          height: region3BottomRight.dy - region3TopLeft.dy,
                          color: Colors.yellow.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region4TopLeft.dx,
                      top: region4TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the fourth selectable region
                          print('Fourth selectable region tapped!');
                        },
                        child: Container(
                          width: region4BottomRight.dx - region4TopLeft.dx,
                          height: region4BottomRight.dy - region4TopLeft.dy,
                          color: Colors.green.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region5TopLeft.dx,
                      top: region5TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the fifth selectable region
                          print('Fifth selectable region tapped!');
                        },
                        child: Container(
                          width: region5BottomRight.dx - region5TopLeft.dx,
                          height: region5BottomRight.dy - region5TopLeft.dy,
                          color: Colors.grey.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region6TopLeft.dx,
                      top: region6TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the sixth selectable region
                          print('Sixth selectable region tapped!');
                        },
                        child: Container(
                          width: region6BottomRight.dx - region6TopLeft.dx,
                          height: region6BottomRight.dy - region6TopLeft.dy,
                          color: Colors.grey.withOpacity(1.0),
                        ),
                      ),
                    ),
                    Positioned(
                      left: region7TopLeft.dx,
                      top: region7TopLeft.dy,
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap on the seventh selectable region
                          print('Seventh selectable region tapped!');
                        },
                        child: Container(
                          width: region7BottomRight.dx - region7TopLeft.dx,
                          height: region7BottomRight.dy - region7TopLeft.dy,
                          color: Colors.purple.withOpacity(1.0), // Solid color
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
