import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inno_store/bluetooth/bluetooth.dart';
import 'region.dart' as myRegion; // Import the region.dart file with a prefix
import 'path.dart'; // Import the path.dart file
import 'navigation_view.dart'; // Import the navigation_view.dart file

class RedDotCoordinates {
  final double x;
  final double y;

  RedDotCoordinates({
    required this.x,
    required this.y,
  });
}

class MapScreen extends StatefulWidget {
  final double x;
  final double y;
  final List<Offset> path;
  final String destinationCategory; // Add destination category field

  MapScreen({
    required this.x,
    required this.y,
    required this.path,
    required this.destinationCategory, // Add destination category parameter
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isScanning = false;
  String selectedCategory = '';
  Rx<RedDotCoordinates> redDotCoordinates = RedDotCoordinates(x: 0.0, y: 0.0).obs; // Use Rx to observe changes

  void _toggleScanning(BluetoothConnect bluetoothConnect) {
    setState(() {
      isScanning = !isScanning;
    });

    if (isScanning) {
      bluetoothConnect.scanDevices();
    } else {
      bluetoothConnect.stopScanning();
    }
  }

  void _onRegionTap(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize BluetoothConnect controller if not already done
    final BluetoothConnect bluetoothConnect = Get.put(BluetoothConnect());

    // Calculate the path length
    PathFinder pathFinder = PathFinder(start: Offset(widget.x, widget.y), goal: Offset(0, 0), obstacles: []);
    double pathLength = pathFinder.calculatePathLength(widget.path);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _toggleScanning(bluetoothConnect),
                child: Text(isScanning ? 'Stop Scanning' : 'Start Scanning'),
              ),
              SizedBox(height: 16), // Add some spacing
              Obx(() {
                // Parse the received data to get x and y values
                String data = bluetoothConnect.receivedData.value;
                List<String> parts = data.split(',');
                double redDotX = parts.length > 0 ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
                double redDotY = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

                // Clamp the coordinates within the specified limits
                redDotX = double.parse(redDotX.clamp(0.0, 1.5).toStringAsFixed(2));
                redDotY = double.parse(redDotY.clamp(0.0, 1.0).toStringAsFixed(2));

                // Update y value based on the condition
                redDotY = double.parse((1 - redDotY).toStringAsFixed(2));

                // Update the red dot coordinates
                redDotCoordinates.value = RedDotCoordinates(x: redDotX, y: redDotY);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Location: (${redDotX.toStringAsFixed(2)}, ${redDotY.toStringAsFixed(2)})',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Destination Location: ${widget.destinationCategory}', // Display destination location
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
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
                    redDotX = double.parse(redDotX.clamp(0.0, 1.5).toStringAsFixed(2));
                    redDotY = double.parse(redDotY.clamp(0.0, 1.0).toStringAsFixed(2));

                    // Update y value based on the condition
                    redDotY = double.parse((1 - redDotY).toStringAsFixed(2));

                    redDotCoordinates.value = RedDotCoordinates(x: redDotX, y: redDotY);

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Define the aspect ratio of the floorplan image
                        final aspectRatio = 1.5 / 1.0; // Width / Height

                        // Calculate the dimensions of the floorplan
                        final floorplanWidth = constraints.maxWidth * 1.0;
                        final floorplanHeight = floorplanWidth / aspectRatio;

                        // Calculate the size of the red dot
                        final dotSize = 10.0; // Size of the red dot

                        // Calculate the vertical offset to center the floorplan
                        final verticalOffset = 0;

                        // Map the coordinates to the new coordinate system
                        double mapCoordinate(double value, double minValue, double maxValue, double minPixel, double maxPixel) {
                          return (value - minValue) / (maxValue - minValue) * (maxPixel - minPixel) + minPixel;
                        }

                        final dotLeft = mapCoordinate(widget.x, -0.2, 1.7, 0.0, floorplanWidth);
                        final dotBottom = mapCoordinate(widget.y, -0.2, 1.2, 0.0, floorplanHeight);

                        final redDotLeft = mapCoordinate(redDotCoordinates.value.x, -0.2, 1.7, 0.0, floorplanWidth);
                        final redDotBottom = mapCoordinate(redDotCoordinates.value.y, -0.2, 1.2, 0.0, floorplanHeight);

                        return InteractiveViewer(
                          constrained: true,
                          minScale: 0.5,
                          maxScale: 1.0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              // Get the tap position relative to the widget
                              final RenderBox box = context.findRenderObject() as RenderBox;
                              final localOffset = box.globalToLocal(details.globalPosition);
                              final tapX = localOffset.dx;
                              final tapY = localOffset.dy;

                              // Map the tap coordinates to the original coordinate system
                              final mappedX = (tapX / floorplanWidth) * 1.7 - 0.1;
                              final mappedY = ((tapY - verticalOffset) / floorplanHeight) * 1.2;

                              print('Tap position: $mappedX, $mappedY');

                              // Determine which region was tapped
                              for (myRegion.SelectableRegion region in myRegion.getSelectableRegions(floorplanWidth, floorplanHeight, mapCoordinate, dotSize, _onRegionTap)) {
                                final regionLeft = region.left;
                                final regionTop = region.top;
                                final regionRight = regionLeft + region.width;
                                final regionBottom = regionTop + region.height;

                                if (tapX >= regionLeft && tapX <= regionRight &&
                                    tapY >= regionTop && tapY <= regionBottom) {
                                  region.onTap();
                                  break;
                                }
                              }
                            },
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
                                ...myRegion.getSelectableRegions(floorplanWidth, floorplanHeight, mapCoordinate, dotSize, _onRegionTap).map((region) {
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
                                    painter: PathPainter(widget.path, floorplanWidth, floorplanHeight, mapCoordinate),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Selected Category: $selectedCategory', // Display the selected category
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Distance: ${pathLength.toStringAsFixed(2)} meters',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationView(x: widget.x, y: widget.y, path: widget.path)),
                  );
                },
                child: Icon(Icons.camera_alt),
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
