// core/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authCubit = context.read<AuthCubit>();
    final isLoggedIn = authCubit.state is AuthAuthenticated;

    // Check if first time user
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // First time user - show onboarding
      await prefs.setBool('isFirstTime', false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/boarding');
      }
    } else if (isLoggedIn) {
      // User is logged in - go to home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // User not logged in - go to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/black_logo.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 24),
            Text(
              'Budgeto',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Track. Save. Grow.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}