// ignore_for_file: library_private_types_in_public_api

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'mandelbrot_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MandelbrotGame game;

  @override
  void initState() {
    super.initState();
    game = MandelbrotGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<double>(
          valueListenable: game.fps,
          builder: (_, fps, __) =>
              Text('Mandelbrot Set Viewer. FPS: ${fps.toStringAsFixed(2)}'),
          child: const Text('Mandelbrot Set Viewer'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: GameWidget(game: game),
    );
  }
}
