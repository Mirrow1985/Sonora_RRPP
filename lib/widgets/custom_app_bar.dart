import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0), // Aumentar el espacio del icono
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      title: const Text(''), // Título vacío para centrar el contenido
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0), // Ajustar la altura del contenido adicional
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1), // Espacio adicional hacia abajo
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0), // Ajustar el espacio a la izquierda y hacia abajo
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 4.0, // Ajustar la altura para evitar el desbordamiento
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade800.withAlpha(204), // Gris oscuro
                    Colors.grey.shade600.withAlpha(153), // Gris menos oscuro
                    Colors.grey.shade400.withAlpha(102), // Gris claro
                    Colors.grey.shade200.withAlpha(51), // Gris más claro
                    Colors.transparent // Transparente
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0); // Ajustar la altura del AppBar
}