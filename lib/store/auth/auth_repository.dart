import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authState => _auth.authStateChanges();

  Future<User?> signup(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      return _auth.currentUser;
    } catch (e, stackTrace) {
      debugPrint('❌ Signup error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user?.reload();
      return _auth.currentUser;
    } catch (e, stackTrace) {
      debugPrint('❌ Login error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrintStack(label: 'Error during logout: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}
