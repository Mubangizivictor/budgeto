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

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Real per-day expense totals for the current week (Mon–Sun).
  List<Map<String, dynamic>> _weeklyChartData(List<ExpenseModel> allExpenses) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (i) {
      final day = startOfWeek.add(Duration(days: i));
      final total = allExpenses
          .where((e) =>
      e.date.year == day.year &&
          e.date.month == day.month &&
          e.date.day == day.day)
          .fold(0.0, (sum, e) => sum + e.amount);
      return {'day': _dayLabels[i], 'value': total.round()};
    });
  }

  /// Real monthly expense totals for the trailing 6 months.
  List<Map<String, dynamic>> _monthlyChartData(List<ExpenseModel> allExpenses) {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final monthDate = DateTime(now.year, now.month - 5 + i, 1);
      final total = allExpenses
          .where((e) =>
      e.date.year == monthDate.year && e.date.month == monthDate.month)
          .fold(0.0, (sum, e) => sum + e.amount);
      return {'month': _monthLabels[monthDate.month - 1], 'value': total.round()};
    });
  }

  /// The equivalent period immediately before [_selectedRange], used to
  /// compute real income/expense % change instead of a placeholder.
  DateTimeRange get _previousRange {
    final range = _selectedRange;
    final duration = range.end.difference(range.start);
    return DateTimeRange(
      start: range.start.subtract(duration),
      end: range.start.subtract(const Duration(seconds: 1)),
    );
  }

  double _percentageChange(double current, double previous) {
    if (previous <= 0) return 0.0;
    return ((current - previous) / previous * 100);
  }

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

                // Trend Chart — real per-day/per-month expense totals
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    final allExpenses = expenseState is ExpenseLoaded
                        ? expenseState.expenses
                        : <ExpenseModel>[];

                    return TrendChartSection(
                      data: selectedPeriod == 'Weekly'
                          ? _weeklyChartData(allExpenses)
                          : _monthlyChartData(allExpenses),
                      selectedPeriod: selectedPeriod,
                      primaryColor: theme.primaryColor,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Movement Indicators — filtered to selected period, with
                // change percentages computed against the prior period.
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final allExpenses = expenseState is ExpenseLoaded
                            ? expenseState.expenses
                            : <ExpenseModel>[];
                        final allIncome = incomeState is IncomeLoaded
                            ? incomeState.income
                            : <IncomeModel>[];

                        final filteredExpenses = _filterExpenses(allExpenses);
                        final filteredIncome = _filterIncome(allIncome);

                        final totalExpenses =
                        filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
                        final totalIncome =
                        filteredIncome.fold(0.0, (sum, i) => sum + i.amount);

                        final prevRange = _previousRange;
                        final prevExpenses = allExpenses.where((e) =>
                        !e.date.isBefore(prevRange.start) &&
                            !e.date.isAfter(prevRange.end),
                        ).fold(0.0, (sum, e) => sum + e.amount);
                        final prevIncome = allIncome.where((i) =>
                        !i.date.isBefore(prevRange.start) &&
                            !i.date.isAfter(prevRange.end),
                        ).fold(0.0, (sum, i) => sum + i.amount);

                        return MovementIndicators(
                          primaryColor: theme.primaryColor,
                          totalIncome: totalIncome,
                          totalExpenses: totalExpenses,
                          incomeChange:
                          _percentageChange(totalIncome, prevIncome).abs(),
                          expenseChange:
                          _percentageChange(totalExpenses, prevExpenses).abs(),
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