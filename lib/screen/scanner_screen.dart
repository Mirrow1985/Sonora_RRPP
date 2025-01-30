import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'results_qr.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController cameraController = MobileScannerController();
  final Logger logger = Logger();
  StreamSubscription<BarcodeCapture>? _subscription;
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  void _startCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _subscription = cameraController.barcodes.listen((barcodeCapture) async {
        if (barcodeCapture.barcodes.isNotEmpty && isScanning) {
          final String code = barcodeCapture.barcodes.first.rawValue ?? '';
          logger.d('Código QR escaneado: $code');

          if (code.isNotEmpty) {
            setState(() {
              isScanning = false;
            });
            cameraController.stop();

            final String clienteId = _extractClienteId(code);
            logger.d('Cliente ID extraído: $clienteId');

            _validateAndHandleQRScan(code, clienteId);
          }
        }
      });
    }
  }

  Future<void> _validateAndHandleQRScan(String code, String clienteId) async {
    final userData = await _getUserData(clienteId);
    final isValid = await _isCodeValidAndNotRedeemed(code);

    if (!mounted) return;

    if (isValid && userData != null) {
      _handleScanResult(code, userData);
    } else {
      logger.d('Código no válido o ya canjeado.');
      if (mounted) {
        _showSnackbar('Código no válido o ya canjeado');
        setState(() {
          isScanning = true;
        });
        cameraController.start();
      }
    }
  }

  Future<bool> _isCodeValidAndNotRedeemed(String code) async {
    final doc = await FirebaseFirestore.instance.collection('historial_qrs').doc(code).get();
    return !doc.exists;
  }

  void _handleScanResult(String code, Map<String, String>? userData) {
    if (userData != null) {
      logger.d('Guardando en historial_qrs en Firestore...');
      FirebaseFirestore.instance.collection('historial_qrs').doc(code).set({
        'qrData': code,
        'nombre': userData['nombre'],
        'correo': userData['correo'],
        'promocion': userData['promocion'],
        'fechaEscaneo': FieldValue.serverTimestamp(),
      }).then((_) {
        if (mounted) {
          logger.d('Datos guardados con éxito en Firestore.');
          _navigateToResultsScreen(code);
        }
      }).catchError((e) {
        logger.e('Error al guardar en Firestore: $e');
      });
    } else {
      logger.d('Datos del cliente no encontrados.');
      if (mounted) {
        _showSnackbar('Datos del cliente no encontrados');
        setState(() {
          isScanning = true;
        });
        cameraController.start();
      }
    }
  }

  void _navigateToResultsScreen(String code) {
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsQRScreen(userId: code),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          isScanning = true;
        });
        cameraController.start();
      }
    });
  }

  void _showSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String _extractClienteId(String code) {
    final regex = RegExp(r'^(.*)_\d+$'); 
    final match = regex.firstMatch(code);
    return match != null ? match.group(1)! : code;
  }

  Future<Map<String, String>?> _getUserData(String clienteId) async {
    try {
      logger.d('Buscando en Firestore el cliente ID: $clienteId');

      final doc = await FirebaseFirestore.instance.collection('clientes').doc(clienteId).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        logger.d('Datos encontrados en Firestore: $data');

        if (data.containsKey('nombre') && data.containsKey('correo') && data.containsKey('promocion')) {
          return {
            'nombre': data['nombre'].toString(),
            'correo': data['correo'].toString(),
            'promocion': data['promocion'].toString(),
          };
        } else {
          logger.e('El documento existe pero le faltan campos requeridos.');
        }
      } else {
        logger.e('No se encontró el documento con ID: $clienteId');
      }
    } catch (e) {
      logger.e('Error al obtener datos del cliente: $e');
    }
    return null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      cameraController.stop();
    } else if (state == AppLifecycleState.resumed && isScanning) {
      cameraController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.camera_rear),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (barcodeCapture) {
          if (barcodeCapture.barcodes.isNotEmpty && isScanning) {
            final String code = barcodeCapture.barcodes.first.rawValue ?? '';
            logger.d('Código QR detectado: $code');

            if (code.isNotEmpty) {
              setState(() {
                isScanning = false;
              });
              cameraController.stop();

              final String clienteId = _extractClienteId(code);
              logger.d('Cliente ID extraído: $clienteId');

              _validateAndHandleQRScan(code, clienteId);
            }
          }
        },
      ),
    );
  }
}
