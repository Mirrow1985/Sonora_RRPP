import 'package:flutter/material.dart';
import '../screen/universidad_screen.dart';
import '../screen/scanner_screen.dart'; // Asegúrate de importar ScannerScreen

class PrincipalScreen extends StatelessWidget {
  const PrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Principal Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeleccionUniversidadScreen()),
                );
              },
              child: Text('RRPP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()), // Asegúrate de usar QRScannerScreen
                );
              },
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
