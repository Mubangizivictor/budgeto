// features/home/presentation/screens/home_screen.dart
import 'package:budgeto/core/drawer/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../../../presentation/cubits/income_cubit/income_cubit.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_appbar.dart';
import '../widgets/expense_list_section.dart';
import '../../../../data/models/expense_model.dart';
import '../../../../data/models/income_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Default to the current month. HomeHeader will fire onPeriodChanged
  // in its initState, which sets this to the proper range immediately.
  DateTimeRange _selectedRange = DateTimeRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
      23, 59, 59,
    ),
  );

  String get _userId {
    final authState = context.read<AuthCubit>().state;
    return authState is AuthAuthenticated ? authState.user.id : '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Data loading belongs here (not in build). The cubit guards against
    // duplicate subscriptions, but we still only want to kick this off once
    // per screen mount, not on every rebuild.
    //
    // MainNavScreen already calls getExpenses/getIncome when it mounts, so
    // this is primarily the safety net for direct navigation to HomeScreen.
  }

  void _onPeriodChanged(DateTimeRange range) {
    setState(() => _selectedRange = range);
  }

  /// Filter a list of expenses to only those within [_selectedRange].
  List<ExpenseModel> _filterExpenses(List<ExpenseModel> all) {
    return all.where((e) {
      return !e.date.isBefore(_selectedRange.start) &&
          !e.date.isAfter(_selectedRange.end);
    }).toList();
  }

  /// Filter a list of income entries to only those within [_selectedRange].
  List<IncomeModel> _filterIncome(List<IncomeModel> all) {
    return all.where((i) {
      return !i.date.isBefore(_selectedRange.start) &&
          !i.date.isAfter(_selectedRange.end);
    }).toList();
  }

  Future<void> _onRefresh() async {
    final userId = _userId;
    if (userId.isNotEmpty) {
      context.read<ExpenseCubit>().getExpenses(userId);
      context.read<IncomeCubit>().getIncome(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold( drawer: MyDrawer(),
      appBar: const HomeAppBar(),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                HomeHeader(onPeriodChanged: _onPeriodChanged),

                const SizedBox(height: 24),

                // Balance card — filtered to the selected period.
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) => const SizedBox.shrink(),
                    );
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final filteredExpenses = expenseState is ExpenseLoaded
                            ? _filterExpenses(expenseState.expenses)
                            : <ExpenseModel>[];

                        final filteredIncome = incomeState is IncomeLoaded
                            ? _filterIncome(incomeState.income)
                            : <IncomeModel>[];

                        final totalExpenses = filteredExpenses.fold(
                          0.0, (sum, e) => sum + e.amount,
                        );
                        final totalIncome = filteredIncome.fold(
                          0.0, (sum, i) => sum + i.amount,
                        );

                        return BalanceCard(
                          totalBalance: totalIncome - totalExpenses,
                          income: totalIncome,
                          expenses: totalExpenses,
                          savings: totalIncome - totalExpenses,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Expense list — filtered to the selected period.
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    if (expenseState is ExpenseLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (expenseState is ExpenseLoaded) {
                      final filtered = _filterExpenses(expenseState.expenses);

                      if (filtered.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No transactions yet',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the + button to add your first transaction',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ExpenseListSection(expenses: filtered);
                    }

                    if (expenseState is ExpenseError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Error: ${expenseState.message}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _onRefresh,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                // Bottom padding so last item clears the FAB.
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}