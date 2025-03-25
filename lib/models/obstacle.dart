import 'dart:math';
import 'position.dart';

class Obstacle {
  List<Position> positions = [];

  Obstacle();

  void generateRandomObstacles(
    int count,
    int maxX,
    int maxY,
    List<Position> occupiedPositions,
  ) {
    positions.clear();
    final random = Random();

    for (int i = 0; i < count; i++) {
      bool positionOccupied;
      Position newPosition;

      do {
        int x = random.nextInt(maxX);
        int y = random.nextInt(maxY);
        newPosition = Position(x, y);

        // Check if the position is already occupied
        positionOccupied = false;
        for (var pos in occupiedPositions) {
          if (pos == newPosition) {
            positionOccupied = true;
            break;
          }
        }

        for (var pos in positions) {
          if (pos == newPosition) {
            positionOccupied = true;
            break;
          }
        }
      } while (positionOccupied);

      positions.add(newPosition);
    }
  }
}
