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

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  final _categoryInsightsKey = GlobalKey();
  final _tipsKey = GlobalKey();
  final _warningsKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

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

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AISummaryCard(
                    expenses: expenses,
                    // "Analyze" jumps to the category breakdown, "Suggest"
                    // to actionable tips, "Optimize" to budget warnings —
                    // the sections that back up the summary's claim.
                    onAnalyze: () => _scrollTo(_categoryInsightsKey),
                    onSuggest: () => _scrollTo(_tipsKey),
                    onOptimize: () => _scrollTo(_warningsKey),
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
                key: _warningsKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BudgetWarningsSection(expenses: expenses),
                ),
              ),
              SliverToBoxAdapter(
                key: _categoryInsightsKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryInsightsSection(expenses: expenses),
                ),
              ),
              SliverToBoxAdapter(
                key: _tipsKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FinancialTipsSection(expenses: expenses),
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
