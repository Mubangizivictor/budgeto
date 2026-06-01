// domain/repositories/auth_repository.dart
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> signUp(String email, String password, String fullName);
  Future<User?> signIn(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();

  User? getCurrentUser();
  bool isLoggedIn();

  Future<User?> getCurrentUserFromFirestore();
  Future<void> updateProfile({required String userId, required String fullName});

  /// Deletes all Firestore data then removes the Firebase Auth account.
  Future<void> deleteAccount({required String userId});
}