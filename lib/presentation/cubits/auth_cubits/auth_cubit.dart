// presentation/cubits/auth_cubits/auth_cubit.dart
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    // Call checkAuthStatus immediately when cubit is created
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    // First check if user is logged in with Firebase Auth
    if (!_authRepository.isLoggedIn()) {
      emit(AuthUnauthenticated());
      return;
    }

    emit(AuthLoading());

    try {
      // Try to get user from Firestore first
      final user = await _authRepository.getCurrentUserFromFirestore();
      if (user != null) {
        emit(AuthAuthenticated(user));
        return;
      }

      // Fallback: get from local auth
      final localUser = _authRepository.getCurrentUser();
      if (localUser != null) {
        emit(AuthAuthenticated(localUser));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      // On error, still try to get local user
      final localUser = _authRepository.getCurrentUser();
      if (localUser != null) {
        emit(AuthAuthenticated(localUser));
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
        photoUrl: current.user.photoUrl,
      );
      emit(ProfileUpdated(updatedUser));
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      emit(current);
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updateProfilePhoto(File photo) async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    emit(AuthLoading());
    try {
      final photoUrl = await _authRepository.updateProfilePhoto(
        userId: current.user.id,
        photo: photo,
      );
      final updatedUser = User(
        id: current.user.id,
        email: current.user.email,
        fullName: current.user.fullName,
        createdAt: current.user.createdAt,
        totalBalance: current.user.totalBalance,
        photoUrl: photoUrl,
      );
      emit(ProfileUpdated(updatedUser));
      emit(AuthAuthenticated(updatedUser));
    } catch (e) {
      emit(current);
      emit(AuthError(e.toString()));
    }
  }

  /// Requires [password] to establish a fresh login session before any
  /// data is deleted, so a stale session can't leave the account orphaned
  /// (Firestore data gone, Auth account still present).
  Future<void> deleteAccount({required String password}) async {
    final current = state;
    if (current is! AuthAuthenticated) return;

    emit(AuthLoading());
    try {
      await _authRepository.reauthenticate(password: password);
    } catch (e) {
      emit(current);
      emit(const AuthError(
        'Incorrect password. Please re-enter your password to confirm account deletion.',
      ));
      return;
    }

    try {
      await _authRepository.deleteAccount(userId: current.user.id);
      emit(AccountDeleted());
    } catch (e) {
      emit(current);
      emit(AuthError(e.toString()));
    }
  }
}