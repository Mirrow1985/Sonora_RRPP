import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screen/principal_screen.dart';
import 'screen/scanner_screen.dart';
import 'screen/registro_screen.dart' as registro; // Usa un prefijo para este importe
import 'screen/qr_generation_screen.dart';
import 'screen/promociones_screen.dart'; // Importa PromocionesScreen
import 'screen/historial_qrs.dart'; // Importa HistorialQrsScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonora RRPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PrincipalScreen(),
        '/scanner': (context) => QRScannerScreen(),
        '/registro': (context) => registro.RegistroScreen(
          universidad: 'Facultad de Ciencias',
          promocion: 'Promoción 1', // Proporciona el parámetro promocion aquí
        ),
        '/qr_generation': (context) => QRGenerationScreen(clienteId: '123', correo: 'test@example.com'),
        '/promociones': (context) => PromocionesScreen(), // Agrega la ruta a PromocionesScreen
        '/historial_qrs': (context) => HistorialQrsScreen(), // Agrega la ruta a HistorialQrsScreen
      },
    );
  }
}
