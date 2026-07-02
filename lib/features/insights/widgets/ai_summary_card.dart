// features/insights/widgets/ai_summary_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/gradient_card.dart';
import '../../../data/models/expense_model.dart';
import 'ai_action_button.dart';

class AISummaryCard extends StatelessWidget {
  final List<ExpenseModel> expenses;
  final VoidCallback? onAnalyze;
  final VoidCallback? onSuggest;
  final VoidCallback? onOptimize;

  const AISummaryCard({
    super.key,
    required this.expenses,
    this.onAnalyze,
    this.onSuggest,
    this.onOptimize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _biggestCategoryIncrease(expenses);

    return GradientCard(
      gradientColors: [
        theme.primaryColor,
        theme.primaryColor.withValues(alpha: 0.7),
        Colors.purple.withValues(alpha: 0.5),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('AI Summary', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            summary.message,
            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AIActionButton(label: 'Analyze', icon: LucideIcons.barChart, onTap: onAnalyze),
              AIActionButton(label: 'Suggest', icon: LucideIcons.lightbulb, onTap: onSuggest),
              AIActionButton(label: 'Optimize', icon: LucideIcons.target, onTap: onOptimize),
            ],
          ),
        ],
      ),
    );
  }

  /// Compares this month's spending per category against last month's and
  /// surfaces the category with the largest dollar increase — a real,
  /// data-backed callout rather than a hardcoded "food" assumption.
  _AISummary _biggestCategoryIncrease(List<ExpenseModel> expenses) {
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final lastMonthEnd = thisMonthStart;

    final thisMonthByCategory = <String, double>{};
    final lastMonthByCategory = <String, double>{};

    for (final expense in expenses) {
      final category = expense.category;
      if (!expense.date.isBefore(thisMonthStart)) {
        thisMonthByCategory[category] =
            (thisMonthByCategory[category] ?? 0) + expense.amount;
      } else if (!expense.date.isBefore(lastMonthStart) &&
          expense.date.isBefore(lastMonthEnd)) {
        lastMonthByCategory[category] =
            (lastMonthByCategory[category] ?? 0) + expense.amount;
      }
    }

    String? topCategory;
    double topIncrease = 0;
    double topPercentage = 0;

    for (final entry in thisMonthByCategory.entries) {
      final lastMonthAmount = lastMonthByCategory[entry.key] ?? 0;
      final increase = entry.value - lastMonthAmount;
      if (increase > topIncrease) {
        topIncrease = increase;
        topCategory = entry.key;
        topPercentage = lastMonthAmount > 0
            ? (increase / lastMonthAmount * 100)
            : 100;
      }
    }

    if (topCategory == null || topIncrease <= 0) {
      return const _AISummary(
        'No category spending increased significantly this month — nice and steady. Keep tracking to stay ahead of surprises.',
      );
    }

    return _AISummary(
      'You spent ${topPercentage.round()}% more on $topCategory this month compared to last month. '
      'Pulling that back to last month\'s level would save you about \$${topIncrease.toStringAsFixed(0)}.',
    );
  }
}

class _AISummary {
  final String message;
  const _AISummary(this.message);
}
