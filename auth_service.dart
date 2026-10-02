import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Hii inaruhusu app nzima kutumia huduma za AuthService bila kutengeneza upya kila mara
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  /// 1. KUTENGENEZA AKAUNTI MPYA (Sign Up)
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Kuna tatizo la mtandao. Tafadhali jaribu tena baadaye.';
    }
  }

  /// 2. KUINGIA KWENYE AKAUNTI (Sign In)
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Kuna tatizo la mtandao. Tafadhali jaribu tena baadaye.';
    }
  }

  /// 3. KUTAFSIRI MAKOSA (Errors) KUWA KISWAHILI
  /// Hii inasaidia mteja wa Soko Letu kuelewa nini amekosea
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Akaunti haijapatikana. Tafadhali hakikisha barua pepe ni sahihi.';
      case 'wrong-password':
        return 'Nenosiri sio sahihi. Tafadhali jaribu tena.';
      case 'invalid-credential':
        return 'Taarifa ulizoingiza sio sahihi.';
      case 'email-already-in-use':
        return 'Barua pepe hii imeshatumika na akaunti nyingine.';
      case 'invalid-email':
        return 'Mfumo wa barua pepe sio sahihi.';
      case 'weak-password':
        return 'Nenosiri ni dhaifu sana. Tumia angalau herufi 6.';
      case 'user-disabled':
        return 'Akaunti hii imefungiwa na uongozi.';
      case 'too-many-requests':
        return 'Umejaribu mara nyingi mno. Tafadhali subiri kidogo kisha ujaribu tena.';
      default:
        return 'Kosa limejitokeza: ${e.message}';
    }
  }
}
