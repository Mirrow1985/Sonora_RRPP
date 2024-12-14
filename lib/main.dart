import 'package:auth_firebase/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

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
      home: const MainScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
