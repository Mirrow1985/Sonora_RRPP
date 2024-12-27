import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:auth_firebase/widgets/button.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_firebase/auth/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final FocusNode _newPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  bool _currentPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _showPasswordRequirements = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _newPasswordFocusNode.addListener(() {
      setState(() {
        _showPasswordRequirements = _newPasswordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,25}$'
    );
    setState(() {
      _isPasswordValid = passwordRegex.hasMatch(password);
    });
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.changePassword(_currentPasswordController.text, _newPasswordController.text);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Cambio de Contraseña"),
              content: const Text("Tu contraseña ha sido cambiada exitosamente. Por favor, inicia sesión nuevamente."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        log("Error: $e");
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cambiar contraseña'), // Usar el widget reutilizable
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Se cerrará la sesión al cambiar la contraseña y se requerirá que vuelvas a iniciar sesión en la aplicación.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: !_currentPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Contraseña Actual",
                    hintText: "Introduce tu contraseña actual",
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _currentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentPasswordVisible = !_currentPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña actual';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  focusNode: _newPasswordFocusNode,
                  obscureText: !_newPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Nueva Contraseña",
                    hintText: "Introduce tu nueva contraseña",
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _validatePassword(value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nueva contraseña';
                    }
                    if (!_isPasswordValid) {
                      return 'La contraseña no cumple con los requisitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: _showPasswordRequirements,
                  child: _buildPasswordRequirements(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity, // Hacer que el botón ocupe todo el ancho disponible
                child: CustomButton(
                  label: "Cambiar Contraseña",
                  onPressed: _changePassword,
                ),
              ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement("Entre 8 y 25 caracteres", _newPasswordController.text.length >= 8 && _newPasswordController.text.length <= 25),
        _buildRequirement("Al menos un número", _newPasswordController.text.contains(RegExp(r'\d'))),
        _buildRequirement("Al menos una letra mayúscula", _newPasswordController.text.contains(RegExp(r'[A-Z]'))),
        _buildRequirement("Al menos una letra minúscula", _newPasswordController.text.contains(RegExp(r'[a-z]'))),
        _buildRequirement("Al menos un carácter especial", _newPasswordController.text.contains(RegExp(r'[@$!%*?&]'))),
        _buildRequirement("Sin espacios, tabulación ni saltos de línea", !_newPasswordController.text.contains(RegExp(r'\s'))),
        _buildRequirement("Al menos un carácter especial permitido (!@# etc.)", _newPasswordController.text.contains(RegExp(r'[\W_]'))),
      ],
    );
  }

  Widget _buildRequirement(String requirement, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check : Icons.close,
          color: met ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 5),
        Text(requirement),
      ],
    );
  }
}

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      // Reautenticar al usuario
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Cambiar la contraseña
      await user.updatePassword(newPassword);
    }
  }

  // Otros métodos de autenticación...
}