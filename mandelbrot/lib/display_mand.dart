import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'mandelbrot_calculator.dart'; // Ensure you have this import

class DisplayMandelbrot extends StatefulWidget {
  final int maxIterations;

  const DisplayMandelbrot({super.key, required this.maxIterations});

  @override
  _DisplayMandelbrotState createState() => _DisplayMandelbrotState();
}

class _DisplayMandelbrotState extends State<DisplayMandelbrot> {
  int frameCount = 0;
  double fps = 0.0;
  late Timer timer;
  List<double> fpsBuffer = [];
  double averageFps = 0.0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), (Timer t) {
      setState(() {
        fps = frameCount * 2.0; // Calculate the FPS based on frames counted over 500 ms
        frameCount = 0; 
        updateFpsBuffer(fps);
      });
    });
  }

  void updateFpsBuffer(double newFps) {
    if (fpsBuffer.length == 10) {
      fpsBuffer.removeAt(0); // Remove the oldest entry
    }
    fpsBuffer.add(newFps); // Add the new FPS value
    averageFps = fpsBuffer.reduce((a, b) => a + b) / fpsBuffer.length; // Calculate average FPS
  }

  @override
  void dispose() {
    timer.cancel(); // Important to dispose of the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FPS: ${averageFps.toStringAsFixed(2)}"), // Display the average FPS
      ),
      body: CustomPaint(
        painter: MandelbrotPainter(widget.maxIterations, () {
          frameCount++; // Increment the frame count for each repaint
        }),
        size: Size.infinite,
      ),
    );
  }
}

class MandelbrotPainter extends CustomPainter {
  final int maxIterations;
  final Function onPaintDone;
  double scaleX = 3.5;
  double scaleY = 2.0;
  double offsetX = -2.5;
  double offsetY = -1.0;
  double zoomLevel = 1.0;

  MandelbrotPainter(this.maxIterations, this.onPaintDone);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = 1.0;

    var colorMap = MandelbrotCalculator.generatePointsAndColors(size, offsetX,
        offsetY, scaleX / zoomLevel, scaleY / zoomLevel, zoomLevel, maxIterations);

    colorMap.forEach((color, points) {
      paint.color = color;
      canvas.drawPoints(PointMode.points, points, paint);
    });
    onPaintDone(); // Callback after painting is done
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
