import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Text(
          'Bienvenido al Panel de Administración',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}