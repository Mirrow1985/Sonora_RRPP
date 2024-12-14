import 'package:flutter/material.dart';

class HelpPolicySection extends StatelessWidget {
  const HelpPolicySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Ayuda y políticas'),
      children: const [
        ListTile(
          title: Text('Ayuda'),
        ),
        ListTile(
          title: Text('Condiciones de uso'),
        ),
        ListTile(
          title: Text('Declaración de privacidad'),
        ),
        ListTile(
          title: Text('Eliminar cuenta'),
        ),
      ],
    );
  }
}