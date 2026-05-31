// shared/widgets/category_trend_item.dart
import 'package:flutter/material.dart';

class CategoryTrendItem extends StatelessWidget {
  final String name;
  final int spent;
  final String trend;
  final Color color;

  const CategoryTrendItem({
    super.key,
    required this.name,
    required this.spent,
    required this.trend,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = trend.contains('+');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Row(
              children: [
                Text(
                  '\$$spent',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isPositive ? Colors.red : Colors.green).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? Colors.red : Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: spent / 500,
          backgroundColor: Colors.grey.withValues(alpha: 0.1),
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}