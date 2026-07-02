// domain/repositories/auth_repository.dart
import 'dart:io';
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

  /// Re-establishes a fresh login session. Required before [deleteAccount]
  /// so Firebase doesn't reject the deletion with `requires-recent-login`.
  Future<void> reauthenticate({required String password});

  /// Uploads [photo] to Storage and saves its URL on the user's profile.
  /// Returns the new photo URL.
  Future<String> updateProfilePhoto({
    required String userId,
    required File photo,
  });

  /// Deletes all Firestore data then removes the Firebase Auth account.
  Future<void> deleteAccount({required String userId});
}