// features/insights/insight_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/shared/widgets/app_bars.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../data/models/expense_model.dart';
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

    // Data is already loaded by MainNavScreen — we just consume the cubit state.
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const InsightAppBar(),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, expenseState) {
          final expenses = expenseState is ExpenseLoaded
              ? expenseState.expenses
              : <ExpenseModel>[];

          double foodSpending = 0;
          double totalSpending = 0;
          for (final expense in expenses) {
            totalSpending += expense.amount;
            if (expense.category.toLowerCase() == 'food') {
              foodSpending += expense.amount;
            }
          }
          final foodPercentage = totalSpending > 0
              ? (foodSpending / totalSpending * 100).round()
              : 0;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AISummaryCard(
                    foodPercentage: foodPercentage,
                    totalSpending: totalSpending,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SpendingHabitsSection(expenses: expenses),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BudgetWarningsSection(expenses: expenses),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryInsightsSection(expenses: expenses),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: FinancialTipsSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MonthlyComparison(expenses: expenses),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}