// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'display_mand.dart'; // Importing the display logic

void main() => runApp(const MandelbrotApp());

class MandelbrotApp extends StatelessWidget {
  const MandelbrotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandelbrot Set Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initializing TextEditingController with a default value of "256"
  final TextEditingController _maxItersController = TextEditingController(text: "256");

  @override
  void dispose() {
    _maxItersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandelbrot Set Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _maxItersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Max Iterations',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_maxItersController.text.isNotEmpty) {
                  int maxIters = int.parse(_maxItersController.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayMandelbrot(maxIterations: maxIters),
                    ),
                  );
                }
              },
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
