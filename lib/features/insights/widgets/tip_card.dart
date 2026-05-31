// shared/widgets/tip_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TipCard extends StatelessWidget {
  final String tip;
  final IconData icon;
  final String savings;

  const TipCard({
    super.key,
    required this.tip,
    required this.icon,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tip, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(savings, style: TextStyle(fontSize: 11, color: Colors.green)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.chevronRight, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}