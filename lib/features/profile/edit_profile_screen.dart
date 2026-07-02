// features/profile/presentation/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:budgeto/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/shared/widgets/profile_avatar.dart';
import '../../../../domain/entities/user.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../auth/presentation/widgets/auth_button.dart';
import '../auth/presentation/widgets/auth_text_field.dart';
import '../auth/presentation/widgets/back_button.dart';
import '../auth/presentation/widgets/loading_overlay.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  // Kept so the avatar doesn't flicker to a placeholder while AuthLoading
  // is emitted mid-save/mid-upload.
  User? _lastKnownUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      _fullNameController.text = authState.user.fullName;
      _emailController.text = authState.user.email;
      _lastKnownUser = authState.user;
    }
  }

  Future<void> _pickAndUploadPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    await context.read<AuthCubit>().updateProfilePhoto(File(picked.path));
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final newName = _fullNameController.text.trim();
    final currentState = context.read<AuthCubit>().state;

    // No-op if nothing changed.
    if (currentState is AuthAuthenticated &&
        currentState.user.fullName == newName) {
      Navigator.pop(context);
      return;
    }

    await context.read<AuthCubit>().updateProfile(fullName: newName);
  }

  Future<void> _confirmDeleteAccount() async {
    final passwordController = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          AppStrings.deleteAccountConfirmationTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(AppStrings.deleteAccountConfirmationMessage),
            const SizedBox(height: 16),
            const Text(
              'Enter your password to confirm.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, passwordController.text),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              AppStrings.delete,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    passwordController.dispose();

    if (password != null && password.isNotEmpty && mounted) {
      await context.read<AuthCubit>().deleteAccount(password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // ✅ ProfileUpdated — save succeeded
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.profileUpdated),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        // ✅ AccountDeleted — navigate to login and clear the stack
        if (state is AccountDeleted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
                (route) => false,
          );
        }

        // ✅ AuthError — show snackbar
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is AuthAuthenticated) {
          _lastKnownUser = state.user;
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return LoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text(AppStrings.editProfile),
              centerTitle: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              leading: const CustomBackButton(),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfileAvatar(
                      size: 100,
                      photoUrl: _lastKnownUser?.photoUrl,
                      isUploading: isLoading,
                      showEditBadge: true,
                      onTap: isLoading ? null : _pickAndUploadPhoto,
                    ),
                    const SizedBox(height: 32),

                    AuthTextField(
                      controller: _fullNameController,
                      label: AppStrings.fullName,
                      hint: AppStrings.fullNameHint,
                      icon: Icons.person_outline,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return AppStrings.fullNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    AuthTextField(
                      controller: _emailController,
                      label: AppStrings.email,
                      hint: AppStrings.emailHint,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                    ),
                    const SizedBox(height: 32),

                    AuthButton(
                      label: isLoading ? AppStrings.saving : AppStrings.saveChanges,
                      onPressed: isLoading ? null : _saveChanges,
                    ),
                    const SizedBox(height: 16),

                    // ── Delete account ────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: isLoading ? null : _confirmDeleteAccount,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          AppStrings.deleteAccount,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      AppStrings.deleteAccountDescription,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}