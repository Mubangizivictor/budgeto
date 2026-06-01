// features/flow/widgets/monthly_breakdown.dart
import 'package:flutter/material.dart';
import '../../../core/shared/widgets/card_container.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/models/income_model.dart';
import 'month_progress_item.dart';

class MonthlyBreakdown extends StatelessWidget {
  final ThemeData theme;
  final List<ExpenseModel> expenses;
  final List<IncomeModel> income;

  const MonthlyBreakdown({
    super.key,
    required this.theme,
    required this.expenses,
    required this.income,
  });

  /// Build a list of the last [count] calendar months, most recent last.
  List<_MonthData> _buildMonthData(int count) {
    final now = DateTime.now();
    final result = <_MonthData>[];

    for (int i = count - 1; i >= 0; i--) {
      // Go back i months from the current month.
      int month = now.month - i;
      int year = now.year;
      while (month <= 0) {
        month += 12;
        year -= 1;
      }

      final monthStart = DateTime(year, month, 1);
      final monthEnd = DateTime(year, month + 1, 0, 23, 59, 59);

      final monthlyExpenses = expenses
          .where((e) =>
      !e.date.isBefore(monthStart) && !e.date.isAfter(monthEnd))
          .fold(0.0, (sum, e) => sum + e.amount);

      final monthlyIncome = income
          .where((i) =>
      !i.date.isBefore(monthStart) && !i.date.isAfter(monthEnd))
          .fold(0.0, (sum, i) => sum + i.amount);

      result.add(_MonthData(
        label: _shortMonthName(month),
        income: monthlyIncome.round(),
        expense: monthlyExpenses.round(),
      ));
    }

    return result;
  }

  static String _shortMonthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[(month - 1).clamp(0, 11)];
  }

  @override
  Widget build(BuildContext context) {
    final months = _buildMonthData(4);

    // Use the largest income or expense value as the progress bar ceiling,
    // with a sensible minimum of 1000 so the bars aren't full at tiny values.
    final maxValue = [
      1000,
      ...months.map((m) => m.income),
      ...months.map((m) => m.expense),
    ].reduce((a, b) => a > b ? a : b).toDouble();

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Movement',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...months.map((m) => MonthProgressItem(
            month: m.label,
            income: m.income,
            expense: m.expense,
            maxValue: maxValue,
            theme: theme,
          )),
        ],
      ),
    );
  }
}

class _MonthData {
  final String label;
  final int income;
  final int expense;
  _MonthData({
    required this.label,
    required this.income,
    required this.expense,
  });
}