import 'package:flutter/material.dart';
import 'registro_screen.dart'; // Importa RegistroScreen

class SeleccionUniversidadScreen extends StatelessWidget {
  final String promocion;

  const SeleccionUniversidadScreen({super.key, required this.promocion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona la Universidad'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroScreen(universidad: 'Facultad de Ciencias', promocion: promocion),
                  ),
                );
              },
              child: Text('Facultad de Ciencias'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroScreen(universidad: 'Ingeniería de Caminos', promocion: promocion),
                  ),
                );
              },
              child: Text('Ingeniería de Caminos'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroScreen(universidad: 'Ingeniería de la Edificación', promocion: promocion),
                  ),
                );
              },
              child: Text('Ingeniería de la Edificación'),
            ),
          ],
        ),
      ),
    );
  }
}
