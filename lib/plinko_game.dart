import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plinko_flame_game/components/ball.dart';
import 'package:plinko_flame_game/components/peg.dart';
import 'package:plinko_flame_game/components/sensor.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

class PlinkoGame extends Forge2DGame {
  final rowCount = 8;
  final List<double> multipliers = [10.0, 2.5, 1.2, .8, 0.5, 1.2, 2.5, 10.0];

  PlinkoGame() : super(gravity: Vector2(0, 500));

  @override
  void onLoad() {
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(PlinkoConfigs.gameWidth, PlinkoConfigs.gameHeight),
    );
    _createPegs();
    _createSensors();
  }

  //==================== Create Pegs ====================//
  void _createPegs() {
    final startX = PlinkoConfigs.gameWidth / 2;
    final startY = PlinkoConfigs.gameHeight * .14;

    for (int i = 1; i <= rowCount; i++) {
      final rowStartX =
          startX -
          PlinkoConfigs.pegRadius * (i + 1) -
          PlinkoConfigs.pegGap / 2 * (i + 1);

      _createPegRow(
        totalPegs: i + 2,
        rowStartX: rowStartX,
        rowStartY:
            startY +
            (PlinkoConfigs.ballRadius * 2 + PlinkoConfigs.pegGap) * (i - 1),
      );
    }
  }

  //==================== Create Peg Row ====================//
  void _createPegRow({
    required int totalPegs,
    required double rowStartX,
    required double rowStartY,
  }) {
    for (int i = 0; i < totalPegs; i++) {
      final pegPositionX =
          rowStartX + (PlinkoConfigs.pegRadius * 2 + PlinkoConfigs.pegGap) * i;
      add(Peg(pegPosition: Vector2(pegPositionX, rowStartY)));
    }
  }

  //==================== Create Sensors ====================//
  void _createSensors() {
    final sensorWidth = PlinkoConfigs.sensorSize.x;

    final totalWidthOfSensors =
        sensorWidth * rowCount + PlinkoConfigs.sensorGap * (rowCount - 1);

    final startX = (PlinkoConfigs.gameWidth - totalWidthOfSensors) / 2;

    for (int i = 0; i < rowCount; i++) {
      final sensorPositionX =
          startX + i * (sensorWidth + PlinkoConfigs.sensorGap);
      add(Sensor(sensorPositionX: sensorPositionX, multiplier: multipliers[i]));
    }
  }

  void dropBall() {
    final random = (Random().nextDouble() - 0.5) * 100.w();
    final Ball ball = Ball(ballPositionX: PlinkoConfigs.gameWidth / 2 + random);
    add(ball);
  }
}
