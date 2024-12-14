import 'package:flutter/material.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Cuenta'),
      children: const [
        ListTile(
          title: Text('Datos personales'),
        ),
        ListTile(
          title: Text('Cambiar contraseña'),
        ),
        ListTile(
          title: Text('Métodos de pago'),
        ),
        ListTile(
          title: Text('Preferencias de email'),
        ),
      ],
    );
  }
}