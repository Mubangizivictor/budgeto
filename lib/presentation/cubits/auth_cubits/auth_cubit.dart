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
    if (_authRepository.isLoggedIn()) {
      // getCurrentUser() reads from Firebase Auth (fast, offline-safe).
      // It now has fullName because we write displayName at sign-up.
      final user = _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
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

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}