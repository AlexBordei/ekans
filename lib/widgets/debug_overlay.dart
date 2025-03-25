import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../config/env_config.dart';

class DebugOverlay extends StatelessWidget {
  final GameState gameState;

  const DebugOverlay({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    if (!EnvConfig.debugMode) return const SizedBox.shrink();

    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          gameState.debugInfo,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'monospace',
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
