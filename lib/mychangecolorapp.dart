import 'package:flutter/material.dart';
import 'dart:math';
import 'package:telekilogram/HomePage.dart';
class Mychangecorapp extends StatefulWidget {
  const Mychangecorapp({super.key});

  @override
  State<Mychangecorapp> createState() => _MychangecorappState();
}

class _MychangecorappState extends State<Mychangecorapp> {
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Purple', 'color': Colors.purple},
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Teal', 'color': Colors.teal},
    {'name': 'Cyan', 'color': Colors.cyan},
    {'name': 'Amber', 'color': Colors.amber},
    {'name': 'Brown', 'color': Colors.brown},
    {'name': 'Grey', 'color': Colors.grey},
    {'name': 'Indigo', 'color': Colors.indigo},
    {'name': 'Lime', 'color': Colors.lime},
    {'name': 'Black', 'color': Colors.black},
    {'name': 'White', 'color': Colors.white},
  ];
  Color _currentColor = Colors.purple;
  String _currentColorName = "Purple";
  
  final Random _random = Random();

  void _changeColor() {
    final randomIndex = _random.nextInt(_colors.length);
    final randomColorData = _colors[randomIndex];

    setState(() {
      _currentColor = randomColorData['color'];
      _currentColorName = randomColorData['name'];
    });
  }

  void _resetColor() {
    setState(() {
      _currentColor = Colors.purple;
      _currentColorName = "Purple";
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness =
        ThemeData.estimateBrightnessForColor(_currentColor);
    final Color textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      drawer: AppNavigationDrawer(),
      appBar: AppBar(
        title: Text(
          "Change Color App",
          style: TextStyle(color: textColor),
        ),
        backgroundColor: _currentColor,
        elevation: 0,
      ),
      body: Container(
        color: _currentColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Current color:",
                style: TextStyle(fontSize: 24, color: textColor),
              ),
              Text(
                // 3. Hiển thị tên màu thay vì mã Hex
                _currentColorName,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _changeColor,
                    child: const Text("Change Color"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetColor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Reset Color"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}