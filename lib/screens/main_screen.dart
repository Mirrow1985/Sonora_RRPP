import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pay_screen.dart';
import 'events_screen.dart';
import 'rewards_screen.dart';
import 'settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = 'User';
  String userSurname = 'User';

  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(),  // Contenido de la pantalla de inicio
    PayScreen(),
    EventsScreen(),
    RewardsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Usuarios').doc(user!.uid).get();
      setState(() {
        userName = capitalize(userDoc['name'] ?? 'User');
        userSurname = capitalize(userDoc['surname'] ?? 'User');
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String capitalize(String s) {
    if (s.isEmpty) {
      return 'User';
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false, // Eliminar el botón de ir hacia atrás
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Bienvenido, $userName!',
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.mail),
                    onPressed: () {
                      // Acción para el buzón
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen(userName: userName, userSurname: userSurname)),
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Pagar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 14),  // Aumentar el tamaño del texto
        unselectedLabelStyle: const TextStyle(fontSize: 14, color: Colors.grey),  // Aumentar el tamaño del texto
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,  // Asegurar que las etiquetas siempre se muestren
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contenido de la pantalla de inicio'),
    );
  }
}