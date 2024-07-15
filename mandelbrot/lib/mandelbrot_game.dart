import 'dart:async';
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mandelbrot_calculator.dart'; // Assuming MandelbrotCalculator logic is correct and already in use

class MandelbrotGame extends FlameGame {
  double scaleX = 3.5;
  double scaleY = 2.0;
  double offsetX = -2.5;
  double offsetY = -1.0;
  double zoomLevel = 1.0;

  int _frames = 0;
  double _elapsedTime = 0;
  Timer? _fpsTimer;
  ValueNotifier<double> fps = ValueNotifier(0.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startFpsLogging();
  }

  void _startFpsLogging() {
    _fpsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (_elapsedTime > 0) {
        // Guard against division by zero
        double newFps = _frames / _elapsedTime;
        if (kDebugMode) {
          print('FPS: ${newFps.toStringAsFixed(2)}');
        }
        fps.value = newFps;
      }
      _frames = 0;
      _elapsedTime = 0;
    });
  }

  @override
  Future<void> onRemove() async {
    _fpsTimer?.cancel();
    super.onRemove();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..strokeWidth = 1.0;

    // Using the new method from MandelbrotCalculator and properly handling the return types
    var data = MandelbrotCalculator.generatePointsAndColors(
        size, offsetX, offsetY, scaleX, scaleY, zoomLevel);
    List<Offset> points =
        data['points'] as List<Offset>; // Explicitly cast to List<Offset>
    List<Color> colors =
        data['colors'] as List<Color>; // Explicitly cast to List<Color>

    for (int i = 0; i < points.length; i++) {
      paint.color = colors[i];
      canvas.drawPoints(PointMode.points, [points[i]], paint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _frames++;
    _elapsedTime += dt;
  }
}
