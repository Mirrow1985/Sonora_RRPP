// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> sendEmailVerificationLink() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
      // Reautenticar al usuario
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Cambiar la contraseña
      await user.updatePassword(newPassword);

      // Hacer sign out del usuario
      await _firebaseAuth.signOut();
    }
  }

  Future<void> deleteAccount(String password) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      // Reautenticar al usuario
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // Eliminar la cuenta
      await user.delete();
    }
  }
}
