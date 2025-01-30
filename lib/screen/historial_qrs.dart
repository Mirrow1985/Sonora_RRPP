import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistorialQrsScreen extends StatelessWidget {
  const HistorialQrsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de QRs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('historial_qrs').orderBy('fechaEscaneo', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay registros disponibles.'));
          }

          final registros = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];
              final data = registro.data() as Map<String, dynamic>?;

              final qrData = data?.containsKey('qrData') == true ? data!['qrData'] : 'Sin datos';
              final nombre = data?.containsKey('nombre') == true ? data!['nombre'] : 'Sin nombre';
              final correo = data?.containsKey('correo') == true ? data!['correo'] : 'Sin correo';
              final promocion = data?.containsKey('promocion') == true ? data!['promocion'] : 'Sin promoción';
              final fechaEscaneo = data?.containsKey('fechaEscaneo') == true ? (data!['fechaEscaneo'] as Timestamp).toDate() : DateTime.now();
              final formattedFechaEscaneo = DateFormat('dd-MM-yyyy HH:mm:ss').format(fechaEscaneo);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${registros.length - index}'), // Ajustar el índice para que el número 1 sea el primer registro
                  ),
                  title: Text('QR Data: $qrData'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Nombre: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: nombre),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Correo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: correo),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Promoción: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: promocion),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Fecha de Escaneo: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: formattedFechaEscaneo),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}