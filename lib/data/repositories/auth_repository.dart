// domain/repositories/auth_repository.dart (Interface)
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> signUp(String email, String password, String fullName);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
  bool isLoggedIn();
}