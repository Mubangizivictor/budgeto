// shared/widgets/comparison_item.dart
import 'package:flutter/material.dart';

class ComparisonItem extends StatelessWidget {
  final String label;
  final String amount;
  final String change;
  final Color color;

  const ComparisonItem({
    super.key,
    required this.label,
    required this.amount,
    required this.change,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            change,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}