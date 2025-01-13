import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> createUser(String userId, String name, String email) async {
    final userRef = _firestore.collection('users').doc(userId);

    try {
      await userRef.set({
        'name': name,
        'email': email,
        'points': 0,
        'transactions': [],
      });
      _logger.i("Usuario creado exitosamente en Firestore.");
    } catch (e) {
      _logger.e("Error al crear usuario en Firestore: $e");
    }
  }

  Future<void> addTransaction(String userId, double amountSpent) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      int pointsEarned = (amountSpent * 100).toInt();

      await userRef.update({
        'points': FieldValue.increment(pointsEarned),
        'transactions': FieldValue.arrayUnion([
          {
            'date': DateTime.now().toIso8601String(),
            'amount': amountSpent,
            'pointsEarned': pointsEarned,
          }
        ]),
      });

      _logger.i("Transacción añadida correctamente.");
    } catch (e) {
      _logger.e("Error al añadir transacción: $e");
    }
  }

  Future<int> getUserPoints(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['points'];
      } else {
        _logger.w("Usuario no encontrado en Firestore.");
        return 0;
      }
    } catch (e) {
      _logger.e("Error al obtener puntos del usuario: $e");
      return 0;
    }
  }
}
