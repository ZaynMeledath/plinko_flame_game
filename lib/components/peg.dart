import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plinko_flame_game/components/ball.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/plinko_audio.dart';

class Peg extends BodyComponent<PlinkoGame> with ContactCallbacks {
  final Vector2 pegPosition;

  bool hasSfxPlayedOnce = false;

  Peg({required this.pegPosition});

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

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (hasSfxPlayedOnce) return;

    if (other is Ball) {
      PlinkoAudio().playPegHitSfx();
      hasSfxPlayedOnce = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        hasSfxPlayedOnce = false;
      });
    }
  }
}
