import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MandelbrotGame extends FlameGame {
  double scaleX = 3.5;
  double scaleY = 2.0;
  double offsetX = -2.5;
  double offsetY = -1.0;
  double zoomLevel = 1.0;
  static const int MAX_ITERS = 1000;

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
      double newFps = _frames / _elapsedTime;
      if (kDebugMode) {
        print('FPS: ${newFps.toStringAsFixed(2)}');
      }
      fps.value = newFps;
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
    final paint = Paint();
    for (int x = 0; x < size.x; x++) {
      for (int y = 0; y < size.y; y++) {
        double cx, cy;
        (cx, cy) = mapToComplexPlane(x, y); // Now returns a tuple of doubles
        int iterations = mandelbrot(
            cx, cy, MAX_ITERS); // Use the modified mandelbrot function
        paint.color = iterationsToColor(iterations);
        canvas.drawRect(Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), paint);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _frames++;
    _elapsedTime += dt;
  }

  (double, double) mapToComplexPlane(int x, int y) {
    return (
      offsetX + (x / size.x * scaleX) / zoomLevel,
      offsetY + (y / size.y * scaleY) / zoomLevel
    );
  }

  Color iterationsToColor(int iterations) {
    if (iterations == MAX_ITERS) {
      return Colors.black; // Inside the Mandelbrot set
    } else {
      // Create a cyclic effect based on iteration count
      double hue =
          (iterations % 360).toDouble(); // Use the iteration count for hue
      return HSVColor.fromAHSV(1.0, hue, 1.0, 0.5)
          .toColor(); // Full saturation, half brightness
    }
  }

  int mandelbrot(double cx, double cy, int maxIterations) {
    double zx = cx, zy = cy;
    int nv = 0;
    for (nv; nv < maxIterations - 1; nv++) {
      final zzx = zx * zx;
      final zzy = zy * zy;
      if (zzx + zzy > 4) {
        break;
      }
      double newZx = zzx - zzy + cx;
      zy = 2 * zx * zy + cy;
      zx = newZx;
    }
    return nv;
  }
}
