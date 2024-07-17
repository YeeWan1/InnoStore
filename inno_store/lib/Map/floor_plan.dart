import 'package:flutter/material.dart';
import 'grid_painter.dart';

class FloorPlan extends StatefulWidget {
  @override
  _FloorPlanState createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> {
  static const int rows = 20; // Set the number of rows according to your floor plan
  static const int cols = 20; // Set the number of columns according to your floor plan
  List<List<int>> grid = List.generate(rows, (_) => List.filled(cols, 0));

  void _onTapDown(TapDownDetails details, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;
    final dx = (details.localPosition.dx / cellWidth).floor();
    final dy = (details.localPosition.dy / cellHeight).floor();

    if (dx >= 0 && dx < cols && dy >= 0 && dy < rows) {
      setState(() {
        grid[dy][dx] = grid[dy][dx] == 1 ? 0 : 1; // Toggle shelf presence
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details, MediaQuery.of(context).size),
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: GridPainter(grid),
      ),
    );
  }
}
