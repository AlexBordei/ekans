enum GameStatus { notStarted, playing, paused, gameOver }

enum Direction { up, down, left, right }

class GameState {
  int score = 0;
  int combo = 0;
  int level = 1;
  double baseSpeed = 0.15; // Base speed in seconds per move
  DateTime? lastFoodTime;
  GameStatus status = GameStatus.notStarted;
  Direction currentDirection = Direction.right;

  void dispose() {
    // Cleanup if needed
  }

  void changeDirection(Direction newDirection) {
    // Prevent 180-degree turns
    if ((currentDirection == Direction.up && newDirection == Direction.down) ||
        (currentDirection == Direction.down && newDirection == Direction.up) ||
        (currentDirection == Direction.left &&
            newDirection == Direction.right) ||
        (currentDirection == Direction.right &&
            newDirection == Direction.left)) {
      return;
    }
    currentDirection = newDirection;
  }

  void startGame() {
    status = GameStatus.playing;
  }

  void pauseGame() {
    status = GameStatus.paused;
  }

  void reset() {
    score = 0;
    combo = 0;
    level = 1;
    status = GameStatus.notStarted;
    currentDirection = Direction.right;
    lastFoodTime = null;
  }

  // Calculate current speed based on score
  double getCurrentSpeed() {
    // Speed increases by 5% for every 100 points
    double speedMultiplier = 1.0 + (score / 100) * 0.05;
    // Cap the maximum speed multiplier at 2.5x (optional)
    speedMultiplier = speedMultiplier.clamp(1.0, 2.5);
    return baseSpeed / speedMultiplier;
  }

  // Calculate score when food is collected
  void addScore() {
    final now = DateTime.now();

    // Base score
    int points = 10;

    // Combo bonus if food is collected within 5 seconds
    if (lastFoodTime != null) {
      final timeDiff = now.difference(lastFoodTime!).inSeconds;
      if (timeDiff <= 5) {
        combo++;
        points += (combo * 5); // Bonus points based on combo
      } else {
        combo = 0; // Reset combo if took too long
      }
    }

    lastFoodTime = now;
    score += points;
  }
}
