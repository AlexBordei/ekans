import 'position.dart';

enum Direction { up, down, left, right }

class Snake {
  List<Position> positions = [];
  Direction direction = Direction.right;
  bool growNextTime = false;

  Snake(int initialX, int initialY, int initialLength) {
    // Initialize the snake with initial positions
    for (int i = 0; i < initialLength; i++) {
      positions.add(Position(initialX - i, initialY));
    }
  }

  Position get head => positions.first;

  void move() {
    // Add new head position based on current direction
    Position newHead;
    switch (direction) {
      case Direction.up:
        newHead = Position(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Position(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Position(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Position(head.x + 1, head.y);
        break;
    }

    positions.insert(0, newHead);

    // Remove tail if not growing
    if (!growNextTime) {
      positions.removeLast();
    } else {
      growNextTime = false;
    }
  }

  void grow() {
    growNextTime = true;
  }

  bool checkCollision(
    int boardWidth,
    int boardHeight, {
    List<Position>? obstacles,
  }) {
    // Check if snake hit itself
    for (int i = 1; i < positions.length; i++) {
      if (head.x == positions[i].x && head.y == positions[i].y) {
        return true;
      }
    }

    // Check if snake hit obstacles
    if (obstacles != null) {
      for (var obstacle in obstacles) {
        if (head.x == obstacle.x && head.y == obstacle.y) {
          return true;
        }
      }
    }

    return false;
  }
}
