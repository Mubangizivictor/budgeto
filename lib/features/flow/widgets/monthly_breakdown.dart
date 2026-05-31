// features/flow/widgets/monthly_breakdown.dart
import 'package:flutter/material.dart';
import '../../../core/shared/widgets/card_container.dart';
import 'month_progress_item.dart';

class MonthlyBreakdown extends StatelessWidget {
  final ThemeData theme;

  const MonthlyBreakdown({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final months = const [
      {'month': 'January', 'income': 3200, 'expense': 2800},
      {'month': 'February', 'income': 3100, 'expense': 2950},
      {'month': 'March', 'income': 3450, 'expense': 3100},
      {'month': 'April', 'income': 3300, 'expense': 3250},
    ];

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Monthly Movement', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...months.map((month) => MonthProgressItem(
            month: month['month'] as String,
            income: month['income'] as int,
            expense: month['expense'] as int,
            theme: theme,
          )),
        ],
      ),
    );
  }
}