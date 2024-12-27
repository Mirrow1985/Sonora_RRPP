import 'dart:developer';
import 'package:auth_firebase/auth/signup_screen.dart'; // Importar SignupScreen
import 'package:auth_firebase/auth/forgot_password_screen.dart';
import 'package:auth_firebase/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance; // Usar FirebaseAuth directamente
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu correo electrónico y contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor verifica tu correo electrónico')),
          );
        }
        return;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      log("Error: $e");
      String errorMessage;
      if (e.toString().contains('firebase_auth/email-already-in-use')) {
        errorMessage = 'La dirección de correo electrónico ya está en uso por otra cuenta.';
      } else if (e.toString().contains('firebase_auth/invalid-email')) {
        errorMessage = 'La dirección de correo electrónico no es válida.';
      } else if (e.toString().contains('firebase_auth/user-not-found')) {
        errorMessage = 'No se encontró ningún usuario con ese correo electrónico.';
      } else if (e.toString().contains('firebase_auth/wrong-password')) {
        errorMessage = 'Contraseña incorrecta proporcionada para ese usuario.';
      } else {
        errorMessage = 'Ocurrió un error desconocido.';
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Iniciar sesión'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _password,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Introduce tu contraseña',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Iniciar sesión'),
                    ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen()),
                  );
                },
                child: const Text('¿No tienes cuenta? Crear una cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}