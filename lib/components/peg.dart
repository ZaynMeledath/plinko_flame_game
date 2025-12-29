import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';

class Peg extends BodyComponent<PlinkoGame> {
  final Vector2 pegPosition;

  Peg({required this.pegPosition});

  // final pegPaint = Paint()..color = const Color(0xFFcbd5e1);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(pegPosition.x - PlinkoConfigs.pegRadius, pegPosition.y),
      type: BodyType.static,
    );

    final shape = CircleShape(position: Vector2(PlinkoConfigs.pegRadius, 0))
      ..radius = PlinkoConfigs.pegRadius;
    final fixtureDef = FixtureDef(shape);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawCircle(Offset.zero, PlinkoConfigs.pegRadius, pegPaint);
  //   super.render(canvas);
  // }
}
