import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_state.dart';
import '../models/snake.dart' as snake;
import '../widgets/game_board.dart';
import '../widgets/score_board.dart';
import '../widgets/game_over_dialog.dart';
import '../widgets/debug_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState gameState;
  late Timer gameTimer;
  bool get isPlaying => gameState.status == GameStatus.playing;
  bool get isPaused => gameState.status == GameStatus.paused;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    gameState = GameState(boardWidth: 20, boardHeight: 20);
    gameTimer = Timer.periodic(
      Duration(milliseconds: (gameState.getCurrentSpeed() * 1000).round()),
      (timer) => updateGame(),
    );
    startGame();
  }

  void startGame() {
    // Initial timer setup
    updateGameTimer();
  }

  void updateGameTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(
      Duration(milliseconds: (gameState.getCurrentSpeed() * 1000).round()),
      (timer) => updateGame(),
    );
  }

  void onFoodCollected() {
    gameState.addScore();
    // Update the game speed whenever food is collected
    updateGameTimer();

    // Update UI to show score
    setState(() {});
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    gameState.dispose();
    super.dispose();
  }

  void _changeDirection(snake.Direction direction) {
    if (gameState.status == GameStatus.playing) {
      setState(() {
        gameState.changeDirection(direction);
      });
    }
  }

  void _startGame() {
    setState(() {
      gameState.startGame();
      // Update timer with current game speed
      updateGameTimer();
    });
    // Request focus for keyboard input
    _focusNode.requestFocus();
  }

  void _pauseGame() {
    setState(() {
      gameState.pauseGame();
    });
  }

  void _resetGame() {
    setState(() {
      gameState.reset();
      updateGameTimer();
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => GameOverDialog(
            score: gameState.score,
            level: gameState.level,
            onRestart: () {
              setState(() {
                gameState.reset();
                gameState.startGame();
                updateGameTimer();
              });
              // Request focus for keyboard input after restart
              _focusNode.requestFocus();
            },
          ),
    );
  }

  // Handle swipe gestures to change snake direction
  void _handleSwipe(DragUpdateDetails details) {
    if (!isPlaying) return;

    // Get the swipe direction vector
    final dx = details.delta.dx;
    final dy = details.delta.dy;

    // Only respond to significant swipes
    if (dx.abs() < 1.0 && dy.abs() < 1.0) return;

    // Determine if the swipe is more horizontal or vertical
    if (dx.abs() > dy.abs()) {
      // Horizontal swipe
      if (dx > 0) {
        _changeDirection(snake.Direction.right);
      } else {
        _changeDirection(snake.Direction.left);
      }
    } else {
      // Vertical swipe
      if (dy > 0) {
        _changeDirection(snake.Direction.down);
      } else {
        _changeDirection(snake.Direction.up);
      }
    }
  }

  // Handle keyboard input
  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (gameState.status == GameStatus.playing) {
        setState(() {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            gameState.changeDirection(snake.Direction.up);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            gameState.changeDirection(snake.Direction.down);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            gameState.changeDirection(snake.Direction.left);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            gameState.changeDirection(snake.Direction.right);
          }
        });
      }

      // Space to start/pause game
      if (event.logicalKey == LogicalKeyboardKey.space) {
        if (gameState.status == GameStatus.notStarted) {
          _startGame();
        } else if (gameState.status == GameStatus.playing ||
            gameState.status == GameStatus.paused) {
          _pauseGame();
        }
      }

      // R to reset game
      if (event.logicalKey == LogicalKeyboardKey.keyR) {
        _resetGame();
      }
    }
  }

  void updateGame() {
    if (gameState.status == GameStatus.playing) {
      setState(() {
        gameState.update();
        if (gameState.status == GameStatus.gameOver) {
          _showGameOverDialog();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = AppBar().preferredSize.height;
    final safePadding =
        MediaQuery.of(context).padding.top +
        MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - appBarHeight - safePadding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ekans Snake Game'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _handleKeyEvent,
        autofocus: true,
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ScoreBoard(
                      score: gameState.score,
                      level: gameState.level,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onPanUpdate: _handleSwipe,
                    onTap: () {
                      if (gameState.status == GameStatus.notStarted ||
                          gameState.status == GameStatus.paused) {
                        _startGame();
                      }
                    },
                    child: GameBoard(gameState: gameState),
                  ),
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.grey.shade300,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed:
                                  !isPlaying || isPaused ? _startGame : null,
                              icon: const Icon(Icons.play_arrow),
                              label: Text(isPaused ? 'RESUME' : 'PLAY'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed:
                                  isPlaying && !isPaused ? _pauseGame : null,
                              icon: const Icon(Icons.pause),
                              label: const Text('PAUSE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _resetGame,
                              icon: const Icon(Icons.refresh),
                              label: const Text('RESET'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Swipe on the game board to control the snake',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DebugOverlay(gameState: gameState),
          ],
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (gameState.status) {
      case GameStatus.notStarted:
        return 'Press PLAY to Start';
      case GameStatus.playing:
        return 'Game in Progress';
      case GameStatus.paused:
        return 'Game Paused';
      case GameStatus.gameOver:
        return 'Game Over';
    }
  }

  Color _getStatusColor() {
    switch (gameState.status) {
      case GameStatus.notStarted:
        return Colors.blue;
      case GameStatus.playing:
        return Colors.green;
      case GameStatus.paused:
        return Colors.amber;
      case GameStatus.gameOver:
        return Colors.red;
    }
  }
}
