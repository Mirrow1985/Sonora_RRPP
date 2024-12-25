import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart'; // Importar el paquete logger
import 'personal_data_screen.dart';
import 'change_password_screen.dart';
import 'payment_methods_screen.dart';
import 'email_preferences_screen.dart';
import 'orders_screen.dart';
import 'help_screen.dart';
import 'terms_screen.dart';
import 'delete_account_screen.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class SettingsScreen extends StatefulWidget {
  final String userName;
  final String userSurname;

  const SettingsScreen({super.key, required this.userName, required this.userSurname});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final Logger logger = Logger(); // Crear una instancia de Logger
  bool canCheckBiometrics = false;
  bool isBiometricEnabled = false;
  bool isPushNotificationsEnabled = true; // Activado por defecto

  @override
  void initState() {
    super.initState();
    checkBiometrics();
  }

  Future<void> checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    setState(() {
      this.canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to enable biometric unlock',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } catch (e, stackTrace) {
      logger.e('Error during authentication', error: e, stackTrace: stackTrace); // Usar logger correctamente
    }
    setState(() {
      isBiometricEnabled = authenticated;
    });
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notificaciones Push'),
          content: const Text('¿Deseas activar las notificaciones push?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                setState(() {
                  isPushNotificationsEnabled = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                setState(() {
                  isPushNotificationsEnabled = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Ajustes'), // Usar el widget reutilizable
      body: SingleChildScrollView( // Envolver el contenido en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.userName} ${widget.userSurname}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'user@example.com',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cuenta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Datos personales'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalDataScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Cambiar contraseña'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Métodos de pago'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Preferencias de email'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailPreferencesScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Pedidos realizados'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OrdersScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Seguridad',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Desbloqueo biométrico', // Texto sin negrita y con acento
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: isBiometricEnabled,
                      onChanged: (bool value) async {
                        if (value) {
                          await authenticate();
                        } else {
                          setState(() {
                            isBiometricEnabled = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Preferencias de notificación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mensajes recibidos',
                      style: TextStyle(fontSize: 16),
                    ),
                    Switch(
                      value: isPushNotificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          isPushNotificationsEnabled = value;
                        });
                        if (value) {
                          _showNotificationDialog();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ayuda y Políticas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Ayuda'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Condiciones de uso'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermsScreen()),
                  );
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Eliminar cuenta'),
                    Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft, // Alinear el botón a la izquierda
                child: OutlinedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    side: const BorderSide(color: Colors.red),
                    backgroundColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Espacio entre el botón y el texto
              Center(
                child: Text(
                  '© 2025 La Cuneta Rock',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}