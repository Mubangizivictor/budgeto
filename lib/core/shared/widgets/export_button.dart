// core/shared/widgets/export_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/models/income_model.dart';
import '../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../../presentation/cubits/income_cubit/income_cubit.dart';
import '../../../presentation/cubits/export_cubit/export_cubit.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExportCubit, ExportState>(
      listener: (context, state) {
        if (state is ExportSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report exported successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ExportCubit>().reset();
        }
        if (state is ExportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export failed: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
          context.read<ExportCubit>().reset();
        }
      },
      builder: (context, state) {
        final isLoading = state is ExportLoading;

        return IconButton(
          icon: isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(LucideIcons.download),
          onPressed: isLoading ? null : () => _showDateRangePicker(context),
        );
      },
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      ),
      helpText: 'Select export date range',
      saveText: 'Export',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    if (!context.mounted) return;

    // Collect data from existing cubits — no extra Firestore reads needed.
    final expenseState = context.read<ExpenseCubit>().state;
    final incomeState = context.read<IncomeCubit>().state;
    final authState = context.read<AuthCubit>().state;

    final allExpenses = expenseState is ExpenseLoaded
        ? expenseState.expenses
        : <ExpenseModel>[];
    final allIncome =
    incomeState is IncomeLoaded ? incomeState.income : <IncomeModel>[];

    final userName =
    authState is AuthAuthenticated ? authState.user.fullName : 'User';
    final userEmail =
    authState is AuthAuthenticated ? authState.user.email : '';

    // End of the picked end date (23:59:59) so the full last day is included.
    final endDate = DateTime(
      picked.end.year,
      picked.end.month,
      picked.end.day,
      23, 59, 59,
    );

    if (!context.mounted) return;

    context.read<ExportCubit>().exportPdf(
      startDate: picked.start,
      endDate: endDate,
      allExpenses: allExpenses,
      allIncome: allIncome,
      userName: userName,
      userEmail: userEmail,
    );
  }
}