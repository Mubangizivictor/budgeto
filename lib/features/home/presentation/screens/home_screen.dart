// features/home/presentation/screens/home_screen.dart
import 'package:budgeto/core/constants/app_strings.dart';
import 'package:budgeto/core/drawer/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../../../presentation/cubits/income_cubit/income_cubit.dart';
import 'package:budgeto/features/add_income_expense/expense_modal.dart';
import 'package:budgeto/features/add_income_expense/income_modal.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/home_appbar.dart';
import '../widgets/expense_list_section.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  void initState() {
    super.initState();
    // Initial fetch happens after the first frame to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final userId = _userId;
    if (userId.isNotEmpty) {
      context.read<ExpenseCubit>().getExpenses(
            userId,
            startDate: _selectedRange.start,
            endDate: _selectedRange.end,
          );
      context.read<IncomeCubit>().getIncome(
            userId,
            startDate: _selectedRange.start,
            endDate: _selectedRange.end,
          );
    }
  }

  void _onPeriodChanged(DateTimeRange range) {
    setState(() => _selectedRange = range);
    _fetchData();
  }

  Future<void> _onRefresh() async {
    _fetchData();
  }

  void _showAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExpenseModal(
        expenseCubit: context.read<ExpenseCubit>(),
        incomeCubit: context.read<IncomeCubit>(),
      ),
    );
  }

  void _showAddIncome() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IncomeModal(
        expenseCubit: context.read<ExpenseCubit>(),
        incomeCubit: context.read<IncomeCubit>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const MyDrawer(),
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
                const SizedBox(height: 16),

                // Period chips row
                HomeHeader(onPeriodChanged: _onPeriodChanged),

                const SizedBox(height: 24),

                // Balance card with Swipe to Add
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    return BlocBuilder<IncomeCubit, IncomeState>(
                      builder: (context, incomeState) {
                        final totalExpenses = expenseState is ExpenseLoaded 
                            ? expenseState.totalExpenses 
                            : 0.0;
                        final totalIncome = incomeState is IncomeLoaded 
                            ? incomeState.totalIncome 
                            : 0.0;

                        return GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity! < -500) {
                              // Swipe Left -> Expense
                              _showAddExpense();
                            } else if (details.primaryVelocity! > 500) {
                              // Swipe Right -> Income
                              _showAddIncome();
                            }
                          },
                          child: BalanceCard(
                            totalBalance: totalIncome - totalExpenses,
                            income: totalIncome,
                            expenses: totalExpenses,
                            savings: totalIncome - totalExpenses,
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Expense list — now uses data already filtered by the Cubit
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
                      final expenses = expenseState.expenses;

                      if (expenses.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  AppStrings.noTransactionsYet,
                                  style: theme.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.addFirstTransaction,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ExpenseListSection(expenses: expenses);
                    }

                    if (expenseState is ExpenseError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                '${AppStrings.errorPrefix}${expenseState.message}',
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _onRefresh,
                                child: const Text(AppStrings.retry),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}