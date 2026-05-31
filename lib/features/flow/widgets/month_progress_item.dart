import 'package:flutter/material.dart';

class MonthProgressItem extends StatelessWidget {
  final String month;
  final int income;
  final int expense;
  final ThemeData theme;

  const MonthProgressItem({
    super.key,
    required this.month,
    required this.income,
    required this.expense,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final net = income - expense;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(month, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                '\$$net',
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
                  value: income / 5000,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: expense / 5000,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
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