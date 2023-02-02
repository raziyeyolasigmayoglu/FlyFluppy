import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'helpers/helpers.dart';
import 'enemy.dart';
import './enemy_manager.dart';
import './player.dart';
import './world.dart';
import './score.dart';
import '../../api/game_manager.dart';
import './game_over.dart';

GetIt getIt = GetIt.instance;

class FlappyDash extends FlameGame
    with KeyboardEvents, HasCollisionDetection, HasTappables, PanDetector {
  FlappyDash({super.children});
  late Player dash = Player();
  late final World _world = World();
  EnemyManager enemyManager = EnemyManager();
  ScoreDisplay scoreDisplay = ScoreDisplay();
  StartGameButton startButton = StartGameButton();
  PauseGameButton pauseButton = PauseGameButton();
  late RestartGameButton restartButton;
  late GameOver gameOver;

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyUpEvent) {
      getIt<GameManager>().releaseControl();
    }

    final bool isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        getIt<GameManager>().setDirection(Direction.down);
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        getIt<GameManager>().setDirection(Direction.up);
      }
    }

    return KeyEventResult.handled;
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    // TODO: implement onTapUp
    super.onTapUp(pointerId, info);

    getIt<GameManager>().setDirection(Direction.up);
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    // TODO: implement onTapDown
    super.onTapDown(pointerId, info);

    getIt<GameManager>().setDirection(Direction.down);
  }

  bool dragging = false;

  @override
  void onPanStart(DragStartInfo info) {
    // TODO: implement onPanStart
    super.onPanStart(info);
  }

  List<Vector2> s = [];

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // TODO: implement onPanUpdate
    super.onPanUpdate(info);

    s.add(info.delta.game);

    for (var i = 0; i < s.length; i++) {
      if (s[i].toString().contains('-')) {
        getIt<GameManager>().setDirection(Direction.up);
      } else {
        getIt<GameManager>().setDirection(Direction.down);
      }
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // TODO: implement onPanEnd
    super.onPanEnd(info);
  }

  @override
  Future<void> onLoad() async {
    await add(_world);
    await add(dash);

    await add(scoreDisplay);

    add(enemyManager);

    dash.position = Vector2(_world.size.x / 8, _world.size.y / 3);

    dash.add(startButton);
    startButton.position = Vector2(-40, -80);
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  void addPauseButton() {
    add(pauseButton);
  }

  void removePauseButton() {
    pauseButton.removeFromParent();
  }

  void addStartButton() {
    add(startButton);
  }

  void removeStartButton() {
    startButton.removeFromParent();
  }

  void activateGameOver(ComponentSet ss) {
    pauseButton.removeFromParent();

    getIt<GameManager>().setGameOver(true);

    overlays.add('GameOver');

    restartButton = RestartGameButton();
    add(restartButton);

    enemyManager.stop();
  }

  void resetGame() {
    resumeEngine();

    if (getIt<GameManager>().gameOver == false) {
      return;
    }

    getIt<GameManager>().resetScore();
    getIt<GameManager>().setGameOver(false);
    dash.position = Vector2(_world.size.x / 8, _world.size.y / 3);

    overlays.remove('GameOver');

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    pauseButton = PauseGameButton();
    add(pauseButton);
    restartButton.removeFromParent();

    enemyManager.removeFromParent();
    enemyManager = EnemyManager();
    add(enemyManager);
    enemyManager.start();

    //
  }

  @override
  Color backgroundColor() => Color.fromARGB(255, 158, 230, 244);
}

class Game extends StatelessWidget {
  Game({super.key});

  final game = FlappyDash();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      overlayBuilderMap: {
        'GameOver': (BuildContext context, FlappyDash game) {
          return const Padding(
              padding: EdgeInsets.only(top: 380),
              child: Center(
                  child: Text(
                'GAME OVER',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )));
        }
      },
    );
  }
}

class StartGameButton extends SpriteComponent
    with HasGameRef<FlappyDash>, Tappable {
  StartGameButton()
      : super(
          size: Vector2(400, 400),
          priority: 25,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    gameRef.resumeEngine();

    gameRef.addPauseButton();

    removeFromParent();

    return true;
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
    gameRef.pauseEngine();
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('game/start.png');
  }
}

class PauseGameButton extends SpriteComponent
    with HasGameRef<FlappyDash>, Tappable {
  PauseGameButton() : super(size: Vector2(100, 50), priority: 25);

  @override
  bool onTapDown(TapDownInfo info) {
    print('PRINT PAUSE');

    gameRef.addStartButton();

    gameRef.startButton.position = Vector2(15, 250);

    removeFromParent();

    return true;
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    position = Vector2(gameRef.size.x - 120, gameRef.size.y - 80);
    sprite = await gameRef.loadSprite('game/pause_button.png');
  }
}

class RestartGameButton extends SpriteComponent
    with HasGameRef<FlappyDash>, Tappable {
  RestartGameButton() : super(size: Vector2(330, 330), priority: 25);

  @override
  bool onTapDown(TapDownInfo info) {
    gameRef.resetGame();

    print('CLICK RESTART');

    //gameRef.resumeEngine();

    removeFromParent();

    return true;
  }

  @override
  void onMount() {
    // TODO: implement onMount
    super.onMount();
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    position = Vector2(gameRef.size.x - 370, gameRef.size.y - 250);
    sprite = await gameRef.loadSprite('game/start.png');
  }
}
