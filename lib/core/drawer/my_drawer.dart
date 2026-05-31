// core/shared/widgets/drawer/my_drawer.dart
import 'package:budgeto/core/drawer/widgets/drawer_divider.dart';
import 'package:budgeto/core/drawer/widgets/drawer_header.dart';
import 'package:budgeto/core/drawer/widgets/drawer_tile.dart';
import 'package:budgeto/core/drawer/widgets/logout_dialog.dart';
import 'package:budgeto/core/drawer/widgets/theme_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';



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
                  // Home
                  DrawerTile(
                    icon: LucideIcons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Home
                    },
                  ),

                  // Flow (Cash Flow)
                  DrawerTile(
                    icon: LucideIcons.trendingUp,
                    title: 'Cash Flow',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Flow
                    },
                  ),

                  // Vault (Transactions)
                  DrawerTile(
                    icon: LucideIcons.wallet,
                    title: 'Vault',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Vault
                    },
                  ),

                  // Insights
                  DrawerTile(
                    icon: LucideIcons.sparkles,
                    title: 'Insights',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Insights
                    },
                  ),

                  const DrawerDivider(),

                  // Transaction History
                  DrawerTile(
                    icon: LucideIcons.history,
                    title: 'Transaction History',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Transaction History
                    },
                  ),

                  // Categories
                  DrawerTile(
                    icon: LucideIcons.tags,
                    title: 'Categories',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Categories Management
                    },
                  ),

                  // Budgets
                  DrawerTile(
                    icon: LucideIcons.target,
                    title: 'Budgets',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Budgets
                    },
                  ),

                  const DrawerDivider(),

                  // Settings
                  DrawerTile(
                    icon: LucideIcons.settings,
                    title: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Settings
                    },
                  ),

                  // Help & Support
                  DrawerTile(
                    icon: LucideIcons.helpCircle,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to Help
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