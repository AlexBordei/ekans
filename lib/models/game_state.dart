import 'dart:async';
import 'snake.dart';
import 'food.dart';
import 'obstacle.dart';
import 'position.dart';
import '../config/env_config.dart';

enum GameStatus { notStarted, playing, paused, gameOver }

class GameState {
  final int boardWidth;
  final int boardHeight;
  late Snake snake;
  late Food food;
  late Obstacle obstacle;
  int score = 0;
  GameStatus status = GameStatus.notStarted;
  Timer? gameTimer;
  int level = 1;
  int speed = EnvConfig.initialSnakeSpeed;

  // Debug metrics
  double get accelerationRate =>
      (EnvConfig.initialSnakeSpeed - speed) / EnvConfig.initialSnakeSpeed;
  double get currentSpeedMs => speed.toDouble();
  String get debugInfo => '''
Speed: ${currentSpeedMs.toStringAsFixed(1)}ms
Acceleration: ${(accelerationRate * 100).toStringAsFixed(1)}%
Level: $level
Score: $score
''';

  GameState({required this.boardWidth, required this.boardHeight}) {
    _initialize();
  }

  void _initialize() {
    // Initialize snake in the middle of the board
    snake = Snake(boardWidth ~/ 2, boardHeight ~/ 2, 3);

    // Initialize food
    food = Food(boardWidth, boardHeight, snake.positions);

    // Initialize obstacles - but with no obstacles at level 1 for easier start
    obstacle = Obstacle();
    if (level > 1) {
      _generateObstacles();
    } else {
      obstacle.positions.clear(); // No obstacles at level 1
    }
  }

  void _generateObstacles() {
    List<Position> occupiedPositions = [...snake.positions];
    occupiedPositions.add(food.position);

    // Create a safe zone around the snake head
    final head = snake.head;
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        occupiedPositions.add(Position(head.x + x, head.y + y));
      }
    }

    int obstacleCount = level - 1; // One less obstacle than level for balance
    obstacle.generateRandomObstacles(
      obstacleCount,
      boardWidth,
      boardHeight,
      occupiedPositions,
    );
  }

  void startGame() {
    if (status == GameStatus.notStarted || status == GameStatus.gameOver) {
      _initialize();
      score = 0;
      level = 1;
      speed = EnvConfig.initialSnakeSpeed;
    }

    status = GameStatus.playing;
  }

  void pauseGame() {
    if (status == GameStatus.playing) {
      status = GameStatus.paused;
    } else if (status == GameStatus.paused) {
      status = GameStatus.playing;
    }
  }

  void changeDirection(Direction direction) {
    // Prevent 180-degree turns
    if (snake.direction == Direction.up && direction == Direction.down) return;
    if (snake.direction == Direction.down && direction == Direction.up) return;
    if (snake.direction == Direction.left && direction == Direction.right)
      return;
    if (snake.direction == Direction.right && direction == Direction.left)
      return;

    snake.direction = direction;
  }

  void update() {
    // Don't update if not playing
    if (status != GameStatus.playing) return;

    // Get the next head position based on current direction
    Position nextHead;
    switch (snake.direction) {
      case Direction.up:
        nextHead = Position(snake.head.x, snake.head.y - 1);
        break;
      case Direction.down:
        nextHead = Position(snake.head.x, snake.head.y + 1);
        break;
      case Direction.left:
        nextHead = Position(snake.head.x - 1, snake.head.y);
        break;
      case Direction.right:
        nextHead = Position(snake.head.x + 1, snake.head.y);
        break;
    }

    // Check if the next head position is outside the boundaries
    if (nextHead.x < 0 ||
        nextHead.x >= boardWidth ||
        nextHead.y < 0 ||
        nextHead.y >= boardHeight) {
      status = GameStatus.gameOver;
      return;
    }

    // Move the snake
    snake.move();

    // Check for collision with walls, self, or obstacles
    if (snake.checkCollision(
      boardWidth,
      boardHeight,
      obstacles: obstacle.positions,
    )) {
      status = GameStatus.gameOver;
      return;
    }

    // Check for food
    if (snake.head == food.position) {
      snake.grow();
      score += 10;

      // Increase level and speed periodically
      if (score % EnvConfig.scoreLevelUp == 0) {
        level++;
        if (speed > EnvConfig.minSnakeSpeed) {
          speed -= EnvConfig.speedDecreaseRate;
        }
      }

      // Regenerate food
      food.regenerate(
        boardWidth,
        boardHeight,
        snake.positions + obstacle.positions,
      );

      // Generate new obstacles every other level
      if (level % 2 == 0) {
        _generateObstacles();
      }
    }
  }

  void reset() {
    status = GameStatus.notStarted;
    _initialize();
    score = 0;
    level = 1;
    speed = EnvConfig.initialSnakeSpeed;
  }

  void dispose() {
    gameTimer?.cancel();
    gameTimer = null;
  }

  double getCurrentSpeed() {
    if (EnvConfig.accelerationTest) {
      // In acceleration test mode, speed increases more dramatically
      return speed / 2000.0;
    }
    return speed / 1000.0;
  }

  void addScore() {
    score += 10;
    // Increase level and speed periodically
    if (score % EnvConfig.scoreLevelUp == 0) {
      level++;
      if (speed > EnvConfig.minSnakeSpeed) {
        speed -= EnvConfig.speedDecreaseRate;
      }
    }
  }
}
