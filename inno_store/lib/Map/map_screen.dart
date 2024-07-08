import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inno_store/bluetooth/bluetooth.dart';

class RedDotCoordinates {
  final double x;
  final double y;

  RedDotCoordinates({
    required this.x,
    required this.y,
  });
}

class MapScreen extends StatelessWidget {
  final double x;
  final double y;

  MapScreen({
    required this.x,
    required this.y,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize BluetoothConnect controller if not already done
    final BluetoothConnect bluetoothConnect = Get.put(BluetoothConnect());

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await bluetoothConnect.scanDevices();
            },
            child: Text('Start Scanning'),
          ),
          SizedBox(height: 16), // Add some spacing
          Obx(() {
            // Display the received data as text
            return Text(
              'Received Data: ${bluetoothConnect.receivedData.value}',
              style: TextStyle(fontSize: 16, color: Colors.black),
            );
          }),
          Obx(() {
            // Parse the received data to get x and y values
            String data = bluetoothConnect.receivedData.value;
            List<String> parts = data.split(',');
            double redDotX = parts.length > 0 ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
            double redDotY = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

            // Clamp the coordinates within the specified limits
            redDotX = redDotX.clamp(0.0, 1.5);
            redDotY = redDotY.clamp(0.0, 1.0);

            // Update y value based on the condition
            redDotY = 1 - redDotY;

            return Text(
              'Red Dot Coordinates: ($redDotX, $redDotY)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            );
          }),
          Expanded(
            child: Center(
              child: Obx(() {
                // Parse the received data to get x and y values
                String data = bluetoothConnect.receivedData.value;
                List<String> parts = data.split(',');
                double redDotX = parts.length > 0 ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
                double redDotY = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

                // Clamp the coordinates within the specified limits
                redDotX = redDotX.clamp(0.0, 1.5);
                redDotY = redDotY.clamp(0.0, 1.0);

                // Update y value based on the condition
                redDotY = 1 - redDotY;

                RedDotCoordinates redDotCoordinates = RedDotCoordinates(x: redDotX, y: redDotY);

                return LayoutBuilder(
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

                    final redDotLeft = mapCoordinate(redDotCoordinates.x, -0.2, 1.7, 0.0, floorplanWidth);
                    final redDotBottom = mapCoordinate(redDotCoordinates.y, -0.2, 1.2, 0.0, floorplanHeight);

                    return InteractiveViewer(
                      constrained: true,
                      minScale: 0.5,
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
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                          Positioned(
                            left: redDotLeft - dotSize / 2,
                            bottom: redDotBottom - dotSize / 2,
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Define the first selectable region coordinates
                          Positioned(
                            left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('First selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Colors.orange.withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the second selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Second selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Colors.blue.withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the third selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Third selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Colors.yellow.withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the fourth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Fourth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Colors.green.withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the fifth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Fifth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(1.6, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Color.fromARGB(255, 223, 5, 111).withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the sixth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Sixth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(1.2, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Colors.grey.withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the seventh selectable region coordinates
                          Positioned(
                            left: mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Seventh selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Color.fromARGB(255, 16, 180, 202).withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the eighth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Eighth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.75, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: const Color.fromARGB(255, 176, 39, 55).withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the ninth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Ninth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Color.fromARGB(255, 43, 205, 28).withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the tenth selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Tenth selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.3, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: const Color.fromARGB(255, 176, 128, 39).withOpacity(0.7),
                              ),
                            ),
                          ),
                          // Define the eleventh selectable region coordinates
                          Positioned(
                            left: mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
                            top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                print('Eleventh selectable region tapped!');
                              },
                              child: Container(
                                width: (mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth)),
                                height: (mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight)),
                                color: Color.fromARGB(255, 39, 41, 176).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
