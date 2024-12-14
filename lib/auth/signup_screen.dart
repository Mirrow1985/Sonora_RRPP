// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:auth_firebase/auth/auth_service.dart';
import 'package:auth_firebase/auth/login_screen.dart';// Asegúrate de que esta línea esté presente
import 'package:auth_firebase/widgets/button.dart';
import 'package:auth_firebase/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa el paquete intl
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _dateController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // 18 años antes de la fecha actual
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _signup() async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        _email.text,
        _password.text,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await user.updateProfile(displayName: _name.text);
        await user.sendEmailVerification();
        log("Verification email sent");

        // Guardar información adicional en Firestore
        await FirebaseFirestore.instance.collection('Usuarios').doc(user.uid).set({
          'name': _name.text,
          'email': _email.text,
          'dateOfBirth': _dateController.text,
        });

        // Show a dialog to inform the user to check their email
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Verify your email"),
            content: const Text(
                "A verification link has been sent to your email. Please verify your email to continue."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  goToLogin(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        log("User credential is null");
      }
    } catch (e) {
      log("Error: $e");
      String errorMessage;
      if (e.toString().contains('firebase_auth/email-already-in-use')) {
        errorMessage = 'The email address is already in use by another account.';
      } else if (e.toString().contains('firebase_auth/invalid-email')) {
        errorMessage = 'The email address is not valid.';
      } else if (e.toString().contains('firebase_auth/weak-password')) {
        errorMessage = 'The password provided is too weak.';
      } else {
        errorMessage = 'An unknown error occurred.';
      }
      // Handle error (e.g., show a snackbar or dialog with the error message)
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              const Text("Signup",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                hint: "Enter Name",
                label: "Name",
                controller: _name,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Email",
                label: "Email",
                controller: _email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Password",
                label: "Password",
                isPassword: true,
                controller: _password,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              const Text(
                'Password must be at least 6 characters',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Select Date of Birthday",
                label: "Date of Birthday",
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birthday';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5),
              const Text(
                'Enter your correct date, you will have surprises for your day',
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: "Signup",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _signup();
                  }
                },
              ),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child: const Text("Login", style: TextStyle(color: Colors.red)),
                )
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

}