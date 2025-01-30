import 'package:flutter/material.dart';

class FlyerScreen extends StatelessWidget {
  final String imagePath;

  const FlyerScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flyer Promoción'),
      ),
      body: Center(
        child: Image.asset(imagePath),
      ),
    );
  }
}