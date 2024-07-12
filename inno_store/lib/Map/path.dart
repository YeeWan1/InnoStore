import 'dart:math';
import 'package:flutter/material.dart';
import 'region.dart'; // Import the region.dart file

class PathFinder {
  final Offset start;
  final Offset goal;
  final List<Rect> obstacles;
  final double gridSize;

  PathFinder({
    required this.start,
    required this.goal,
    required this.obstacles,
    this.gridSize = 0.05, // Define grid size for pathfinding
  });

  double heuristic(Offset a, Offset b) {
    return (a - b).distance;
  }

  bool isWalkable(Offset point) {
    for (Rect obstacle in obstacles) {
      if (obstacle.contains(point)) {
        return false;
      }
    }
    return true;
  }

  List<Offset> findNeighbors(Offset current) {
    List<Offset> neighbors = [];
    List<Offset> directions = [
      Offset(-gridSize, 0),
      Offset(gridSize, 0),
      Offset(0, -gridSize),
      Offset(0, gridSize),
      Offset(-gridSize, -gridSize),
      Offset(gridSize, -gridSize),
      Offset(-gridSize, gridSize),
      Offset(gridSize, gridSize),
    ];

    for (Offset direction in directions) {
      Offset neighbor = current + direction;
      if (isWalkable(neighbor)) {
        neighbors.add(neighbor);
      }
    }

    return neighbors;
  }

  List<Offset> aStar() {
    Map<Offset, Offset?> cameFrom = {};
    Map<Offset, double> gScore = {start: 0.0};
    Map<Offset, double> fScore = {start: heuristic(start, goal)};
    List<Offset> openSet = [start];

    while (openSet.isNotEmpty) {
      openSet.sort((a, b) => fScore[a]!.compareTo(fScore[b]!));
      Offset current = openSet.removeAt(0);

      if ((current - goal).distance < gridSize) {
        return reconstructPath(cameFrom, current);
      }

      for (Offset neighbor in findNeighbors(current)) {
        double tentativeGScore = gScore[current]! + heuristic(current, neighbor);

        if (tentativeGScore < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = gScore[neighbor]! + heuristic(neighbor, goal);
          if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
          }
        }
      }
    }

    return reconstructPath(cameFrom, goal);
  }

  List<Offset> reconstructPath(Map<Offset, Offset?> cameFrom, Offset current) {
    List<Offset> totalPath = [current];
    while (cameFrom[current] != null) {
      current = cameFrom[current]!;
      totalPath.add(current);
    }
    return totalPath.reversed.toList();
  }
}
