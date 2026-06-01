// core/shared/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final double iconSize;

  const ProfileAvatar({
    super.key,
    required this.size,
    this.onTap,
    this.iconSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            LucideIcons.user,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}