import 'dart:io';
import 'dart:typed_data';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class CorreoService {
  final String email = "sonoradesertsaloon@gmail.com"; // Reemplaza con tu correo de Gmail
  final String password = "yzgp vsty pvny awer"; // Reemplaza con tu clave de aplicación
  final Logger _logger = Logger();

  Future<void> enviarCorreoConImagenes({
    required String destinatario,
    required String nombre,
    required Uint8List qr1Image,
    required Uint8List qr2Image,
  }) async {
    // Configuración del servidor SMTP
    final smtpServer = gmail(email, password);

    // Crear archivos temporales para las imágenes QR
    final tempDir = await getTemporaryDirectory();
    final qr1File = await File('${tempDir.path}/qr1.png').writeAsBytes(qr1Image);
    final qr2File = await File('${tempDir.path}/qr2.png').writeAsBytes(qr2Image);

    // Mensaje del correo
    final mensaje = Message()
      ..from = Address(email, "Sonora RRPP") // Nombre del remitente
      ..recipients.add(destinatario) // Destinatario
      ..subject = "¡Tus Flyers para Cervezas Gratis!" // Asunto
      ..html = '''
        <h1>Hola $nombre,</h1>
        <p>Aquí tienes tus códigos QR para canjear tus cervezas:</p>
        <p><strong>QR 1:</strong> <img src="cid:qr1"></p>
        <p><strong>QR 2:</strong> <img src="cid:qr2"></p>
        <p>¡Disfruta!</p>
      '''
      ..attachments = [
        FileAttachment(qr1File)..location = Location.inline..cid = 'qr1',
        FileAttachment(qr2File)..location = Location.inline..cid = 'qr2',
      ];

    try {
      final sendReport = await send(mensaje, smtpServer);
      _logger.i('Correo enviado: $sendReport');
    } on MailerException catch (e) {
      _logger.e('Error al enviar el correo: $e');
      for (var p in e.problems) {
        _logger.e('Problema: ${p.code}: ${p.msg}');
      }
    }
  }
}