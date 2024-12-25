import 'package:flutter/material.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pedidos realizados'), // Usar el widget reutilizable
      body: const Center(
        child: Text('Contenido de Pedidos realizados'),
      ),
    );
  }
}