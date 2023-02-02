import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

import 'config/theme.dart';
import 'ui/game.dart';
import 'api/game_manager.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt.registerSingleton<GameManager>(GameManager());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Fluppy',
      theme: customTheme,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Fly Fluppy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Game(),
    );
  }
}
