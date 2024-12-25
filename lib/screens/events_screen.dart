import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Eliminar el botón de ir hacia atrás
        title: const Text('Eventos'),
      ),
      body: Center(
        child: Text('Contenido de la pantalla de eventos'),
      ),
    );
  }
}