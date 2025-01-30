import 'package:flutter/material.dart';
import 'universidad_screen.dart'; // Importa SeleccionUniversidadScreen

class PromocionesScreen extends StatelessWidget {
  const PromocionesScreen({super.key});

  static const List<String> promociones = [
    '¡Cumplimos 16 años!',
    'Promoción 2',
    'Promoción 3',
    'Otra Promoción'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Promociones'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: promociones.map((promocion) {
          return _buildPromotionItem(context, promocion);
        }).toList(),
      ),
    );
  }

  Widget _buildPromotionItem(BuildContext context, String promocion) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SeleccionUniversidadScreen(promocion: promocion),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: promocion == '¡Cumplimos 16 años!'
                    ? Image.asset(
                        'assets/images/promocion_universidad.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : Text(
                        promocion,
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(promocion, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}