import 'package:flutter/material.dart';

class CondicionesDeUso extends StatelessWidget {
  const CondicionesDeUso({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Condiciones de Uso'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Condiciones de Uso',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Aquí puedes escribir las condiciones de uso...',
                style: TextStyle(fontSize: 16),
              ),
              // Añade más contenido aquí según sea necesario
            ],
          ),
        ),
      ),
    );
  }
}