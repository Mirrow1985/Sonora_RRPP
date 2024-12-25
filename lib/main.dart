import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'screens/welcome_screen.dart';
import 'auth/signup_screen.dart'; // Asegúrate de que esta importación sea correcta
import 'screens/main_screen.dart';
import 'auth/login_screen.dart'; // Asegúrate de que esta importación sea correcta
import 'auth/forgot_password_screen.dart'; // Importa la pantalla de restablecimiento de contraseña

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDvFXkxA60L0PFFH37zM3uhmvmRI1Gbkn8",
            authDomain: "authfirebase-73e37.firebaseapp.com",
            projectId: "authfirebase-73e37",
            storageBucket: "authfirebase-73e37.appspot.com",
            messagingSenderId: "312939314449",
            appId: "1:312939314449:web:8b366ed29f2ad56a8620b0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(), // Asegúrate de que esta sea la pantalla inicial correcta
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(), // Asegúrate de que esta ruta sea correcta
        '/main': (context) => const MainScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(), // Agrega la ruta para restablecer contraseña
      },
    );
  }
}
