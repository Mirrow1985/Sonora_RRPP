import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompensas'),
      ),
      body: Center(
        child: const Text('Puntos acumulados y recompensas disponibles'),
      ),
    );
  }
}