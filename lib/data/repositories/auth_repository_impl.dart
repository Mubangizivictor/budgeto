// data/repositories/auth_repository_impl.dart
import 'dart:io';
import '../../core/local_storage/hive_service.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/firestore_datasource.dart';
import '../datasources/storage_datasource.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final FirestoreDataSource _firestoreDataSource;
  final StorageDataSource _storageDataSource;

  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required FirestoreDataSource firestoreDataSource,
    required StorageDataSource storageDataSource,
  })  : _authDataSource = authDataSource,
        _firestoreDataSource = firestoreDataSource,
        _storageDataSource = storageDataSource;

  @override
  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      final result = await _authDataSource.signUp(
        email: email,
        password: password,
      );
      
      // Update the name on the Firebase Auth user immediately
      await result.user?.updateDisplayName(fullName);
      
      final user = UserModel(
        id: result.user!.uid,
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
      );
      
      // Save to firestore
      await _firestoreDataSource.saveUser(user);
      
      // Return the entity with the name already populated
      return user.toEntity();
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await _authDataSource.signIn(
        email: email,
        password: password,
      );
      final user = await _firestoreDataSource.getUser(result.user!.uid);
      return user?.toEntity();
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _authDataSource.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  User? getCurrentUser() {
    final firebaseUser = _authDataSource.getCurrentUser();
    if (firebaseUser == null) return null;
    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      fullName: firebaseUser.displayName ?? '',
      createdAt: DateTime.now(),
      totalBalance: 0,
    );
  }

  @override
  bool isLoggedIn() => _authDataSource.isLoggedIn();

  @override
  Future<User?> getCurrentUserFromFirestore() async {
    final firebaseUser = _authDataSource.getCurrentUser();
    if (firebaseUser == null) return null;
    final user = await _firestoreDataSource.getUser(firebaseUser.uid);
    return user?.toEntity();
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required String fullName,
  }) async {
    try {
      final firebaseUser = _authDataSource.getCurrentUser();
      await firebaseUser?.updateDisplayName(fullName);
      await _firestoreDataSource.updateUserFullName(userId, fullName);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<String> updateProfilePhoto({
    required String userId,
    required File photo,
  }) async {
    try {
      final photoUrl =
          await _storageDataSource.uploadProfilePhoto(userId, photo);
      await _firestoreDataSource.updateUserPhotoUrl(userId, photoUrl);
      return photoUrl;
    } catch (e) {
      throw Exception('Failed to update profile photo: $e');
    }
  }

  @override
  Future<void> reauthenticate({required String password}) async {
    try {
      await _authDataSource.reauthenticateWithPassword(password);
    } catch (e) {
      throw Exception('Reauthentication failed: $e');
    }
  }

  /// Order matters: delete Firestore data first while the user is still
  /// authenticated (security rules require auth), then delete the Auth
  /// account. Finally, clear local Hive storage.
  ///
  /// Callers must invoke [reauthenticate] with a fresh session immediately
  /// before this so the Auth deletion step doesn't fail with
  /// `requires-recent-login` after the Firestore data is already gone.
  @override
  Future<void> deleteAccount({required String userId}) async {
    try {
      // 1. Delete remote data
      await _firestoreDataSource.deleteAllUserData(userId);
      
      // 2. Delete Auth account
      await _authDataSource.deleteAccount();

      // 3. Clear local cache to ensure no data leak for the next user
      await HiveService.clearBox(HiveService.expenseBox);
      await HiveService.clearBox(HiveService.incomeBox);
      await HiveService.clearBox(HiveService.notificationBox);
      await HiveService.clearBox(HiveService.settingsBox);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}