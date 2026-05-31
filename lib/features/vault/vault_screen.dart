// features/vault/vault_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../flow/widgets/flow_app_bars.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/income_model.dart';
import '../home/presentation/widgets/balance_card.dart';
import 'widgets/filter_chips.dart';
import 'widgets/transaction_group.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String selectedFilter = 'All';
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Food', 'Shopping', 'Transport', 'Entertainment'];

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
      appBar: const VaultAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Balance Card with real data
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

                  const SizedBox(height: 12),
                  FilterChips(
                    filters: categories,
                    selectedFilter: selectedCategory,
                    onFilterSelected: (category) => setState(() => selectedCategory = category),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Expenses Section
                BlocBuilder<ExpenseCubit, ExpenseState>(
                  builder: (context, expenseState) {
                    if (expenseState is ExpenseLoaded) {
                      final expenses = expenseState.expenses;
                      if (expenses.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      // Group expenses by date
                      final groupedExpenses = _groupExpensesByDate(expenses);

                      return Column(
                        children: groupedExpenses.entries.map((entry) {
                          return TransactionGroup(
                            title: _formatDateHeader(entry.key),
                            transactions: entry.value.map((expense) {
                              return {
                                'title': expense.note.isNotEmpty ? expense.note : expense.category,
                                'amount': '\$${expense.amount.toStringAsFixed(2)}',
                                'category': expense.category,
                                'icon': _getCategoryIcon(expense.category),
                                'iconColor': _getCategoryColor(expense.category),
                                'isIncome': false,
                              };
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Income Section
                BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, incomeState) {
                    if (incomeState is IncomeLoaded) {
                      final incomes = incomeState.income;
                      if (incomes.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      // Group income by date
                      final groupedIncomes = _groupIncomeByDate(incomes);

                      return Column(
                        children: groupedIncomes.entries.map((entry) {
                          return TransactionGroup(
                            title: _formatDateHeader(entry.key),
                            transactions: entry.value.map((income) {
                              return {
                                'title': income.note.isNotEmpty ? income.note : income.source,
                                'amount': '\$${income.amount.toStringAsFixed(2)}',
                                'category': income.source,
                                'icon': LucideIcons.trendingUp,
                                'iconColor': Colors.green,
                                'isIncome': true,
                              };
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<ExpenseModel>> _groupExpensesByDate(List<ExpenseModel> expenses) {
    final map = <DateTime, List<ExpenseModel>>{};
    for (final expense in expenses) {
      final date = DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(expense);
    }
    return map;
  }

  Map<DateTime, List<IncomeModel>> _groupIncomeByDate(List<IncomeModel> incomes) {
    final map = <DateTime, List<IncomeModel>>{};
    for (final income in incomes) {
      final date = DateTime(income.date.year, income.date.month, income.date.day);
      if (!map.containsKey(date)) {
        map[date] = [];
      }
      map[date]!.add(income);
    }
    return map;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) {
      return 'Today';
    } else if (date == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return LucideIcons.coffee;
      case 'shopping': return LucideIcons.shoppingBag;
      case 'transport': return LucideIcons.car;
      case 'entertainment': return LucideIcons.tv;
      case 'health': return LucideIcons.heart;
      case 'education': return LucideIcons.bookOpen;
      case 'bills': return LucideIcons.fileText;
      default: return LucideIcons.circleDollarSign;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Colors.orange;
      case 'shopping': return Colors.blue;
      case 'transport': return Colors.purple;
      case 'entertainment': return Colors.red;
      case 'health': return Colors.teal;
      case 'education': return Colors.brown;
      case 'bills': return Colors.grey;
      default: return Colors.indigo;
    }
  }
}