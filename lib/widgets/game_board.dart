import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/position.dart';
import '../models/snake.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;

  const GameBoard({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height =
        MediaQuery.of(context).size.height * 0.6 -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final double cellSize = width / gameState.boardWidth;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Game board with snake, food, and obstacles
          ClipRect(
            child: CustomPaint(
              painter: GameBoardPainter(
                gameState: gameState,
                cellSize: cellSize,
              ),
              size: Size(width, height),
            ),
          ),

          // Overlay for not started state
          if (gameState.status == GameStatus.notStarted)
            Container(
              color: Colors.blue.withOpacity(0.1),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swipe, color: Colors.blue, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Swipe to control',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Overlay for paused state
          if (gameState.status == GameStatus.paused)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Text(
                  'PAUSED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final GameState gameState;
  final double cellSize;

  GameBoardPainter({required this.gameState, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = Colors.black12;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.black26
          ..strokeWidth = 1.0;

    for (int i = 0; i <= gameState.boardWidth; i++) {
      final x = i * cellSize;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (int i = 0; i <= gameState.boardHeight; i++) {
      final y = i * cellSize;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw snake
    final snakePaint = Paint()..color = Colors.green;
    final snakeHeadPaint = Paint()..color = Colors.lightGreen;

    // Draw snake body
    for (int i = 1; i < gameState.snake.positions.length; i++) {
      _drawCell(canvas, gameState.snake.positions[i], snakePaint);
    }

    // Draw snake head with direction
    if (gameState.snake.positions.isNotEmpty) {
      final headPosition = gameState.snake.positions.first;
      _drawSnakeHead(
        canvas,
        headPosition,
        gameState.snake.direction,
        snakeHeadPaint,
      );
    }

    // Draw food
    final foodPaint = Paint()..color = Colors.red;
    _drawFood(canvas, gameState.food.position, foodPaint);

    // Draw obstacles
    final obstaclePaint = Paint()..color = Colors.grey;
    for (var position in gameState.obstacle.positions) {
      _drawObstacle(canvas, position, obstaclePaint);
    }
  }

  void _drawCell(Canvas canvas, Position position, Paint paint) {
    final rect = Rect.fromLTWH(
      position.x * cellSize,
      position.y * cellSize,
      cellSize,
      cellSize,
    );
    canvas.drawRect(rect, paint);
  }

  void _drawSnakeHead(
    Canvas canvas,
    Position position,
    Direction direction,
    Paint paint,
  ) {
    final rect = Rect.fromLTWH(
      position.x * cellSize,
      position.y * cellSize,
      cellSize,
      cellSize,
    );

    // Draw basic head
    canvas.drawRect(rect, paint);

    // Add eyes based on direction
    final eyePaint = Paint()..color = Colors.black;
    final eyeSize = cellSize * 0.2;
    final eyeOffset = cellSize * 0.2;

    switch (direction) {
      case Direction.up:
        // Left eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + eyeOffset,
            position.y * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        // Right eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + cellSize - eyeOffset,
            position.y * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        break;
      case Direction.down:
        // Left eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + eyeOffset,
            position.y * cellSize + cellSize - eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        // Right eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + cellSize - eyeOffset,
            position.y * cellSize + cellSize - eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        break;
      case Direction.left:
        // Top eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + eyeOffset,
            position.y * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        // Bottom eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + eyeOffset,
            position.y * cellSize + cellSize - eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        break;
      case Direction.right:
        // Top eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + cellSize - eyeOffset,
            position.y * cellSize + eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        // Bottom eye
        canvas.drawCircle(
          Offset(
            position.x * cellSize + cellSize - eyeOffset,
            position.y * cellSize + cellSize - eyeOffset,
          ),
          eyeSize,
          eyePaint,
        );
        break;
    }
  }

  void _drawFood(Canvas canvas, Position position, Paint paint) {
    final center = Offset(
      position.x * cellSize + cellSize / 2,
      position.y * cellSize + cellSize / 2,
    );

    // Draw a circle for food
    canvas.drawCircle(center, cellSize / 2, paint);

    // Draw a stem
    final stemPaint =
        Paint()
          ..color = Colors.green
          ..strokeWidth = cellSize * 0.1;

    canvas.drawLine(
      Offset(center.dx, center.dy - cellSize / 2),
      Offset(center.dx, center.dy - cellSize / 3),
      stemPaint,
    );
  }

  void _drawObstacle(Canvas canvas, Position position, Paint paint) {
    final rect = Rect.fromLTWH(
      position.x * cellSize,
      position.y * cellSize,
      cellSize,
      cellSize,
    );

    // Draw a rock-like obstacle
    canvas.drawRect(rect, paint);

    // Add some details to make it look like a rock
    final detailPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..strokeWidth = 1.0;

    // Draw some random lines to give texture
    final random =
        position.x * 7 +
        position.y * 13; // Using position for deterministic "randomness"
    final startX = position.x * cellSize + (random % 5) * cellSize / 10;
    final startY = position.y * cellSize + (random % 7) * cellSize / 10;

    canvas.drawLine(
      Offset(startX, startY),
      Offset(startX + cellSize / 3, startY + cellSize / 4),
      detailPaint,
    );

    canvas.drawLine(
      Offset(startX + cellSize / 2, startY),
      Offset(startX + cellSize / 3, startY + cellSize / 2),
      detailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GameBoardPainter oldDelegate) {
    return true; // Always repaint when the game state changes
  }
}
