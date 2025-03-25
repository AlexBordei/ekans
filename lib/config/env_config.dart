import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static bool get debugMode =>
      dotenv.get('DEBUG_MODE', fallback: 'false') == 'true';
  static bool get accelerationTest =>
      dotenv.get('SNAKE_ACCELERATION_TEST', fallback: 'false') == 'true';
  static int get initialSnakeSpeed =>
      int.parse(dotenv.get('INITIAL_SNAKE_SPEED', fallback: '300'));
  static int get minSnakeSpeed =>
      int.parse(dotenv.get('MIN_SNAKE_SPEED', fallback: '100'));
  static int get speedDecreaseRate =>
      int.parse(dotenv.get('SPEED_DECREASE_RATE', fallback: '30'));
  static int get scoreLevelUp =>
      int.parse(dotenv.get('SCORE_LEVEL_UP', fallback: '50'));

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
