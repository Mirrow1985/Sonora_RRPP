import 'package:auth_firebase/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title:('Condiciones de uso'),
      ),
      body: Center(
        child: Text('Contenido de Condiciones de uso'),
      ),
    );
  }
}