import 'package:flutter/material.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Eliminar Cuenta'), // Usar el widget reutilizable
      body: Center(
        child: Text('Contenido de Eliminar Cuenta'),
      ),
    );
  }
}