// Smoke test for the splash screen, the app's actual entry point and the
// only screen reachable without a live Firebase connection.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:budgeto/core/splash/splash_screen.dart';
import 'package:budgeto/data/repositories/auth_repository.dart';
import 'package:budgeto/domain/entities/user.dart';
import 'package:budgeto/presentation/cubits/auth_cubits/auth_cubit.dart';

class _FakeUnauthenticatedRepository implements AuthRepository {
  @override
  bool isLoggedIn() => false;

  @override
  User? getCurrentUser() => null;

  @override
  Future<User?> getCurrentUserFromFirestore() async => null;

  @override
  Future<User?> signIn(String email, String password) async => null;

  @override
  Future<User?> signUp(String email, String password, String fullName) async =>
      null;

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> updateProfile({
    required String userId,
    required String fullName,
  }) async {}

  @override
  Future<void> deleteAccount({required String userId}) async {}

  @override
  Future<void> reauthenticate({required String password}) async {}

  @override
  Future<String> updateProfilePhoto({
    required String userId,
    required File photo,
  }) async =>
      '';
}

void main() {
  testWidgets('SplashScreen renders brand then routes to login when signed out',
      (tester) async {
    SharedPreferences.setMockInitialValues({'isFirstTime': false});

    await tester.pumpWidget(
      BlocProvider<AuthCubit>(
        create: (_) =>
            AuthCubit(authRepository: _FakeUnauthenticatedRepository()),
        child: MaterialApp(
          home: const SplashScreen(),
          routes: {
            '/login': (_) => const Scaffold(body: Text('Login')),
            '/boarding': (_) => const Scaffold(body: Text('Boarding')),
            '/home': (_) => const Scaffold(body: Text('Home')),
          },
        ),
      ),
    );

    // Immediately after the first frame, the brand is visible.
    expect(find.text('Budgeto'), findsOneWidget);
    expect(find.text('Track. Save. Grow.'), findsOneWidget);

    // Let the splash's timed auth check complete and navigate away.
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Login'), findsOneWidget);
  });
}
