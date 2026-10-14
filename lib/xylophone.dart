import 'package:flutter/material.dart';

class Xylophone extends StatelessWidget {
  const Xylophone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ColorTile(color: Colors.red, number: 1),
          ColorTile(color: Colors.orange, number: 2),
          ColorTile(color: Colors.yellow, number: 3),
          ColorTile(color: Colors.green, number: 4),
          ColorTile(color: Colors.blue.shade300, number: 5),
          ColorTile(color: Colors.blueAccent, number: 6),
          ColorTile(color: Colors.purple, number: 7),
        ],
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;
  final int number;
  const ColorTile({super.key, required this.color, required this.number});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {

          print("color");
        },
        child: Container(color: color),
      ),
    );
  }
}
