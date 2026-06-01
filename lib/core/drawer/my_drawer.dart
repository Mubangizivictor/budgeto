// core/shared/widgets/drawer/my_drawer.dart (update the Help & Support tile)
import 'package:budgeto/core/drawer/widgets/drawer_divider.dart';
import 'package:budgeto/core/drawer/widgets/drawer_header.dart';
import 'package:budgeto/core/drawer/widgets/drawer_tile.dart';
import 'package:budgeto/core/drawer/widgets/logout_dialog.dart';
import 'package:budgeto/core/drawer/widgets/theme_switch_tile.dart';
import 'package:budgeto/features/profile/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/support/help_support_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header with User Info
            const CustomDrawerHeader(),
            const DrawerDivider(),

            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Help & Support
                  DrawerTile(
                    icon: LucideIcons.helpCircle,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),

                  // Theme Switch
                  const ThemeSwitchTile(),

                  const DrawerDivider(),

                  // Logout
                  DrawerTile(
                    icon: LucideIcons.logOut,
                    title: 'Logout',
                    isDestructive: true,
                    onTap: () => LogoutDialog.show(context),
                  ),
                ],
              ),
            ),

            // Version Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Version 1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}