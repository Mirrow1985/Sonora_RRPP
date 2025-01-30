import 'package:flutter/material.dart';
import 'promociones_screen.dart'; // Importa PromocionesScreen
import 'scanner_screen.dart'; // Importa QRScannerScreen
import 'historial_qrs.dart'; // Importa HistorialQrsScreen

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal'),
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
                    builder: (context) => PromocionesScreen(),
                  ),
                );
              },
              child: Text('RRPP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(),
                  ),
                );
              },
              child: Text('Escanear QR'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialQrsScreen(),
                  ),
                );
              },
              child: Text('Historial QR\'s'),
            ),
          ],
        ),
      ),
    );
  }
}
