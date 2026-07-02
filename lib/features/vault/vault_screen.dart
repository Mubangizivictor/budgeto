// features/vault/vault_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_strings.dart';
import '../../core/shared/widgets/app_bars.dart';
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
  String selectedCategory = 'All';

  final List<String> categories = [
    AppStrings.all,
    AppStrings.food,
    AppStrings.shopping,
    AppStrings.transport,
    AppStrings.entertainment,
    AppStrings.health,
    AppStrings.education,
    AppStrings.bills,
    AppStrings.other,
  ];

  // ── Filtering ────────────────────────────────────────────────────────────

  List<ExpenseModel> _filterExpenses(List<ExpenseModel> expenses) {
    if (selectedCategory == AppStrings.all) return expenses;
    return expenses
        .where((e) =>
    e.category.toLowerCase() == selectedCategory.toLowerCase())
        .toList();
  }

  List<IncomeModel> _filterIncome(List<IncomeModel> income) {
    // Income has no category matching expense categories, so when the user
    // picks a specific expense category, hide income entries (they belong to
    // their own 'source' field). Only show income when 'All' is selected.
    if (selectedCategory == AppStrings.all) return income;
    return [];
  }

  // ── Date grouping ─────────────────────────────────────────────────────────

  Map<DateTime, List<ExpenseModel>> _groupExpensesByDate(
      List<ExpenseModel> expenses) {
    final map = <DateTime, List<ExpenseModel>>{};
    for (final expense in expenses) {
      final date = DateTime(
          expense.date.year, expense.date.month, expense.date.day);
      map.putIfAbsent(date, () => []).add(expense);
    }
    // Sort descending (most recent first).
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
    return sorted;
  }

  Map<DateTime, List<IncomeModel>> _groupIncomeByDate(
      List<IncomeModel> incomes) {
    final map = <DateTime, List<IncomeModel>>{};
    for (final income in incomes) {
      final date =
      DateTime(income.date.year, income.date.month, income.date.day);
      map.putIfAbsent(date, () => []).add(income);
    }
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
    return sorted;
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date == today) return AppStrings.today;
    if (date == yesterday) return AppStrings.yesterday;
    return '${date.day}/${date.month}/${date.year}';
  }

  // ── Category helpers ──────────────────────────────────────────────────────

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return LucideIcons.coffee;
      case 'shopping':
        return LucideIcons.shoppingBag;
      case 'transport':
        return LucideIcons.car;
      case 'entertainment':
        return LucideIcons.tv;
      case 'health':
        return LucideIcons.heart;
      case 'education':
        return LucideIcons.bookOpen;
      case 'bills':
        return LucideIcons.fileText;
      default:
        return LucideIcons.circleDollarSign;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.blue;
      case 'transport':
        return Colors.purple;
      case 'entertainment':
        return Colors.red;
      case 'health':
        return Colors.teal;
      case 'education':
        return Colors.brown;
      case 'bills':
        return Colors.grey;
      default:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const VaultAppBar(),
      body: CustomScrollView(
        slivers: [
          // Balance card + filter chips header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  BlocBuilder<ExpenseCubit, ExpenseState>(
                    builder: (context, expenseState) {
                      return BlocBuilder<IncomeCubit, IncomeState>(
                        builder: (context, incomeState) {
                          final totalExpenses =
                          expenseState is ExpenseLoaded
                              ? expenseState.totalExpenses
                              : 0.0;
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
                    onFilterSelected: (category) =>
                        setState(() => selectedCategory = category),
                  ),
                ],
              ),
            ),
          ),

          // Transaction list — filtered by selectedCategory
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: BlocBuilder<ExpenseCubit, ExpenseState>(
              builder: (context, expenseState) {
                return BlocBuilder<IncomeCubit, IncomeState>(
                  builder: (context, incomeState) {
                    if (expenseState is ExpenseLoading ||
                        incomeState is IncomeLoading) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    final allExpenses = expenseState is ExpenseLoaded
                        ? expenseState.expenses
                        : <ExpenseModel>[];
                    final allIncome = incomeState is IncomeLoaded
                        ? incomeState.income
                        : <IncomeModel>[];

                    final filteredExpenses = _filterExpenses(allExpenses);
                    final filteredIncome = _filterIncome(allIncome);

                    if (filteredExpenses.isEmpty && filteredIncome.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_outlined,
                                    size: 64, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  selectedCategory == AppStrings.all
                                      ? AppStrings.noTransactions
                                      : 'No $selectedCategory transactions',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final groupedExpenses =
                    _groupExpensesByDate(filteredExpenses);
                    final groupedIncome =
                    _groupIncomeByDate(filteredIncome);

                    // Merge all date keys and sort descending.
                    final allDates = <DateTime>{
                      ...groupedExpenses.keys,
                      ...groupedIncome.keys,
                    }.toList()
                      ..sort((a, b) => b.compareTo(a));

                    final widgets = <Widget>[];

                    for (final date in allDates) {
                      final dayExpenses = groupedExpenses[date] ?? [];
                      final dayIncome = groupedIncome[date] ?? [];

                      final transactions = [
                        ...dayExpenses.map((expense) => {
                          'title': expense.note.isNotEmpty
                              ? expense.note
                              : expense.category,
                          'amount':
                          '\$${expense.amount.toStringAsFixed(2)}',
                          'category': expense.category,
                          'icon': _getCategoryIcon(expense.category),
                          'iconColor':
                          _getCategoryColor(expense.category),
                          'isIncome': false,
                        }),
                        ...dayIncome.map((income) => {
                          'title': income.note.isNotEmpty
                              ? income.note
                              : income.source,
                          'amount':
                          '\$${income.amount.toStringAsFixed(2)}',
                          'category': income.source,
                          'icon': LucideIcons.trendingUp,
                          'iconColor': Colors.green,
                          'isIncome': true,
                        }),
                      ];

                      widgets.add(TransactionGroup(
                        title: _formatDateHeader(date),
                        transactions: transactions,
                      ));
                    }

                    widgets.add(const SizedBox(height: 100));

                    return SliverList(
                      delegate: SliverChildListDelegate(widgets),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}