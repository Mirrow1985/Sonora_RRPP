import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Asegúrate de que esta línea esté presente
import 'package:firebase_auth/firebase_auth.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final qrData = user != null ? user.uid : 'No user data';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar'),
      ),
      body: Center(
        child: Container(
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ),
      ),
    );
  }
}
