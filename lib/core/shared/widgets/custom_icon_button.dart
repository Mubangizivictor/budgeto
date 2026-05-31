// custom_icon_button.dart
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? theme.colorScheme.surface
            : theme.colorScheme.surface,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}