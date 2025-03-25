import 'package:flutter/material.dart';
import '../models/snake.dart';

class ControlPanel extends StatelessWidget {
  final Function(Direction) onDirectionChanged;
  final VoidCallback onStartPressed;
  final VoidCallback onPausePressed;
  final VoidCallback onResetPressed;
  final bool isPlaying;
  final bool isPaused;

  const ControlPanel({
    super.key,
    required this.onDirectionChanged,
    required this.onStartPressed,
    required this.onPausePressed,
    required this.onResetPressed,
    required this.isPlaying,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Game control buttons - moved to top for better visibility
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.play_arrow,
                label: 'PLAY',
                onPressed: !isPlaying || isPaused ? onStartPressed : null,
                color: Colors.green,
              ),
              ActionButton(
                icon: isPaused ? Icons.play_arrow : Icons.pause,
                label: isPaused ? 'RESUME' : 'PAUSE',
                onPressed: isPlaying ? onPausePressed : null,
                color: Colors.amber,
              ),
              ActionButton(
                icon: Icons.refresh,
                label: 'RESET',
                onPressed: onResetPressed,
                color: Colors.red,
              ),
            ],
          ),
        ),

        // Direction controls
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  DirectionButton(
                    icon: Icons.arrow_upward,
                    onPressed: () => onDirectionChanged(Direction.up),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      DirectionButton(
                        icon: Icons.arrow_back,
                        onPressed: () => onDirectionChanged(Direction.left),
                      ),
                      const SizedBox(width: 8),
                      DirectionButton(
                        icon: Icons.arrow_downward,
                        onPressed: () => onDirectionChanged(Direction.down),
                      ),
                      const SizedBox(width: 8),
                      DirectionButton(
                        icon: Icons.arrow_forward,
                        onPressed: () => onDirectionChanged(Direction.right),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DirectionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const DirectionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
