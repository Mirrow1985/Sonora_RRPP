import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _newPasswordVisible = false;
  bool _isPasswordValid = false;

  void _validatePassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,25}$'
    );
    setState(() {
      _isPasswordValid = passwordRegex.hasMatch(password);
    });
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.isEmpty || !_isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La contraseña no cumple con los requisitos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(_newPasswordController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Contraseña actualizada correctamente')),
          );
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
      appBar: AppBar(
        title: const Text('Cambiar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _newPasswordController,
              obscureText: !_newPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                hintText: 'Introduce tu nueva contraseña',
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
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: true,
              child: _buildPasswordRequirements(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _changePassword,
                    child: const Text('Cambiar Contraseña'),
                  ),
          ],
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