import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import './game.dart';

class World extends ParallaxComponent<FlappyDash> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('game/bg.png'),
      ],
      baseVelocity: Vector2(250, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
  }
}
