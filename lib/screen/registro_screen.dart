import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr_generation_screen.dart';
import 'historial_registro.dart'; // Importa HistorialRegistroScreen

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
  String? selectedPromocion;

  final List<String> facultades = [
    'Facultad de Ciencias',
    'Ingeniería de Caminos',
    'Ingeniería de la Edificación',
    'Otra Facultad'
  ];

  final List<String> promociones = [
    '¡Cumplimos 16 años!',
    'Promoción 2',
    'Promoción 3',
    'Otra Promoción'
  ];

  final Map<String, String> promocionImagenes = {
    '¡Cumplimos 16 años!': 'assets/images/promocion_universidad.png',
    'Promoción 2': 'assets/images/promocion_2.png',
    'Promoción 3': 'assets/images/promocion_3.png',
    'Otra Promoción': 'assets/images/otra_promocion.png',
  };

  @override
  void initState() {
    super.initState();
    selectedFacultad = widget.universidad;
    selectedPromocion = widget.promocion;
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

    if (nombre.isEmpty || selectedDay == null || selectedMonth == null || selectedYear == null || correo.isEmpty || selectedPromocion == null) {
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
      'promocion': selectedPromocion,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });

    // Guardar el registro en el historial
    await FirebaseFirestore.instance.collection('historial_registros').add({
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento,
      'correo': correo,
      'universidad': selectedFacultad,
      'promocion': selectedPromocion,
      'fechaRegistro': FieldValue.serverTimestamp(),
      'estadoEnvio': 'Enviado correctamente',
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
        selectedPromocion = widget.promocion;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;
    final List<String> years = List.generate(60 - 17 + 1, (index) => (currentYear - 17 - index).toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistorialRegistroScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Promoción seleccionada',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPromocion,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPromocion = newValue;
                    });
                  },
                  items: promociones.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Facultad seleccionada',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
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
              ),
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
                    items: years.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlyerScreen(imagePath: promocionImagenes[selectedPromocion] ?? 'assets/images/default.png'),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    promocionImagenes[selectedPromocion] ?? 'assets/images/default.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withAlpha(128), // Reemplaza withOpacity(0.5) con withAlpha(128)
                    alignment: Alignment.center,
                    child: Text(
                      'Toca para ampliar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlyerScreen extends StatelessWidget {
  final String imagePath;

  const FlyerScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flyer'),
      ),
      body: Center(
        child: Image.asset(imagePath),
      ),
    );
  }
}