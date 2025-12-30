import 'package:flame_audio/flame_audio.dart';
import 'package:plinko_flame_game/src/plinko_assets.dart';

class PlinkoAudio {
  PlinkoAudio._internal();
  static final PlinkoAudio _instance = PlinkoAudio._internal();
  factory PlinkoAudio() => _instance;

  void playPegHitSfx() {
    FlameAudio.play(PlinkoAssets.pegHitSfx);
  }

  void playWinSfx() async {
    await FlameAudio.play(PlinkoAssets.winSfx);
  }
}
