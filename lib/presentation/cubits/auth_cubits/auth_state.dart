// presentation/cubits/auth_cubits/auth_state.dart
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class PasswordResetSent extends AuthState {}

/// Emitted after [AuthCubit.updateProfile] succeeds.
/// Distinct from [AuthAuthenticated] so screens can listen for a save
/// event without triggering on every normal auth state change.
class ProfileUpdated extends AuthState {
  final User user;

  const ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Emitted after [AuthCubit.deleteAccount] succeeds.
class AccountDeleted extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}