import 'package:auth_firebase/auth/login_screen.dart';
import 'package:auth_firebase/auth/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auth_firebase/screens/main_screen.dart';

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
        appId: "1:312939314449:web:8b366ed29f2ad56a8620b0"
      )
    );
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
      home: const WelcomeScreen(), // Asegúrate de que WelcomeScreen sea la pantalla principal
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png', // Asegúrate de tener el logo en la carpeta assets
                  height: 80,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'LA CUNETA ROCK',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1, // Ajusta la altura de la línea para juntar más los textos
                      ),
                    ),
                    Text(
                      'RECOMPENSAS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1, // Ajusta la altura de la línea para juntar más los textos
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Bienvenido a nuestra aplicación de recompensas. Aquí puedes ganar puntos y canjearlos por increíbles premios. ¡Es fácil y divertido!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            const Spacer(flex: 20), // Ajustar el flex para reducir el espacio
            const Text(
              'Comenzar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2), // Ajusta el tamaño del espacio aquí
            Center(
              child: SizedBox(
                width: 300, // Ajusta el ancho según tu preferencia
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Ajusta el padding para hacer el botón más corto verticalmente y más ancho horizontalmente
                    backgroundColor: Colors.blue, // Cambia el color según tu preferencia
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(
                    'Regístrate ahora',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Ya tienes cuenta?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Center(
              child: SizedBox(
                width: 300, // Ajusta el ancho según tu preferencia
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Ajusta el padding para hacer el botón más corto verticalmente y más ancho horizontalmente
                    side: const BorderSide(color: Colors.blue), // Cambia el color del borde según tu preferencia
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Iniciar sesión',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.blue), // Cambia el color del texto según tu preferencia
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Añadir un espacio al final
          ],
        ),
      ),
    );
  }
}