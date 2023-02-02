import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/audio_pool.dart';

import 'package:get_it/get_it.dart';

import './helpers/helpers.dart';
import '../../api/game_manager.dart';
import './game.dart';

GetIt getIt = GetIt.instance;

class Player extends SpriteComponent
    with Tappable, HasGameRef<FlappyDash>, CollisionCallbacks {
  Player() : super(size: Vector2.all(50));

  late AudioPool launchSfx;
  bool hasCollided = false;
  Vector2 velocityVector = Vector2(0, 0);

  @override
  void onCollision(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);
    print('COLLISION!!');

    sprite = await gameRef.loadSprite('game/explosion3.png');

    gameRef.activateGameOver(other.children);

    Future.delayed(const Duration(milliseconds: 100), () async {
      gameRef.pauseEngine();
    });
  }

  @override
  void update(double dt) async {
    Direction? direction = getIt<GameManager>().direction;
    sprite = await gameRef.loadSprite('game/dash.png');

    if (direction == null) {
      velocityVector = Vector2(0, 0);
    } else if (direction == Direction.up) {
      if (position.y <= 0) return;

      velocityVector = Vector2(0, -200);
    } else if (direction == Direction.down) {
      if (position.y >= gameRef.size.y - size.y) return;

      velocityVector = Vector2(0, 200);
    }

    position.add(velocityVector * dt);
  }

  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());
    sprite = await gameRef.loadSprite('game/dash.png');
  }
}
