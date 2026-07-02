// features/insights/widgets/financial_tips_section.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../data/models/expense_model.dart';
import 'tip_card.dart';

class FinancialTipsSection extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const FinancialTipsSection({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final tips = _buildTips(expenses);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.withValues(alpha: 0.1), Colors.blue.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.lightbulb, size: 20, color: Colors.amber),
              SizedBox(width: 8),
              Text('Financial Tips for You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: tip,
          )),
        ],
      ),
    );
  }

  /// Derives up to 3 tips from this month's actual spending instead of a
  /// fixed hardcoded list.
  List<TipCard> _buildTips(List<ExpenseModel> expenses) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final thisMonthExpenses =
        expenses.where((e) => !e.date.isBefore(monthStart)).toList();

    if (thisMonthExpenses.isEmpty) {
      return const [
        TipCard(
          tip: 'Log your first expense to get personalized tips',
          icon: LucideIcons.sparkles,
          savings: 'Tips improve as you track more',
        ),
      ];
    }

    final categoryTotals = <String, double>{};
    for (final expense in thisMonthExpenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final tips = <TipCard>[];

    // Tip 1: trim the top spending category.
    final top = sortedCategories.first;
    final topTrim = top.value * 0.15;
    tips.add(TipCard(
      tip: 'Cut ${top.key} spending by 15% this month',
      icon: LucideIcons.target,
      savings: 'Save \$${topTrim.toStringAsFixed(0)}/mo',
    ));

    // Tip 2: daily spending cap based on actual daily average so far.
    final daysElapsed = now.difference(monthStart).inDays + 1;
    final totalThisMonth =
        thisMonthExpenses.fold(0.0, (sum, e) => sum + e.amount);
    final dailyAverage = totalThisMonth / daysElapsed;
    if (dailyAverage > 0) {
      final suggestedCap = (dailyAverage * 0.8);
      final projectedSavings = (dailyAverage - suggestedCap) * 30;
      tips.add(TipCard(
        tip: 'Set a daily spending cap of \$${suggestedCap.toStringAsFixed(0)}',
        icon: LucideIcons.calendarClock,
        savings: 'Save \$${projectedSavings.toStringAsFixed(0)}/mo',
      ));
    }

    // Tip 3: second-highest category, if there is one worth calling out.
    if (sortedCategories.length > 1) {
      final second = sortedCategories[1];
      final secondTrim = second.value * 0.1;
      if (secondTrim >= 5) {
        tips.add(TipCard(
          tip: 'Trim ${second.key} spending a little too',
          icon: LucideIcons.trendingDown,
          savings: 'Save \$${secondTrim.toStringAsFixed(0)}/mo',
        ));
      }
    }

    return tips.take(3).toList();
  }
}
