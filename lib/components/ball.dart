import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plinko_flame_game/bloc/plinko_bloc.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';

class Ball extends BodyComponent<PlinkoGame> {
  final double ballPositionX;

  Ball({required this.ballPositionX});

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(ballPositionX, PlinkoConfigs.gameHeight * .05),
      type: BodyType.dynamic,
      bullet: true,
      linearDamping: 0.1, // air resistance
      angularDamping: 0.1, // reduce spinning
    );

    final shape = CircleShape()..radius = PlinkoConfigs.ballRadius;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.5,
      friction: 0.2,
      density: 20,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    if (position.y > PlinkoConfigs.gameHeight) {
      plinkoBloc.add(PlinkoWinEvent(multiplier: 0));
      game.remove(this);
    }
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFef4444)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8);
    canvas.drawCircle(Offset.zero, PlinkoConfigs.ballRadius, paint);
  }
}
