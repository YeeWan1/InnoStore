import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inno_store/bluetooth/bluetooth.dart';
import 'region.dart'; // Import the region.dart file

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
                          ...getSelectableRegions(floorplanWidth, floorplanHeight, mapCoordinate, dotSize).map((region) {
                            return Positioned(
                              left: region.left,
                              top: region.top,
                              child: GestureDetector(
                                onTap: region.onTap,
                                child: Container(
                                  width: region.width,
                                  height: region.height,
                                  color: region.color,
                                ),
                              ),
                            );
                          }).toList(),
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
