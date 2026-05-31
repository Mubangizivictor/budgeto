// home_appbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/shared/widgets/app_logo.dart';
import '../../../../core/shared/widgets/custom_icon_button.dart';
import '../../../../core/theme/theme_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: const AppLogo(),
      actions: [
        CustomIconButton(
          icon: LucideIcons.search,
          onTap: () {},
        ),
        const SizedBox(width: 10),
        CustomIconButton(
          icon: theme.brightness == Brightness.dark
              ? LucideIcons.moon
              : LucideIcons.sun,
          onTap: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}