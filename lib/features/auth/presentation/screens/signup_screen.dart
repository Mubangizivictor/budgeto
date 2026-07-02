// presentation/screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/terms_checkbox.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreeToTerms = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Navigate to home directly after signup
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (route) => false,
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
                      const AuthHeader(
                        title: AppStrings.createAccount,
                        subtitle: AppStrings.signupSubtitle,
                      ),
                      const SizedBox(height: 48),
                      AuthTextField(
                        controller: fullNameController,
                        label: AppStrings.fullName,
                        hint: AppStrings.fullNameHint,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        controller: emailController,
                        label: AppStrings.email,
                        hint: AppStrings.emailHint,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        controller: passwordController,
                        label: AppStrings.password,
                        hint: AppStrings.passwordCreateHint,
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
                      const SizedBox(height: 24),
                      AuthTextField(
                        controller: confirmPasswordController,
                        label: AppStrings.confirmPassword,
                        hint: AppStrings.confirmPasswordHint,
                        icon: Icons.shield_outlined,
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                          icon: Icon(
                            obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TermsCheckbox(
                        value: agreeToTerms,
                        onChanged: (value) => setState(() => agreeToTerms = value ?? false),
                      ),
                      const SizedBox(height: 32),
                      AuthButton(
                        label: AppStrings.createAccount,
                        onPressed: (!agreeToTerms || isLoading)
                            ? null
                            : () {
                                if (passwordController.text != confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(AppStrings.passwordsDoNotMatch),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                context.read<AuthCubit>().signUp(
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                      fullName: fullNameController.text.trim(),
                                    );
                              },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAccount,
                            style: theme.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              " " + AppStrings.signIn,
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
    );
  }
}