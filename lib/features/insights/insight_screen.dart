// features/insights/insight_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../flow/widgets/flow_app_bars.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import 'widgets/ai_summary_card.dart';
import 'widgets/spending_habits_section.dart';
import 'widgets/budget_warnings_section.dart';
import 'widgets/category_insights_section.dart';
import 'widgets/financial_tips_section.dart';
import 'widgets/monthly_comparison.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    // Fetch real data
    if (userId.isNotEmpty) {
      context.read<ExpenseCubit>().getExpenses(userId);
      context.read<IncomeCubit>().getIncome(userId);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const InsightAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<ExpenseCubit, ExpenseState>(
                builder: (context, expenseState) {
                  double foodSpending = 0;
                  double totalSpending = 0;

                  if (expenseState is ExpenseLoaded) {
                    final expenses = expenseState.expenses;
                    for (final expense in expenses) {
                      totalSpending += expense.amount;
                      if (expense.category.toLowerCase() == 'food') {
                        foodSpending += expense.amount;
                      }
                    }
                  }

                  final foodPercentage = totalSpending > 0
                      ? (foodSpending / totalSpending * 100).round()
                      : 0;

                  return AISummaryCard(
                    foodPercentage: foodPercentage,
                    totalSpending: totalSpending,
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ExpenseCubit, ExpenseState>(
                builder: (context, expenseState) {
                  if (expenseState is ExpenseLoaded) {
                    return SpendingHabitsSection(expenses: expenseState.expenses);
                  }
                  return const SpendingHabitsSection(expenses: []);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<ExpenseCubit, ExpenseState>(
                builder: (context, expenseState) {
                  if (expenseState is ExpenseLoaded) {
                    return BudgetWarningsSection(expenses: expenseState.expenses);
                  }
                  return const BudgetWarningsSection(expenses: []);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ExpenseCubit, ExpenseState>(
                builder: (context, expenseState) {
                  if (expenseState is ExpenseLoaded) {
                    return CategoryInsightsSection(expenses: expenseState.expenses);
                  }
                  return const CategoryInsightsSection(expenses: []);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const FinancialTipsSection(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ExpenseCubit, ExpenseState>(
                builder: (context, expenseState) {
                  if (expenseState is ExpenseLoaded) {
                    return MonthlyComparison(expenses: expenseState.expenses);
                  }
                  return const MonthlyComparison(expenses: []);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}