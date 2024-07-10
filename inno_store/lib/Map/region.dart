import 'package:flutter/material.dart';

class SelectableRegion {
  final double left;
  final double top;
  final double width;
  final double height;
  final Color color;
  final VoidCallback onTap;

  SelectableRegion({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.color,
    required this.onTap,
  });
}

List<SelectableRegion> getSelectableRegions(
    double floorplanWidth, double floorplanHeight, double Function(double, double, double, double, double) mapCoordinate, double dotSize) {
  return [
    SelectableRegion(
      left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.orange.withOpacity(0.7),
      onTap: () {
        print('First selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.blue.withOpacity(0.7),
      onTap: () {
        print('Second selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.yellow.withOpacity(0.7),
      onTap: () {
        print('Third selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.green.withOpacity(0.7),
      onTap: () {
        print('Fourth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.6, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 223, 5, 111).withOpacity(0.7),
      onTap: () {
        print('Fifth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.2, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.grey.withOpacity(0.7),
      onTap: () {
        print('Sixth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 16, 180, 202).withOpacity(0.7),
      onTap: () {
        print('Seventh selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.75, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: const Color.fromARGB(255, 176, 39, 55).withOpacity(0.7),
      onTap: () {
        print('Eighth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 43, 205, 28).withOpacity(0.7),
      onTap: () {
        print('Ninth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.3, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: const Color.fromARGB(255, 176, 128, 39).withOpacity(0.7),
      onTap: () {
        print('Tenth selectable region tapped!');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 39, 41, 176).withOpacity(0.7),
      onTap: () {
        print('Eleventh selectable region tapped!');
      },
    ),
  ];
}
