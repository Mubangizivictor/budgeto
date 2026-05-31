// shared/widgets/warning_item.dart
import 'package:flutter/material.dart';

class WarningItem extends StatelessWidget {
  final String category;
  final String amount;
  final int percentage;
  final String status;
  final Color color;

  const WarningItem({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(category, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(status, style: TextStyle(fontSize: 11, color: color)),
            Text('$percentage% used', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}