import 'package:flutter/material.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cambiar contraseña'), // Usar el widget reutilizable
      body: Center(
        child: Text('Contenido de Cambiar Contraseña'),
      ),
    );
  }
}