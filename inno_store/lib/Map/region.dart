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
    double floorplanWidth, double floorplanHeight, double Function(double, double, double, double, double) mapCoordinate, double dotSize, Function(String) onRegionTap) {
  return [
    SelectableRegion(
      left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.orange.withOpacity(0.7),
      onTap: () {
        print('Tapped on Pets Care region');
        onRegionTap('Pets Care');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(1.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(1.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.blue.withOpacity(0.7),
      onTap: () {
        print('Tapped on Hair Care region');
        onRegionTap('Hair Care');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.9, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.yellow.withOpacity(0.7),
      onTap: () {
        print('Tapped on Groceries region');
        onRegionTap('Groceries');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.4, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.0, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.1, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.0, -0.2, 1.2, 0.0, floorplanHeight),
      color: Colors.green.withOpacity(0.7),
      onTap: () {
        print('Tapped on Make Up region');
        onRegionTap('Make Up');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.6, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.5, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 223, 5, 111).withOpacity(0.7),
      onTap: () {
        print('Tapped on Nutrition region');
        onRegionTap('Nutrition');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.2, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 67, 55, 67).withOpacity(0.7),
      onTap: () {
        print('Tapped on Supplement region');
        onRegionTap('Supplement');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(1.15, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(1.1, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 16, 180, 202).withOpacity(0.7),
      onTap: () {
        print('Tapped on Tonic region');
        onRegionTap('Tonic');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.75, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: const Color.fromARGB(255, 176, 39, 55).withOpacity(0.7),
      onTap: () {
        print('Tapped on Foot Treatment region');
        onRegionTap('Foot Treatment');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.7, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.65, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 43, 205, 28).withOpacity(0.7),
      onTap: () {
        print('Tapped on Traditional Medicine region');
        onRegionTap('Traditional Medicine');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.3, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: const Color.fromARGB(255, 176, 128, 39).withOpacity(0.7),
      onTap: () {
        print('Tapped on Coffee region');
        onRegionTap('Coffee');
      },
    ),
    SelectableRegion(
      left: mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth) - dotSize / 2,
      top: mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight) - dotSize / 2,
      width: mapCoordinate(0.25, -0.2, 1.7, 0.0, floorplanWidth) - mapCoordinate(0.2, -0.2, 1.7, 0.0, floorplanWidth),
      height: mapCoordinate(0.7, -0.2, 1.2, 0.0, floorplanHeight) - mapCoordinate(0.3, -0.2, 1.2, 0.0, floorplanHeight),
      color: Color.fromARGB(255, 39, 41, 176).withOpacity(0.7),
      onTap: () {
        print('Tapped on Dairy Product region');
        onRegionTap('Dairy Product');
      },
    ),
  ];
}
