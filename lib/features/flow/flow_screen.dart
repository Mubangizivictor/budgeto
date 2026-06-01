// features/flow/flow_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/shared/widgets/app_bars.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/income_model.dart';
import 'widgets/monthly_breakdown.dart';
import 'widgets/movement_indicators.dart';
import 'widgets/net_flow_card.dart';
import '../home/presentation/widgets/period_chip.dart';
import 'widgets/trend_chart_section.dart';

class FlowScreen extends StatefulWidget {
  const FlowScreen({super.key});

  @override
  State<FlowScreen> createState() => _FlowScreenState();
}

class _FlowScreenState extends State<FlowScreen> {
  String selectedPeriod = 'Weekly';

  // Chart data stays hardcoded — it's the visual demo data for the trend chart.
  final List<Map<String, dynamic>> weeklyChartData = const [
    {'day': 'Mon', 'value': 120},
    {'day': 'Tue', 'value': 85},
    {'day': 'Wed', 'value': 145},
    {'day': 'Thu', 'value': 60},
    {'day': 'Fri', 'value': 110},
    {'day': 'Sat', 'value': 165},
    {'day': 'Sun', 'value': 95},
  ];

  final List<Map<String, dynamic>> monthlyChartData = const [
    {'month': 'Jan', 'value': 3200},
    {'month': 'Feb', 'value': 2950},
    {'month': 'Mar', 'value': 3100},
    {'month': 'Apr', 'value': 3250},
    {'month': 'May', 'value': 2980},
    {'month': 'Jun', 'value': 3350},
  ];

  /// Return a [DateTimeRange] matching the selected period chip.
  DateTimeRange get _selectedRange {
    final now = DateTime.now();
    switch (selectedPeriod) {
      case 'Weekly':
      // Start of this week (Monday).
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return DateTimeRange(
          start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
          end: DateTime(now.year, now.month, now.day, 23, 59, 59),
        );
      case 'Monthly':
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        );
      case 'Yearly':
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, 12, 31, 23, 59, 59),
        );
      default:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        );
    }
  }

  List<ExpenseModel> _filterExpenses(List<ExpenseModel> all) {
    final range = _selectedRange;
    return all.where((e) =>
    !e.date.isBefore(range.start) && !e.date.isAfter(range.end),
    ).toList();
  }

  List<IncomeModel> _filterIncome(List<IncomeModel> all) {
    final range = _selectedRange;
    return all.where((i) =>
    !i.date.isBefore(range.start) && !i.date.isAfter(range.end),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const FlowAppBar(),
      body: CustomScrollView(
        slivers: [
          // Period chip selector
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: PeriodChip(
                        label: 'Weekly',
                        isSelected: selectedPeriod == 'Weekly',
                        onTap: () => setState(() => selectedPeriod = 'Weekly'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PeriodChip(
                        label: 'Monthly',
                        isSelected: selectedPeriod == 'Monthly',
                        onTap: () => setState(() => selectedPeriod = 'Monthly'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PeriodChip(
                        label: 'Yearly',
                        isSelected: selectedPeriod == 'Yearly',
                        onTap: () => setState(() => selectedPeriod = 'Yearly'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Net Flow Card — filtered to selected period
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final filteredExpenses = expenseState is ExpenseLoaded
                            ? _filterExpenses(expenseState.expenses)
                            : <ExpenseModel>[];
                        final filteredIncome = incomeState is IncomeLoaded
                            ? _filterIncome(incomeState.income)
                            : <IncomeModel>[];

                        final totalExpenses =
                        filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
                        final totalIncome =
                        filteredIncome.fold(0.0, (sum, i) => sum + i.amount);
                        final netFlow = totalIncome - totalExpenses;

                        // Simple percentage: net vs total inflow.
                        final percentageChange = totalIncome > 0
                            ? (netFlow / totalIncome * 100).abs()
                            : 0.0;

                        return NetFlowCard(
                          netFlow: netFlow,
                          percentageChange: percentageChange,
                          isPositive: netFlow >= 0,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Trend Chart (visual demo data — period label passed for axis labels)
                TrendChartSection(
                  data: selectedPeriod == 'Weekly'
                      ? weeklyChartData
                      : monthlyChartData,
                  selectedPeriod: selectedPeriod,
                  primaryColor: theme.primaryColor,
                ),
                const SizedBox(height: 24),

                // Movement Indicators — filtered to selected period
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final filteredExpenses = expenseState is ExpenseLoaded
                            ? _filterExpenses(expenseState.expenses)
                            : <ExpenseModel>[];
                        final filteredIncome = incomeState is IncomeLoaded
                            ? _filterIncome(incomeState.income)
                            : <IncomeModel>[];

                        final totalExpenses =
                        filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
                        final totalIncome =
                        filteredIncome.fold(0.0, (sum, i) => sum + i.amount);

                        return MovementIndicators(
                          primaryColor: theme.primaryColor,
                          totalIncome: totalIncome,
                          totalExpenses: totalExpenses,
                          // Change percentages are placeholder until you have
                          // previous-period data to compare against.
                          incomeChange: totalIncome > 0 ? 18.3 : 0.0,
                          expenseChange: totalExpenses > 0 ? 5.2 : 0.0,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Monthly Breakdown — real data grouped by calendar month
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final expenses = expenseState is ExpenseLoaded
                            ? expenseState.expenses
                            : <ExpenseModel>[];
                        final income = incomeState is IncomeLoaded
                            ? incomeState.income
                            : <IncomeModel>[];

                        return MonthlyBreakdown(
                          theme: theme,
                          expenses: expenses,
                          income: income,
                        );
                      },
                    );
                  },
                ),

                // Bottom padding so last item clears the FAB.
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}