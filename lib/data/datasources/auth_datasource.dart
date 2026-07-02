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

  /// Re-establishes a fresh login session using the user's password.
  /// Required before sensitive operations (like account deletion) that
  /// Firebase rejects with `requires-recent-login` on a stale session.
  Future<void> reauthenticateWithPassword(String password) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw firebase_auth.FirebaseAuthException(
        code: 'no-current-user',
        message: 'No signed-in user to reauthenticate.',
      );
    }
    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  /// Permanently deletes the Firebase Auth account.
  /// Must be called AFTER Firestore data is deleted so the user is still
  /// authenticated during the Firestore writes, and after a fresh
  /// reauthentication so it doesn't fail with `requires-recent-login`.
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