// features/insights/widgets/monthly_comparison.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'section_header.dart';
import 'comparison_item.dart';
import '../../../data/models/expense_model.dart';

class MonthlyComparison extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const MonthlyComparison({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final monthlyData = _calculateMonthlyData(expenses);
    final change = monthlyData.percentageChange;
    final isPositive = change > 0;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Month vs Last Month', icon: LucideIcons.calendar),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ComparisonItem(
                label: 'This Month',
                amount: '\$${monthlyData.thisMonth.toStringAsFixed(0)}',
                change: isPositive ? '+${change.toStringAsFixed(0)}%' : '${change.toStringAsFixed(0)}%',
                color: isPositive ? Colors.red : Colors.green,
              ),
              ComparisonItem(
                label: 'Last Month',
                amount: '\$${monthlyData.lastMonth.toStringAsFixed(0)}',
                change: 'Baseline',
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.zap, size: 20, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isPositive
                        ? 'You\'re spending ${change.toStringAsFixed(0)}% more this month. Try to reduce unnecessary expenses in the next 7 days.'
                        : 'Great job! You\'re spending ${change.abs().toStringAsFixed(0)}% less this month. Keep it up!',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _MonthlyData _calculateMonthlyData(List<ExpenseModel> expenses) {
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = DateTime(now.year, now.month, 0);

    double thisMonthTotal = 0;
    double lastMonthTotal = 0;

    for (final expense in expenses) {
      if (expense.date.isAfter(thisMonthStart)) {
        thisMonthTotal += expense.amount;
      } else if (expense.date.isAfter(lastMonthStart) && expense.date.isBefore(lastMonthEnd)) {
        lastMonthTotal += expense.amount;
      }
    }

    final percentageChange = lastMonthTotal > 0
        ? ((thisMonthTotal - lastMonthTotal) / lastMonthTotal * 100)
        : 0.0;

    return _MonthlyData(
      thisMonth: thisMonthTotal,
      lastMonth: lastMonthTotal,
      percentageChange: percentageChange,
    );
  }
}

class _MonthlyData {
  final double thisMonth;
  final double lastMonth;
  final double percentageChange;

  _MonthlyData({
    required this.thisMonth,
    required this.lastMonth,
    required this.percentageChange,
  });
}