import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final int score;
  final int level;
  final VoidCallback onRestart;

  const GameOverDialog({
    super.key,
    required this.score,
    required this.level,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Game Over',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Your snake crashed!', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _buildScoreItem('Final Score', score.toString()),
          const SizedBox(height: 8),
          _buildScoreItem('Level Reached', level.toString()),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onRestart();
          },
          child: const Text('Play Again'),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildScoreItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
