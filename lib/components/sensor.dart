import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:plinko_flame_game/bloc/plinko_bloc.dart';
import 'package:plinko_flame_game/components/ball.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/plinko_audio.dart';
import 'package:plinko_flame_game/utils/screen_size.dart';

class Sensor extends BodyComponent<PlinkoGame> with ContactCallbacks {
  final double sensorPositionX;
  final double multiplier;
  final Color color;

  Sensor({
    required this.sensorPositionX,
    required this.multiplier,
    required this.color,
  });

  final double sensorWidth = PlinkoConfigs.sensorSize.x;
  final double sensorHeight = PlinkoConfigs.sensorSize.y;

  late final Paint sensorPaint;

  late TextComponent label;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sensorPaint = Paint()..color = color;
    label = TextComponent(
      text: multiplier.toString(),
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.w(),
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2.zero(), // center of body
    );

    add(label);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      type: BodyType.static,
      position: Vector2(
        sensorPositionX + sensorWidth / 2,
        PlinkoConfigs.gameHeight - sensorHeight * 1.4,
      ),
    );

    final shape = PolygonShape()..setAsBoxXY(sensorWidth / 2, sensorHeight / 2);
    final fixtureDef = FixtureDef(shape, isSensor: true);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: sensorWidth,
        height: sensorHeight,
      ),
      sensorPaint,
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      PlinkoAudio().playWinSfx();
      plinkoBloc.add(PlinkoWinEvent(multiplier: multiplier));
      other.removeFromParent();
    }
  }
}
