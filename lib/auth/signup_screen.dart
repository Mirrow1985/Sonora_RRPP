// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_firebase/auth/politica_de_seguridad.dart';
import 'package:auth_firebase/auth/condiciones_de_uso.dart'; // Importa la nueva pantalla
import 'package:flutter/gestures.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _obscureText = true;
  bool _acceptNotifications = true;
  bool _acceptTermsAndAge = false;
  bool _showPasswordRequirements = false;
  bool _isPasswordValid = false;
  String? _selectedMonth;
  String? _selectedDay;

  final List<String> _months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  List<String> _days = List.generate(31, (index) => (index + 1).toString());

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordRequirements = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _passwordFocusNode.dispose();
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

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _acceptTermsAndAge) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance.collection('Usuarios').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'email': _emailController.text,
          'birthday': _selectedMonth != null && _selectedDay != null ? '$_selectedDay $_selectedMonth' : null,
          'acceptNotifications': _acceptNotifications,
          'acceptTermsAndAge': _acceptTermsAndAge,
        });

        // Navegar a la pantalla principal o mostrar un mensaje de éxito
        Navigator.pushReplacementNamed(context, '/main');
      } catch (e) {
        // Manejar errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during registration: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar las condiciones de uso y ser mayor de 18 años')),
      );
    }
  }

  void _updateDays(String? month) {
    if (month == null) return;

    int daysInMonth;
    switch (month) {
      case 'Febrero':
        daysInMonth = 28; // No consideramos años bisiestos aquí
        break;
      case 'Abril':
      case 'Junio':
      case 'Septiembre':
      case 'Noviembre':
        daysInMonth = 30;
        break;
      default:
        daysInMonth = 31;
    }

    setState(() {
      _days = List.generate(daysInMonth, (index) => (index + 1).toString());
      if (int.tryParse(_selectedDay ?? '0')! > daysInMonth) {
        _selectedDay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Inscríbete',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Datos personales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'Primer Apellido',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      onChanged: (value) {
                        _validatePassword(value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
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
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cumpleaños',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Añade tu cumpleaños para que podamos felicitarte y regalarte un vale en tu día.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMonth,
                        decoration: InputDecoration(
                          labelText: 'Mes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        items: _months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMonth = newValue;
                            _updateDays(newValue);
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona un mes';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDay,
                        decoration: InputDecoration(
                          labelText: 'Día',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        items: _days.map((String day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedDay = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor selecciona un día';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Siempre preparado para rockear',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Mantente al tanto. El e-mail es una gran forma de estar al día de las ofertas y novedades [...]',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Text(
                        'Sí, quiero recibir información sobre ofertas y novedades exclusivas de La Cuneta Rock',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Switch(
                      value: _acceptNotifications,
                      onChanged: (bool value) {
                        setState(() {
                          _acceptNotifications = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Puedes anular tu suscripción en cualquier momento. Por favor, consulta nuestra ',
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Declaración de privacidad.',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                            );
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Condiciones de uso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Text(
                        'Acepto las condiciones de uso y la Declaración de Privacidad y declaro que soy mayor de 18 años',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Switch(
                      value: _acceptTermsAndAge,
                      onChanged: (bool value) {
                        setState(() {
                          _acceptTermsAndAge = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CondicionesDeUsoScreen()),
                    );
                  },
                  child: const Text(
                    'Condiciones de uso',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Declaración de Privacidad',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Por favor, consulta nuestra Declaración de Privacidad para obtener más información sobre el uso que hacemos de tus datos.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                    );
                  },
                  child: const Text(
                    'Declaración de privacidad',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.green, // Cambia el color según tu preferencia
                  ),
                  onPressed: _register,
                  child: const Text(
                    'Únete al programa de Rewards',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement("Entre 8 y 25 caracteres", _passwordController.text.length >= 8 && _passwordController.text.length <= 25),
        _buildRequirement("Al menos un número", _passwordController.text.contains(RegExp(r'\d'))),
        _buildRequirement("Al menos una letra mayúscula", _passwordController.text.contains(RegExp(r'[A-Z]'))),
        _buildRequirement("Al menos una letra minúscula", _passwordController.text.contains(RegExp(r'[a-z]'))),
        _buildRequirement("Al menos un carácter especial", _passwordController.text.contains(RegExp(r'[@$!%*?&]'))),
        _buildRequirement("Sin espacios, tabulación ni saltos de línea", !_passwordController.text.contains(RegExp(r'\s'))),
        _buildRequirement("Al menos un carácter especial permitido (!@# etc.)", _passwordController.text.contains(RegExp(r'[\W_]'))),
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
