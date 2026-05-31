// features/flow/flow_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/flow_app_bars.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
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

  // Sample trend data (still hardcoded for demo)
  final List<Map<String, dynamic>> chartData = const [
    {'day': 'Mon', 'value': 120},
    {'day': 'Tue', 'value': 85},
    {'day': 'Wed', 'value': 145},
    {'day': 'Thu', 'value': 60},
    {'day': 'Fri', 'value': 110},
    {'day': 'Sat', 'value': 165},
    {'day': 'Sun', 'value': 95},
  ];

  final List<Map<String, dynamic>> monthlyData = const [
    {'month': 'Jan', 'value': 3200},
    {'month': 'Feb', 'value': 2950},
    {'month': 'Mar', 'value': 3100},
    {'month': 'Apr', 'value': 3250},
    {'month': 'May', 'value': 2980},
    {'month': 'Jun', 'value': 3350},
  ];

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
      appBar: const FlowAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            title: const Text('Cash Flow'),
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
                // Net Flow Card with real data
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    final totalExpenses = expenseState is ExpenseLoaded
                        ? expenseState.totalExpenses
                        : 0.0;

                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final totalIncome = incomeState is IncomeLoaded
                            ? incomeState.totalIncome
                            : 0.0;

                        final netFlow = totalIncome - totalExpenses;
                        final percentageChange = netFlow != 0
                            ? (netFlow / (netFlow.abs() + 1000)) * 100
                            : 0.0;

                        return NetFlowCard(
                          netFlow: netFlow,
                          percentageChange: percentageChange.abs(),
                          isPositive: netFlow >= 0,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Trend Chart
                TrendChartSection(
                  data: selectedPeriod == 'Weekly' ? chartData : monthlyData,
                  selectedPeriod: selectedPeriod,
                  primaryColor: theme.primaryColor,
                ),
                const SizedBox(height: 24),

                // Movement Indicators with real data
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    final totalExpenses = expenseState is ExpenseLoaded
                        ? expenseState.totalExpenses
                        : 0.0;

                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final totalIncome = incomeState is IncomeLoaded
                            ? incomeState.totalIncome
                            : 0.0;

                        return MovementIndicators(
                          primaryColor: theme.primaryColor,
                          totalIncome: totalIncome,
                          totalExpenses: totalExpenses,
                          incomeChange: totalIncome != 0 ? 18.3 : 0.0,
                          expenseChange: totalExpenses != 0 ? 5.2 : 0.0,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Monthly Breakdown (still sample data for now)
                MonthlyBreakdown(theme: theme),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}