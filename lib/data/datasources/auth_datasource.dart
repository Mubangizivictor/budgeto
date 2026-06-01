// data/datasources/auth_datasource.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthDataSource {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<firebase_auth.UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<firebase_auth.UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Permanently deletes the Firebase Auth account.
  /// Must be called AFTER Firestore data is deleted so the user is still
  /// authenticated during the Firestore writes.
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  firebase_auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}