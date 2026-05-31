// core/shared/widgets/drawer/drawer_divider.dart
import 'package:flutter/material.dart';

class DrawerDivider extends StatelessWidget {
  const DrawerDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? Colors.white24 : Colors.black12,
      indent: 16,
      endIndent: 16,
    );
  }
}