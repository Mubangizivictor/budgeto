// presentation/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection_container.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/back_button.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/or_divider.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/social_login_button.dart';
import '../../../../main_nav_screen.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainNavScreen()),
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final isLoading = state is AuthLoading;

            return LoadingOverlay(
              isLoading: isLoading,
              child: Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomBackButton(),
                        const SizedBox(height: 24),
                        const AuthHeader(
                          title: 'Welcome Back!',
                          subtitle: 'Sign in to continue managing your finances',
                        ),
                        const SizedBox(height: 48),
                        AuthTextField(
                          controller: emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        AuthTextField(
                          controller: passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline,
                          obscureText: obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscurePassword = !obscurePassword),
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RememberMeCheckbox(
                              value: rememberMe,
                              onChanged: (value) => setState(() => rememberMe = value ?? false),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        AuthButton(
                          label: 'Sign In',
                          onPressed: () {
                            context.read<AuthCubit>().signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                          },
                          isLoading: isLoading,
                        ),
                        const SizedBox(height: 24),
                        const OrDivider(),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            SocialLoginButton(icon: Icons.webhook, label: 'Google'),
                            SizedBox(width: 16),
                            SocialLoginButton(icon: Icons.apple, label: 'Apple'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: theme.textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}