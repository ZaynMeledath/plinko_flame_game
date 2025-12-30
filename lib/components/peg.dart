import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:plinko_flame_game/components/ball.dart';
import 'package:plinko_flame_game/plinko_game.dart';
import 'package:plinko_flame_game/src/plinko_configs.dart';
import 'package:plinko_flame_game/utils/plinko_audio.dart';

class Peg extends BodyComponent<PlinkoGame> with ContactCallbacks {
  final Vector2 pegPosition;

  bool hasAudioPlayedOnce = false;

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

  @override
  void beginContact(Object other, Contact contact) {
    if (hasAudioPlayedOnce) return;

    if (other is Ball) {
      PlinkoAudio().playPegHitSfx();
      hasAudioPlayedOnce = true;
    }
    super.beginContact(other, contact);
  }

  // @override
  // void render(Canvas canvas) {
  //   canvas.drawCircle(Offset.zero, PlinkoConfigs.pegRadius, pegPaint);
  //   super.render(canvas);
  // }
}
