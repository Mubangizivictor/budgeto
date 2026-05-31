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
  }) : _authDataSource = authDataSource,
        _firestoreDataSource = firestoreDataSource;

  @override
  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      final result = await _authDataSource.signUp(
        email: email,
        password: password,
      );

      // Write the display name to Firebase Auth so getCurrentUser()
      // can return it without a Firestore round-trip.
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

      // Prefer the Firestore record (has fullName, totalBalance, createdAt).
      final user = await _firestoreDataSource.getUser(result.user!.uid);
      return user?.toEntity();
    } catch (e) {
      throw Exception('Sign in failed: $e');
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
      // displayName is now reliably set at sign-up.
      fullName: firebaseUser.displayName ?? '',
      createdAt: DateTime.now(),
      totalBalance: 0,
    );
  }

  @override
  bool isLoggedIn() {
    return _authDataSource.isLoggedIn();
  }
}