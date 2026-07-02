import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../constants/app_strings.dart';
import 'export_button.dart';
import 'notification_bell.dart';

/// A common base AppBar that handles shared styling and actions across the app.
/// This reduces code duplication and ensures a consistent look and feel.
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text displayed in the AppBar.
  final String title;

  /// Optional leading widget (e.g., a menu button or back button).
  final Widget? leading;

  /// Optional list of actions. If null, default actions (Export and Notification) are used.
  final List<Widget>? actions;

  const BaseAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: leading,
      // Default actions used across most screens
      actions: actions ??
          const [
            ExportButton(),
            SizedBox(width: 8),
            NotificationBell(),
            SizedBox(width: 16), // Replaces actionsPadding to provide right margin
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar for the 'Cash Flow' screen.
class FlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FlowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseAppBar(
      title: AppStrings.cashFlow,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar for the 'Vault' screen. Includes a custom menu button to open the drawer.
class VaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      title: AppStrings.vault,
      // Using a Builder ensures we have the correct context to find the Scaffold
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(LucideIcons.menu),
            tooltip: 'Open Menu',
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// AppBar for the 'Smart Insights' screen.
class InsightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InsightAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseAppBar(
      title: AppStrings.smartInsights,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
