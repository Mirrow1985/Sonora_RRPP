import 'package:flutter/material.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Métodos de pago'), // Usar el widget reutilizable
      body: Center(
        child: Text('Contenido de Métodos de Pago'),
      ),
    );
  }
}