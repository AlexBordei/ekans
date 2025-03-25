import 'dart:math';
import 'position.dart';

class Food {
  late Position position;

  Food(int maxX, int maxY, List<Position> occupiedPositions) {
    _generateRandomPosition(maxX, maxY, occupiedPositions);
  }

  void _generateRandomPosition(
    int maxX,
    int maxY,
    List<Position> occupiedPositions,
  ) {
    final random = Random();
    bool positionOccupied;

    do {
      int x = random.nextInt(maxX);
      int y = random.nextInt(maxY);
      position = Position(x, y);

      // Check if the position is already occupied
      positionOccupied = false;
      for (var pos in occupiedPositions) {
        if (pos == position) {
          positionOccupied = true;
          break;
        }
      }
    } while (positionOccupied);
  }

  void regenerate(int maxX, int maxY, List<Position> occupiedPositions) {
    _generateRandomPosition(maxX, maxY, occupiedPositions);
  }
}
