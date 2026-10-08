
// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    FirebaseAuth.instance,
  );
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _handleAuthException(error),
      );
    }
  }

  Future<UserCredential?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw Exception(
        _handleAuthException(error),
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _handleAuthException(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'user-not-found':
        return 'Akaunti haijapatikana.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Barua pepe au nenosiri sio sahihi.';

      case 'email-already-in-use':
        return 'Barua pepe hii imeshatumika.';

      case 'invalid-email':
        return 'Barua pepe si sahihi.';

      case 'weak-password':
        return 'Nenosiri ni dhaifu. Tumia angalau herufi 6.';

      case 'user-disabled':
        return 'Akaunti hii imezuiwa.';

      case 'too-many-requests':
        return 'Maombi yamekuwa mengi. Jaribu tena baadaye.';

      case 'network-request-failed':
        return 'Hakuna muunganisho mzuri wa intaneti.';

      case 'operation-not-allowed':
        return 'Njia hii ya kuingia haijawezeshwa kwenye Firebase.';

      default:
        return error.message ??
            'Kuna tatizo limetokea. Tafadhali jaribu tena.';
    }
  }
}
