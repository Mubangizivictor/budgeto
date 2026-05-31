// features/insights/widgets/budget_warnings_section.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'section_header.dart';
import 'warning_item.dart';
import '../../../data/models/expense_model.dart';

class BudgetWarningsSection extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const BudgetWarningsSection({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate budgets from real data
    final diningBudget = _calculateCategoryBudget(expenses, 'food', 350);
    final shoppingBudget = _calculateCategoryBudget(expenses, 'shopping', 400);
    final entertainmentBudget = _calculateCategoryBudget(expenses, 'entertainment', 200);

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Budget Warnings',
            icon: LucideIcons.alertTriangle,
            iconColor: Colors.orange,
          ),
          const SizedBox(height: 12),
          WarningItem(
            category: 'Dining Out',
            amount: '\$${diningBudget.spent} / \$${diningBudget.limit}',
            percentage: diningBudget.percentage,
            status: diningBudget.percentage > 80 ? 'Near limit!' : '${100 - diningBudget.percentage}% remaining',
            color: diningBudget.percentage > 80 ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 12),
          WarningItem(
            category: 'Shopping',
            amount: '\$${shoppingBudget.spent} / \$${shoppingBudget.limit}',
            percentage: shoppingBudget.percentage,
            status: shoppingBudget.percentage > 80 ? 'Near limit!' : '${100 - shoppingBudget.percentage}% remaining',
            color: shoppingBudget.percentage > 80 ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 12),
          WarningItem(
            category: 'Entertainment',
            amount: '\$${entertainmentBudget.spent} / \$${entertainmentBudget.limit}',
            percentage: entertainmentBudget.percentage,
            status: entertainmentBudget.percentage > 80 ? 'Near limit!' : '${100 - entertainmentBudget.percentage}% remaining',
            color: entertainmentBudget.percentage > 80 ? Colors.red : Colors.orange,
          ),
        ],
      ),
    );
  }

  _BudgetData _calculateCategoryBudget(List<ExpenseModel> expenses, String category, int limit) {
    final categoryExpenses = expenses.where((e) =>
        e.category.toLowerCase().contains(category)
    ).toList();

    final spent = categoryExpenses.fold(0.0, (sum, e) => sum + e.amount).round();
    final percentage = ((spent / limit) * 100).round();

    return _BudgetData(spent: spent, limit: limit, percentage: percentage.clamp(0, 100));
  }
}

class _BudgetData {
  final int spent;
  final int limit;
  final int percentage;

  _BudgetData({
    required this.spent,
    required this.limit,
    required this.percentage,
  });
}