// features/insights/widgets/category_insights_section.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'section_header.dart';
import 'insight_card.dart';
import '../../../data/models/expense_model.dart';

class CategoryInsightsSection extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const CategoryInsightsSection({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights(expenses);

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Category Insights', icon: LucideIcons.pieChart),
          const SizedBox(height: 16),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InsightCard(
              category: insight.category,
              change: insight.change,
              insight: insight.insight,
              type: insight.type,
            ),
          )),
        ],
      ),
    );
  }

  List<_InsightData> _generateInsights(List<ExpenseModel> expenses) {
    // Group expenses by category
    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Calculate total spending
    final totalSpending = categoryTotals.values.fold(0.0, (sum, v) => sum + v);

    // Generate insights
    final insights = <_InsightData>[];

    for (final entry in categoryTotals.entries) {
      final percentage = totalSpending > 0 ? (entry.value / totalSpending * 100).round() : 0;

      if (percentage > 20) {
        insights.add(_InsightData(
          category: entry.key,
          change: '+$percentage%',
          insight: 'You spent $percentage% of your budget on ${entry.key}',
          type: 'warning',
        ));
      } else if (percentage < 10 && entry.value > 0) {
        insights.add(_InsightData(
          category: entry.key,
          change: '-${15 - percentage}%',
          insight: 'Great job! You saved on ${entry.key}',
          type: 'success',
        ));
      }
    }

    // Sort by highest percentage and take top 3
    insights.sort((a, b) => b.change.compareTo(a.change));
    return insights.take(3).toList();
  }
}

class _InsightData {
  final String category;
  final String change;
  final String insight;
  final String type;

  _InsightData({
    required this.category,
    required this.change,
    required this.insight,
    required this.type,
  });
}