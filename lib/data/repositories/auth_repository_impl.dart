// data/repositories/auth_repository_impl.dart
import '../../domain/entities/user.dart';
import '../datasources/auth_datasource.dart';
import '../datasources/firestore_datasource.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final FirestoreDataSource _firestoreDataSource;

  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required FirestoreDataSource firestoreDataSource,
  })  : _authDataSource = authDataSource,
        _firestoreDataSource = firestoreDataSource;

  @override
  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      final result = await _authDataSource.signUp(
        email: email,
        password: password,
      );
      await result.user?.updateDisplayName(fullName);
      final user = UserModel(
        id: result.user!.uid,
        email: email,
        fullName: fullName,
        createdAt: DateTime.now(),
      );
      await _firestoreDataSource.saveUser(user);
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

  /// Order matters: delete Firestore data first while the user is still
  /// authenticated (security rules require auth), then delete the Auth
  /// account. If Auth deletion fails the data is already gone, which is
  /// acceptable. If Firestore deletion fails we throw before touching Auth.
  @override
  Future<void> deleteAccount({required String userId}) async {
    try {
      await _firestoreDataSource.deleteAllUserData(userId);
      await _authDataSource.deleteAccount();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}