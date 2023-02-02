import 'package:com.flyfluppy/ui/game.dart';
import 'package:flame/components.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class GameOver extends SpriteComponent with HasGameRef<FlappyDash> {
  GameOver() : super(position: Vector2(40, 100));

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }

  void clear() {
    removeFromParent();
  }

  @override
  void onRemove() {
    // TODO: implement onRemove
    super.onRemove();
  }

  @override
  void update(double dt) {}

  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('game/gameover.png');
    x = 5;
    y = 110;
    priority = 25;
  }
}
