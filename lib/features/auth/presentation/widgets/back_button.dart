// core/shared/widgets/auth/back_button.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      onPressed: onPressed ?? () => Navigator.pop(context),
      icon: const Icon(LucideIcons.arrowLeft),
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}