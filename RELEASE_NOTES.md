# Ekans Snake Game v1.0.0

## Features
- Classic snake gameplay with modern Flutter UI
- Touch controls with swipe gestures
- Keyboard controls (arrow keys)
- Score tracking and level progression
- Debug overlay for testing snake acceleration
- Configurable game settings through environment variables

## Game Controls
- Swipe gestures to control snake direction
- Arrow keys for keyboard control
- Space bar to start/pause game
- R key to reset game

## Debug Features
- Real-time speed monitoring
- Acceleration rate tracking
- Level and score display
- Configurable through .env file:
  - DEBUG_MODE
  - SNAKE_ACCELERATION_TEST
  - INITIAL_SNAKE_SPEED
  - MIN_SNAKE_SPEED
  - SPEED_DECREASE_RATE
  - SCORE_LEVEL_UP

## Technical Details
- Built with Flutter
- Cross-platform support (iOS, Android, Web, Desktop)
- Material Design 3 UI
- Responsive layout
- Portrait mode only

## Installation
1. Clone the repository
2. Run `flutter pub get`
3. Configure .env file (optional)
4. Run `flutter run`

## Requirements
- Flutter SDK
- Dart SDK
- Platform-specific development tools (Xcode for iOS, Android Studio for Android) 