// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart'; // Importa el FirestoreService

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService(); // Instancia de FirestoreService

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
    String name, // Incluye el nombre como parámetro
  ) async {
    try {
      // Crea el usuario en Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Agrega el usuario a Firestore
      await _firestoreService.createUser(
        userCredential.user!.uid,
        name,
        email,
      );

      print("Usuario creado exitosamente.");
      return userCredential;
    } catch (e) {
      print("Error al crear usuario: $e");
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      await _firebaseAuth.signOut();
    }
  }

  Future<void> deleteAccount(String password) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      await user.delete();
    }
  }
}
