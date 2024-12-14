import 'package:flutter/material.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Seguridad'),
      children: [
        SwitchListTile(
          title: const Text('Bloqueo mediante contraseña'),
          value: true,
          onChanged: (bool value) {},
        ),
        SwitchListTile(
          title: const Text('Desbloqueo biométrico'),
          value: false,
          onChanged: (bool value) {},
        ),
      ],
    );
  }
}