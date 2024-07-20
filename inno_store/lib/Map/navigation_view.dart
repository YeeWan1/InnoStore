import 'dart:async';
import 'dart:math'; // Import the dart:math library for mathematical functions
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inno_store/bluetooth/bluetooth.dart';
import 'region.dart'; // Import the region.dart file
import 'path.dart'; // Import the path.dart file
import 'map_screen.dart'; // Import the map_screen.dart file for RedDotCoordinates

class NavigationView extends StatefulWidget {
  final double x;
  final double y;
  final List<Offset> path;

  NavigationView({
    required this.x,
    required this.y,
    required this.path,
  });

  @override
  _NavigationViewState createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  Timer? _timer;
  ValueNotifier<List<Offset>> pathNotifier = ValueNotifier<List<Offset>>([]);
  Offset? previousRedDotPosition;
  double rotationAngle = 0;

  @override
  void initState() {
    super.initState();
    final BluetoothConnect bluetoothConnect = Get.find<BluetoothConnect>();
    List<Rect> obstacles = getObstacles();
    _startPathFinding(bluetoothConnect, obstacles);
  }

  @override
  void dispose() {
    _timer?.cancel();
    pathNotifier.dispose();
    super.dispose();
  }

  List<Rect> getObstacles() {
    // Define obstacles based on selectable regions
    return getSelectableRegions(1.5, 1.2, (v, min, max, minPixel, maxPixel) => v, 0)
        .map((region) => Rect.fromLTWH(region.left, region.top, region.width, region.height))
        .toList();
  }

  void _startPathFinding(BluetoothConnect bluetoothConnect, List<Rect> obstacles) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Get the received data from Bluetooth and parse it
      String data = bluetoothConnect.receivedData.value;
      List<String> parts = data.split(',');
      double redDotX = parts.length > 0 ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
      double redDotY = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

      // Clamp the coordinates within the specified limits
      redDotX = redDotX.clamp(0.0, 1.5);
      redDotY = redDotY.clamp(0.0, 1.0);

      // Update y value based on the condition
      redDotY = redDotY;

      Offset start = Offset(redDotX, redDotY); // Use clamped and adjusted coordinates
      Offset goal = Offset(widget.x, 1 - widget.y); // Use consistent goal coordinates

      PathFinder pathFinder = PathFinder(start: start, goal: goal, obstacles: obstacles);
      List<Offset> newPath = pathFinder.aStar();

      // Only update the ValueNotifier if the path has changed
      if (!_arePathsEqual(pathNotifier.value, newPath)) {
        pathNotifier.value = newPath; // Update the pathNotifier

        // Determine the rotation angle based on the direction of the path
        _updateRotationAngle(newPath);
      }

      previousRedDotPosition = start;
    });
  }

  void _updateRotationAngle(List<Offset> path) {
    if (path.length < 2) return;

    Offset first = path[0];
    Offset second = path[1];

    double dx = second.dx - first.dx;
    double dy = second.dy - first.dy;

    if (dx.abs() > dy.abs()) {
      // Horizontal movement
      if (dx > 0) {
        // Moving right
        rotationAngle = -pi / 2;
      } else {
        // Moving left
        rotationAngle = pi / 2;
      }
    } else {
      // Vertical movement
      if (dy > 0) {
        // Moving down
        rotationAngle = pi;
      } else {
        // Moving up
        rotationAngle = 0;
      }
    }
  }

  bool _arePathsEqual(List<Offset> path1, List<Offset> path2) {
    if (path1.length != path2.length) return false;
    for (int i = 0; i < path1.length; i++) {
      if (path1[i] != path2[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Initialize BluetoothConnect controller if not already done
    final BluetoothConnect bluetoothConnect = Get.put(BluetoothConnect());

    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation View'),
      ),
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
              child: ValueListenableBuilder<List<Offset>>(
                valueListenable: pathNotifier,
                builder: (context, path, child) {
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
                      final aspectRatio = rotationAngle == 0 || rotationAngle == pi ? 1.5 / 1.0 : 1.0 / 1.5; // Width / Height

                      // Calculate the dimensions of the floorplan
                      final floorplanWidth = constraints.maxWidth * 1.0;
                      final floorplanHeight = floorplanWidth / aspectRatio;

                      // Calculate the size of the red dot
                      final dotSize = 10.0; // Size of the red dot

                      // Map the coordinates to the new coordinate system
                      double mapCoordinate(double value, double minValue, double maxValue, double minPixel, double maxPixel) {
                        return (value - minValue) / (maxValue - minValue) * (maxPixel - minPixel) + minPixel;
                      }

                      final dotLeft = mapCoordinate(widget.x, -0.2, 1.7, 0.0, floorplanWidth);
                      final dotBottom = mapCoordinate(widget.y, -0.2, 1.2, 0.0, floorplanHeight);

                      final redDotLeft = mapCoordinate(redDotCoordinates.x, -0.2, 1.7, 0.0, floorplanWidth);
                      final redDotBottom = mapCoordinate(redDotCoordinates.y, -0.2, 1.2, 0.0, floorplanHeight);

                      return Transform.rotate(
                        angle: rotationAngle,
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
                            Positioned.fill(
                              child: CustomPaint(
                                painter: PathPainter(path, floorplanWidth, floorplanHeight, mapCoordinate),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  final List<Offset> path;
  final double floorplanWidth;
  final double floorplanHeight;
  final double Function(double, double, double, double, double) mapCoordinate;

  PathPainter(this.path, this.floorplanWidth, this.floorplanHeight, this.mapCoordinate);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    if (path.isNotEmpty) {
      final pathToDraw = Path()
        ..moveTo(
          mapCoordinate(path[0].dx, -0.2, 1.7, 0.0, floorplanWidth),
          mapCoordinate(path[0].dy, -0.2, 1.2, 0.0, floorplanHeight),
        );

      for (int i = 1; i < path.length; i++) {
        pathToDraw.lineTo(
          mapCoordinate(path[i].dx, -0.2, 1.7, 0.0, floorplanWidth),
          mapCoordinate(path[i].dy, -0.2, 1.2, 0.0, floorplanHeight),
        );
      }

      canvas.drawPath(pathToDraw, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
