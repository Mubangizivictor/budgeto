// core/shared/widgets/drawer/theme_switch_tile.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import 'drawer_tile.dart';

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeData.brightness == Brightness.dark;

    return DrawerTile(
      icon: isDark ? LucideIcons.sun : LucideIcons.moon,
      title: isDark ? 'Light Mode' : 'Dark Mode',
      onTap: () => themeProvider.toggleTheme(),
      trailing: Switch(
        value: isDark,
        onChanged: (_) => themeProvider.toggleTheme(),
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}