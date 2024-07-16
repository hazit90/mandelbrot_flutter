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
  final TransformationController _transformationController = TransformationController();

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
    _transformationController.dispose(); // Dispose the transformation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FPS: ${averageFps.toStringAsFixed(2)}"), // Display the average FPS
      ),
      body: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.1,
        maxScale: 50.0,
        child: CustomPaint(
          painter: MandelbrotPainter(widget.maxIterations, () {
            frameCount++; // Increment the frame count for each repaint
          }, _transformationController.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class MandelbrotPainter extends CustomPainter {
  final int maxIterations;
  final Function onPaintDone;
  final Matrix4 transform;

  MandelbrotPainter(this.maxIterations, this.onPaintDone, this.transform);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.transform(transform.storage); // Apply the transformation to the canvas

    Paint paint = Paint()..strokeWidth = 1.0;

    var colorMap = MandelbrotCalculator.generatePointsAndColors(
        size, -2.5, -1.0, 3.5, 2.0, 1.0, maxIterations);

    colorMap.forEach((color, points) {
      paint.color = color;
      canvas.drawPoints(PointMode.points, points, paint);
    });
    onPaintDone(); // Callback after painting is done
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for now, to handle zoom and pan updates
  }
}
