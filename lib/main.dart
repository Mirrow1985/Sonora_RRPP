import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importar firebase_auth
import 'screens/welcome_screen.dart';
import 'auth/signup_screen.dart';
import 'screens/main_screen.dart';
import 'auth/login_screen.dart';
import 'auth/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const AuthWrapper(), // Usar AuthWrapper para manejar la lógica de autenticación
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/welcome': (context) => const WelcomeScreen(), // Agregar la ruta para WelcomeScreen
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  AuthWrapperState createState() => AuthWrapperState();
}

class AuthWrapperState extends State<AuthWrapper> {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    bool isBiometricEnabled = await _isBiometricEnabled();
    bool isAuthenticated = false;

    if (isBiometricEnabled) {
      isAuthenticated = await _checkBiometricAuthentication();
    }

    if (!isAuthenticated) {
      isAuthenticated = await _checkStoredCredentials();
    }

    if (isAuthenticated) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    }
  }

  Future<bool> _isBiometricEnabled() async {
    String? useBiometrics = await storage.read(key: 'useBiometrics');
    return useBiometrics == 'true';
  }

  Future<bool> _checkBiometricAuthentication() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (canCheckBiometrics) {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      return isAuthenticated;
    }
    return false;
  }

  Future<bool> _checkStoredCredentials() async {
    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');

    if (email != null && password != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}