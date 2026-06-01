// features/flow/widgets/chart_legend.dart
import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  final String label;
  final Color color;

  const ChartLegend({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isDark ? [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 2,
              ),
            ] : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}