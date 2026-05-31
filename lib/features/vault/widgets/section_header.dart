import 'package:flutter/material.dart';

class VaultSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const VaultSectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }
}