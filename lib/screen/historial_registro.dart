import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistorialRegistroScreen extends StatelessWidget {
  const HistorialRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Registros'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('historial_registros')
            .orderBy('fechaRegistro', descending: true) // Ordenar por fechaRegistro, los más recientes primero
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay registros disponibles.'));
          }

          final registros = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];
              final data = registro.data() as Map<String, dynamic>?;

              final nombre = data?.containsKey('nombre') == true ? data!['nombre'] : 'Sin nombre';
              final promocion = data?.containsKey('promocion') == true ? data!['promocion'] : 'Sin promoción';
              final facultad = data?.containsKey('universidad') == true ? data!['universidad'] : 'Sin facultad';
              final correo = data?.containsKey('correo') == true ? data!['correo'] : 'Sin correo';
              final estadoEnvio = data?.containsKey('estadoEnvio') == true ? data!['estadoEnvio'] : 'Desconocido';
              final fechaRegistro = data?.containsKey('fechaRegistro') == true ? (data!['fechaRegistro'] as Timestamp).toDate() : DateTime.now();
              final formattedFechaRegistro = DateFormat('dd-MM-yyyy HH:mm:ss').format(fechaRegistro);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${registros.length - index}'), // Ajustar el índice para que el número 1 sea el primer registro
                  ),
                  title: Text(nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      Text('Promoción: $promocion'),
                      Text('Facultad: $facultad'),
                      Text('Correo: $correo'),
                      Text('Fecha y Hora: $formattedFechaRegistro'),
                      SizedBox(height: 4.0),
                      Text('Estado: $estadoEnvio', style: TextStyle(color: Colors.green)),
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