import 'package:flame/components.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

class PlinkoConfigs {
  static double gameWidth = 350;
  static double gameHeight = 350;
  static double ballRadius = 9;
  static double pegRadius = 7;
  static double pegGap = 24;
  static Vector2 sensorSize = Vector2(40, 20);
  static double sensorGap = 8;

  static void init() {
    gameWidth = screenSize.width * .94;
    gameHeight = gameWidth;
    ballRadius = 9.w();
    pegRadius = 7.w();
    pegGap = 24.w();
    sensorSize = Vector2(38.w(), 20.w());
    sensorGap = 8.w();
  }
}
