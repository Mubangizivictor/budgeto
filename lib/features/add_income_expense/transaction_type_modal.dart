// features/add_income_expense/transaction_type_modal.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import 'income_modal.dart';
import 'expense_modal.dart';
import 'widgets/drag_handle.dart';
import 'widgets/transaction_type_option.dart';

class TransactionTypeModal extends StatelessWidget {
  final ExpenseCubit expenseCubit;
  final IncomeCubit incomeCubit;

  const TransactionTypeModal({
    super.key,
    required this.expenseCubit,
    required this.incomeCubit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DragHandle(),
          const SizedBox(height: 20),
          Text(
            'Add Transaction',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose transaction type',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: TransactionTypeOption(
                  title: 'Income',
                  icon: LucideIcons.trendingUp,
                  color: Colors.green,
                  subtitle: 'Add money you earned',
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => IncomeModal(
                        expenseCubit: expenseCubit,
                        incomeCubit: incomeCubit,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TransactionTypeOption(
                  title: 'Expense',
                  icon: LucideIcons.trendingDown,
                  color: theme.colorScheme.error,
                  subtitle: 'Track your spending',
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ExpenseModal(
                        expenseCubit: expenseCubit,
                        incomeCubit: incomeCubit,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}