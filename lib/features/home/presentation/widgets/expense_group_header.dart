// expense_group_header.dart
import 'package:flutter/material.dart';

class ExpenseGroupHeader extends StatelessWidget {
  final String date;
  final String totalAmount;

  const ExpenseGroupHeader({
    super.key,
    required this.date,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          totalAmount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}