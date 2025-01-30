import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import '../services/correo_service.dart'; // Importa CorreoService
import 'package:logger/logger.dart'; // Importa Logger

class QRGenerationScreen extends StatefulWidget {
  final String clienteId;
  final String correo;

  const QRGenerationScreen({super.key, required this.clienteId, required this.correo});

  @override
  QRGenerationScreenState createState() => QRGenerationScreenState();
}

class QRGenerationScreenState extends State<QRGenerationScreen> {
  final GlobalKey globalKeyQR1 = GlobalKey();
  final GlobalKey globalKeyQR2 = GlobalKey();
  bool _isLoading = true;
  final Logger _logger = Logger(); // Instancia de Logger

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _generateAndSendQRs());
  }

  Future<void> _generateAndSendQRs() async {
    try {
      // Retraso para permitir que los widgets se dibujen antes de capturarlos
      await Future.delayed(const Duration(milliseconds: 500));

      final qr1Image = await _renderQrAsImage(globalKeyQR1);
      final qr2Image = await _renderQrAsImage(globalKeyQR2);

      if (!mounted) return;

      // Generar y almacenar los códigos QR en Firestore
      String qrCode1 = "${widget.clienteId}_1";
      String qrCode2 = "${widget.clienteId}_2";

      await FirebaseFirestore.instance.collection('qr_codes').doc(qrCode1).set({
        'isValid': true,
      });

      await FirebaseFirestore.instance.collection('qr_codes').doc(qrCode2).set({
        'isValid': true,
      });

      // Enviar correo al cliente con las imágenes de los códigos QR
      final correoService = CorreoService();
      await correoService.enviarCorreoConImagenes(
        destinatario: widget.correo,
        nombre: 'Cliente', // Puedes ajustar esto según sea necesario
        qr1Image: qr1Image,
        qr2Image: qr2Image,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Códigos QR generados y enviados correctamente.')),
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      _logger.e('Error al generar los QR: $e'); // Usar Logger en lugar de print
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar los QR: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Uint8List> _renderQrAsImage(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary? boundary =
          globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("RenderRepaintBoundary no encontrado");
      }

      // Asegurar que el widget ha sido pintado completamente antes de capturarlo
      await Future.delayed(const Duration(milliseconds: 200));

      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      throw Exception("Error al renderizar el QR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String qr1Data = "${widget.clienteId}_1";
    final String qr2Data = "${widget.clienteId}_2";

    return Scaffold(
      appBar: AppBar(title: const Text('Generando QR...')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    key: globalKeyQR1,
                    child: Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: qr1Data,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RepaintBoundary(
                    key: globalKeyQR2,
                    child: Container(
                      color: Colors.white,
                      child: QrImageView(
                        data: qr2Data,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Capa de carga
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(1), // Fondo semi-transparente
                child: const Center(
                  child: CircularProgressIndicator(), // Icono de carga
                ),
              ),
            ),
        ],
      ),
    );
  }
}
