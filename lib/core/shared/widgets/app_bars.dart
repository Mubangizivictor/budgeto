// shared/widgets/app_bars.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'export_button.dart';
import 'notification_bell.dart';

class FlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FlowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: const Text('Cash Flow',
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      actions: [
        const ExportButton(),
        const NotificationBell(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class VaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VaultAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: const Text('Vault',
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading:
      IconButton(icon: const Icon(LucideIcons.menu), onPressed: () {}),
      actions: [
        const ExportButton(),
        const NotificationBell(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class InsightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const InsightAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: const Text('Smart Insights',
          style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: false,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 16),
              const SizedBox(width: 6),
              Text(
                'AI Mode',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const ExportButton(),
        const NotificationBell(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}