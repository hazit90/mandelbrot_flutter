import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MandelbrotCalculator {
  static const int maxIters = 1000;

// Returns a tuple of lists containing Offset and Color respectively
  static Map<String, dynamic> generatePointsAndColors(
      Vector2 size,
      double offsetX,
      double offsetY,
      double scaleX,
      double scaleY,
      double zoomLevel) {
    List<Offset> points = [];
    List<Color> colors = [];

    for (int x = 0; x < size.x; x++) {
      for (int y = 0; y < size.y; y++) {
        double cx, cy;
        (cx, cy) = mapToComplexPlane(
            x, y, offsetX, offsetY, scaleX, scaleY, zoomLevel, size.toSize());
        int iterations = calculate(cx, cy, maxIters);
        Color color = iterationsToColor(iterations);
        points.add(Offset(x.toDouble(), y.toDouble()));
        colors.add(color);
      }
    }
    return {'points': points, 'colors': colors};
  }

  static int calculate(double cx, double cy, int maxIterations) {
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

  static Color iterationsToColor(int iterations) {
    if (iterations == maxIters) {
      return Colors.black; // Inside the Mandelbrot set
    } else {
      double hue = (iterations % 360).toDouble();
      return HSVColor.fromAHSV(1.0, hue, 1.0, 0.5).toColor();
    }
  }

  static (double, double) mapToComplexPlane(
      int x,
      int y,
      double offsetX,
      double offsetY,
      double scaleX,
      double scaleY,
      double zoomLevel,
      Size size) {
    return (
      offsetX + (x / size.width * scaleX) / zoomLevel,
      offsetY + (y / size.height * scaleY) / zoomLevel
    );
  }
}
