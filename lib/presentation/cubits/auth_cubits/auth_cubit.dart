// presentation/cubits/auth_cubits/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial());

  Future<void> checkAuthStatus() async {
    if (!_authRepository.isLoggedIn()) {
      emit(AuthUnauthenticated());
      return;
    }
    try {
      final user = await _authRepository.getCurrentUserFromFirestore();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(email, password, fullName);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(email);
      emit(PasswordResetSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Updates fullName in Firebase Auth + Firestore, then emits
  /// [ProfileUpdated] (not [AuthAuthenticated]) so the EditProfileScreen
  /// listener only fires on an actual save — not on every auth state change.
  Future<void> updateProfile({required String fullName}) async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    emit(AuthLoading());
    try {
      await _authRepository.updateProfile(
        userId: current.user.id,
        fullName: fullName,
      );
      final updatedUser = User(
        id: current.user.id,
        email: current.user.email,
        fullName: fullName,
        createdAt: current.user.createdAt,
        totalBalance: current.user.totalBalance,
      );
      // Emit ProfileUpdated first so the screen can react to it,
      // then settle back to AuthAuthenticated for the rest of the app.
      emit(ProfileUpdated(updatedUser));
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      emit(current);
      emit(AuthError(e.toString()));
    }
  }

  /// Deletes all Firestore data then removes the Firebase Auth account.
  /// Emits [AccountDeleted] on success so the app can navigate to login.
  Future<void> deleteAccount() async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    emit(AuthLoading());
    try {
      await _authRepository.deleteAccount(userId: current.user.id);
      emit(AccountDeleted());
    } catch (e) {
      emit(current);
      emit(AuthError(e.toString()));
    }
  }
}