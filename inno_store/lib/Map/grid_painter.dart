import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final List<List<int>> grid;

  GridPainter(this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final cellWidth = size.width / grid[0].length;
    final cellHeight = size.height / grid.length;

    for (int i = 0; i <= grid[0].length; i++) {
      final x = i * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (int i = 0; i <= grid.length; i++) {
      final y = i * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final shelfPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (int y = 0; y < grid.length; y++) {
      for (int x = 0; x < grid[y].length; x++) {
        if (grid[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellWidth, y * cellHeight, cellWidth, cellHeight),
            shelfPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
