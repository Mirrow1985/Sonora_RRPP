import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResultsQRScreen extends StatelessWidget {
  final String userId;

  const ResultsQRScreen({super.key, required this.userId});

  Future<bool> _checkIfCodeIsValid(String code) async {
    final doc = await FirebaseFirestore.instance.collection('qr_codes').doc(code).get();
    if (doc.exists && doc['isValid'] == true) {
      // Mark the code as used
      await FirebaseFirestore.instance.collection('qr_codes').doc(code).update({'isValid': false});
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Result'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<bool>(
        future: _checkIfCodeIsValid(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == true) {
            return Center(child: Text('¡Código válido, ponle una cerveza!'));
          } else {
            return Center(child: Text('Código inválido o ya canjeado.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}