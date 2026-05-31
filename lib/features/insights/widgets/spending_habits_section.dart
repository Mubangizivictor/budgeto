// features/insights/widgets/spending_habits_section.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'section_header.dart';
import 'habit_item.dart';
import '../../../data/models/expense_model.dart';

class SpendingHabitsSection extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const SpendingHabitsSection({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate spending habits from real data
    final weekendSpending = _calculateWeekendSpending(expenses);
    final coffeeSpending = _calculateCategorySpending(expenses, 'coffee');
    final onlineShopping = _calculateCategorySpending(expenses, 'shopping');

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Spending Habits', icon: LucideIcons.trendingUp),
          const SizedBox(height: 16),
          HabitItem(
            habit: 'Weekend Spending',
            percentage: weekendSpending,
            insight: weekendSpending > 50 ? 'Higher than usual' : 'Lower than usual',
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          HabitItem(
            habit: 'Coffee & Dining',
            percentage: coffeeSpending,
            insight: coffeeSpending > 30 ? '5% above average' : 'Good job!',
            color: Colors.brown,
          ),
          const SizedBox(height: 12),
          HabitItem(
            habit: 'Online Shopping',
            percentage: onlineShopping,
            insight: onlineShopping > 60 ? 'Major spike on weekends' : 'Controlled spending',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  int _calculateWeekendSpending(List<ExpenseModel> expenses) {
    final weekendExpenses = expenses.where((e) {
      final weekday = e.date.weekday;
      return weekday == 6 || weekday == 7; // Saturday or Sunday
    }).toList();

    final totalSpending = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final weekendTotal = weekendExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return totalSpending > 0 ? ((weekendTotal / totalSpending) * 100).round() : 0;
  }

  int _calculateCategorySpending(List<ExpenseModel> expenses, String keyword) {
    final categoryExpenses = expenses.where((e) =>
    e.category.toLowerCase().contains(keyword) ||
        e.note.toLowerCase().contains(keyword)
    ).toList();

    final totalSpending = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final categoryTotal = categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);

    return totalSpending > 0 ? ((categoryTotal / totalSpending) * 100).round() : 0;
  }
}