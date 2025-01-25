import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screen/principal_screen.dart';
import 'screen/scanner_screen.dart';
import 'screen/registro_screen.dart';
import 'screen/qr_generation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonora RRPP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PrincipalScreen(),
        '/scanner': (context) => QRScannerScreen(),
        '/registro': (context) => RegistroScreen(universidad: 'Facultad de Ciencias', promocion: '2023'),
        '/qr_generation': (context) => QRGenerationScreen(clienteId: '123', correo: 'test@example.com'),
      },
    );
  }
}

class RegistroScreen extends StatefulWidget {
  final String universidad;
  final String promocion;

  const RegistroScreen({super.key, required this.universidad, required this.promocion});

  @override
  RegistroScreenState createState() => RegistroScreenState();
}

class RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedFacultad;

  final List<String> facultades = [
    'Facultad de Ciencias',
    'Ingeniería de Caminos',
    'Ingeniería de la Edificación',
    'Otra Facultad'
  ];

  @override
  void initState() {
    super.initState();
    selectedFacultad = widget.universidad;
    nombreController.addListener(_capitalizeFirstLetter);
  }

  @override
  void dispose() {
    nombreController.removeListener(_capitalizeFirstLetter);
    nombreController.dispose();
    super.dispose();
  }

  void _capitalizeFirstLetter() {
    String text = nombreController.text;
    if (text.isNotEmpty && text[0] != text[0].toUpperCase()) {
      nombreController.value = nombreController.value.copyWith(
        text: text[0].toUpperCase() + text.substring(1),
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  Future<void> registrarCliente() async {
    final String nombre = nombreController.text;
    final String correo = correoController.text;

    if (nombre.isEmpty || selectedDay == null || selectedMonth == null || selectedYear == null || correo.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    final String fechaNacimiento = '$selectedDay/$selectedMonth/$selectedYear';

    // Verificar si el correo ya existe
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('clientes')
        .where('correo', isEqualTo: correo)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    if (documents.isNotEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El correo ya está registrado.')),
      );
      return;
    }

    // Registrar el cliente en Firestore
    final DocumentReference clienteRef = await FirebaseFirestore.instance.collection('clientes').add({
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento,
      'correo': correo,
      'universidad': selectedFacultad,
      'promocion': widget.promocion,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    // Navegar a la pantalla de generación de QR
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRGenerationScreen(clienteId: clienteRef.id, correo: correo),
      ),
    ).then((_) {
      // Restablecer los campos después de regresar de la pantalla de generación de QR
      nombreController.clear();
      correoController.clear();
      setState(() {
        selectedDay = null;
        selectedMonth = null;
        selectedYear = null;
        selectedFacultad = widget.universidad;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro - ${widget.universidad}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Promoción seleccionada: ${widget.promocion}'),
            SizedBox(height: 20),
            Text('Facultad seleccionada:'),
            DropdownButton<String>(
              value: selectedFacultad,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFacultad = newValue;
                });
              },
              items: facultades.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              child: TextField(
                controller: nombreController,
                decoration: InputDecoration.collapsed(hintText: null),
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    hint: Text('Día'),
                    value: selectedDay,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue;
                      });
                    },
                    items: List.generate(31, (index) {
                      final day = (index + 1).toString().padLeft(2, '0');
                      return DropdownMenuItem<String>(
                        value: day,
                        child: Text(day),
                      );
                    }),
                  ),
                  DropdownButton<String>(
                    hint: Text('Mes'),
                    value: selectedMonth,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue;
                      });
                    },
                    items: List.generate(12, (index) {
                      final month = (index + 1).toString().padLeft(2, '0');
                      return DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      );
                    }),
                  ),
                  DropdownButton<String>(
                    hint: Text('Año'),
                    value: selectedYear,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue;
                      });
                    },
                    items: List.generate(100, (index) {
                      final year = (DateTime.now().year - index).toString();
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Text(year),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              child: TextField(
                controller: correoController,
                decoration: InputDecoration.collapsed(hintText: null),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registrarCliente,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
