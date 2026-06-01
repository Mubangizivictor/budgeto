// features/flow/widgets/month_progress_item.dart
import 'package:flutter/material.dart';

class MonthProgressItem extends StatelessWidget {
  final String month;
  final int income;
  final int expense;
  final double maxValue;
  final ThemeData theme;

  const MonthProgressItem({
    super.key,
    required this.month,
    required this.income,
    required this.expense,
    required this.maxValue,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final net = income - expense;

    // Clamp to [0, 1] so the bar never overflows.
    final incomeRatio = (income / maxValue).clamp(0.0, 1.0);
    final expenseRatio = (expense / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(month, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                net >= 0 ? '+\$$net' : '-\$${net.abs()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: net >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: incomeRatio,
                  backgroundColor:
                  isDark ? Colors.grey[800] : Colors.grey[200],
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: expenseRatio,
                  backgroundColor:
                  isDark ? Colors.grey[800] : Colors.grey[200],
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}