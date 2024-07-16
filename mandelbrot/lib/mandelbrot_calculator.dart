import 'package:flutter/material.dart';

class MandelbrotCalculator {
  static int maxIterations = 1000;

// Returns a tuple of lists containing Offset and Color respectively
  static Map<Color, List<Offset>> generatePointsAndColors(
      Size size,
      double offsetX,
      double offsetY,
      double scaleX,
      double scaleY,
      double zoomLevel,
      maxIters) {
    Map<Color, List<Offset>> colorMap = {};

    for (int x = 0; x < size.width; x++) {
      for (int y = 0; y < size.height; y++) {
        double cx, cy;
        (cx, cy) = mapToComplexPlane(
            x, y, offsetX, offsetY, scaleX, scaleY, zoomLevel, size);
        int iterations = calculate(cx, cy, maxIters);
        Color color = iterationsToColor(iterations);
        if (!colorMap.containsKey(color)) {
          colorMap[color] = [];
        }
        colorMap[color]?.add(Offset(x.toDouble(), y.toDouble()));
      }
    }
    maxIterations = maxIters;
    return colorMap;
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
    if (iterations == maxIterations) {
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
