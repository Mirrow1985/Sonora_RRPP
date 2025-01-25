import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'results_qr.dart'; // Importa ResultsQRScreen

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> with WidgetsBindingObserver {
  final MobileScannerController cameraController = MobileScannerController();
  StreamSubscription<BarcodeCapture>? _subscription;
  bool isScanning = true; // Estado para saber si el escáner está activo

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startCamera();
  }

  void _startCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _subscription = cameraController.barcodes.listen((barcodeCapture) {
        if (barcodeCapture.barcodes.isNotEmpty && isScanning) {
          final String code = barcodeCapture.barcodes.first.rawValue ?? '';
          if (code.isNotEmpty) {
            setState(() {
              isScanning = false; // Detiene el escaneo
            });
            cameraController.stop(); // Apaga la cámara
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsQRScreen(userId: code),
                ),
              ).then((_) {
                // Reinicia la cámara al volver a esta pantalla
                if (mounted) {
                  setState(() {
                    isScanning = true;
                  });
                  cameraController.start();
                }
              });
            }
          }
        }
      });
    }
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
      cameraController.stop(); // Apaga la cámara cuando la app no está activa
    } else if (state == AppLifecycleState.resumed && isScanning) {
      cameraController.start(); // Enciende la cámara al volver, si se permite el escaneo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.camera_rear),
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
            if (code.isNotEmpty) {
              setState(() {
                isScanning = false; // Detiene el escaneo
              });
              cameraController.stop(); // Apaga la cámara
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsQRScreen(userId: code),
                  ),
                ).then((_) {
                  // Reinicia la cámara al volver a esta pantalla
                  if (mounted) {
                    setState(() {
                      isScanning = true;
                    });
                    cameraController.start();
                  }
                });
              }
            }
          }
        },
      ),
    );
  }
}
