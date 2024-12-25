import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:auth_firebase/widgets/custom_app_bar.dart'; // Importa el widget reutilizable

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  @override
  PersonalDataScreenState createState() => PersonalDataScreenState();
}

class PersonalDataScreenState extends State<PersonalDataScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final Logger logger = Logger(); // Crear una instancia de Logger
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(user!.uid).get();
        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>?;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          logger.w('User document does not exist');
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Usar logger para manejar el error
      logger.e('Error fetching user data', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Datos personales'), // Usar el widget reutilizable
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('No se encontraron datos del usuario.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildUserInfoTile('Nombre', userData!['name'] ?? 'N/A'),
                      buildUserInfoTile('Apellido', userData!['surname'] ?? 'N/A'),
                      buildUserInfoTile('Email', userData!['email'] ?? user?.email ?? 'N/A'),
                      buildUserInfoTile('Cumpleaños', userData!['birthday'] ?? 'N/A'),
                      // Agrega más campos según sea necesario
                    ],
                  ),
                ),
    );
  }

  Widget buildUserInfoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          height: 1.0,
          color: Colors.grey, // Cambiar a un tono gris sin degradado
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}