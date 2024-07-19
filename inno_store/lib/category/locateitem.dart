import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inno_store/Map/map_screen.dart';
import 'package:inno_store/Map/path.dart';
import 'package:inno_store/Map/region.dart';
import 'package:inno_store/features/user_auth/presentations/pages/home_main.dart';
import 'package:inno_store/bluetooth/bluetooth.dart';
import 'package:get/get.dart';

class LocateItem extends StatefulWidget {
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

  @override
  _LocateItemState createState() => _LocateItemState();
}

class _LocateItemState extends State<LocateItem> {
  Timer? _timer;
  Offset? _goal;
  ValueNotifier<List<Offset>> pathNotifier = ValueNotifier<List<Offset>>([]);

  @override
  void initState() {
    super.initState();
    _goal = getCoordinatesForCategory(widget.category);
  }

  @override
  void dispose() {
    _timer?.cancel();
    pathNotifier.dispose();
    super.dispose();
  }

  Offset getCoordinatesForCategory(String category) {
    switch (category) {
      case 'Nutrition':
        return Offset(1.45, 0.55);
      case 'Supplement':
        return Offset(1.2, 0.55);
      case 'Tonic':
        return Offset(1.05, 0.55);
      case 'Foot Treatment':
        return Offset(0.75, 0.55);
      case 'Traditional Medicine':
        return Offset(0.6, 0.55);
      case 'Coffee':
        return Offset(0.3, 0.55);
      case 'Dairy Product':
        return Offset(0.15, 0.55);
      case 'Groceries':
        return Offset(0.67, 0.9);
      case 'Make Up':
        return Offset(1.15, 0.9);
      case 'Pets Care':
        return Offset(1.15, 0.05);
      case 'Hair Care':
        return Offset(0.67, 0.05);
      default:
        return Offset(2.0, 2.0);
    }
  }

  void _startPathFinding(BluetoothConnect bluetoothConnect, List<Rect> obstacles) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      String data = bluetoothConnect.receivedData.value;
      List<String> parts = data.split(',');
      double redDotX = parts.length > 0 ? double.tryParse(parts[0]) ?? 0.0 : 0.0;
      double redDotY = parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;
      redDotX = redDotX.clamp(0.0, 1.5);
      redDotY = redDotY.clamp(0.0, 1.0);
      Offset start = Offset(redDotX, redDotY);
      Offset goal = Offset(_goal!.dx, 1 - _goal!.dy);
      PathFinder pathFinder = PathFinder(start: start, goal: goal, obstacles: obstacles);
      List<Offset> newPath = pathFinder.aStar();
      if (!_arePathsEqual(pathNotifier.value, newPath)) {
        pathNotifier.value = newPath;
      }
    });
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
    final BluetoothConnect bluetoothConnect = Get.find<BluetoothConnect>();

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
              Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Category: ${widget.category}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Price: ${widget.price}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'In Stock: ${widget.stockCount}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  List<Rect> obstacles = [
                    ...getSelectableRegions(1.5, 1.2, (v, min, max, minPixel, maxPixel) => v, 0)
                        .map((region) => Rect.fromLTWH(region.left, region.top, region.width, region.height)),
                  ];
                  _startPathFinding(bluetoothConnect, obstacles);
                  _navigateToMainHomePage();
                },
                child: Text('Locate Item', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMainHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainHomePage(
          initialIndex: 1,
          pathNotifier: pathNotifier,
          x: _goal!.dx,
          y: _goal!.dy,
        ),
      ),
    );
  }
}
