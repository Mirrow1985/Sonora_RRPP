import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final qrData = user != null ? user.uid : 'No user data';
    final Logger logger = Logger(); // Renombrar la variable a logger

    logger.i('Building PayScreen'); // Usar logger para registrar mensajes

    return Center(
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}
