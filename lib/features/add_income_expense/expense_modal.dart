// features/add_income_expense/expense_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import 'widgets/drag_handle.dart';
import 'widgets/modal_header.dart';
import 'widgets/amount_field.dart';
import 'widgets/category_grid.dart';
import 'widgets/payment_method_field.dart';
import 'widgets/date_field.dart';
import 'widgets/note_field.dart';
import 'widgets/submit_button.dart';

class ExpenseModal extends StatefulWidget {
  final ExpenseCubit expenseCubit;
  final IncomeCubit incomeCubit;

  const ExpenseModal({
    super.key,
    required this.expenseCubit,
    required this.incomeCubit,
  });

  @override
  State<ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends State<ExpenseModal> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Food';
  String selectedPaymentMethod = 'Cash';

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': LucideIcons.coffee, 'color': Colors.orange},
    {'name': 'Shopping', 'icon': LucideIcons.shoppingBag, 'color': Colors.blue},
    {'name': 'Transport', 'icon': LucideIcons.car, 'color': Colors.purple},
    {'name': 'Entertainment', 'icon': LucideIcons.tv, 'color': Colors.red},
    {'name': 'Health', 'icon': LucideIcons.heart, 'color': Colors.teal},
    {'name': 'Education', 'icon': LucideIcons.bookOpen, 'color': Colors.brown},
    {'name': 'Bills', 'icon': LucideIcons.fileText, 'color': Colors.grey},
    {'name': 'Other', 'icon': LucideIcons.moreHorizontal, 'color': Colors.indigo},
  ];

  bool get isValid =>
      amountController.text.isNotEmpty &&
          double.tryParse(amountController.text) != null &&
          double.parse(amountController.text) > 0;

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return authState is AuthAuthenticated ? authState.user.id : '';
  }

  /// Current balance = total income - total expenses (from cubit states).
  double _getCurrentBalance(BuildContext context) {
    final expenseState = widget.expenseCubit.state;
    final incomeState = widget.incomeCubit.state;

    final totalExpenses =
    expenseState is ExpenseLoaded ? expenseState.totalExpenses : 0.0;
    final totalIncome =
    incomeState is IncomeLoaded ? incomeState.totalIncome : 0.0;

    final newAmount = double.tryParse(amountController.text) ?? 0.0;
    // Balance after this expense is applied.
    return totalIncome - totalExpenses - newAmount;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          const DragHandle(),
          const SizedBox(height: 20),
          ModalHeader(
            title: 'Add Expense',
            icon: LucideIcons.trendingDown,
            iconColor: theme.colorScheme.error,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AmountField(controller: amountController),
                  const SizedBox(height: 24),
                  CategoryGrid(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) =>
                        setState(() => selectedCategory = category),
                  ),
                  const SizedBox(height: 24),
                  PaymentMethodField(
                    selectedPaymentMethod: selectedPaymentMethod,
                    onChanged: (value) =>
                        setState(() => selectedPaymentMethod = value!),
                  ),
                  const SizedBox(height: 24),
                  DateField(
                    selectedDate: selectedDate,
                    onDateSelected: (date) =>
                        setState(() => selectedDate = date),
                    iconColor: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 24),
                  NoteField(controller: noteController),
                  const SizedBox(height: 32),
                  BlocProvider.value(
                    value: widget.expenseCubit,
                    child: BlocConsumer<ExpenseCubit, ExpenseState>(
                      listener: (context, state) {
                        if (state is ExpenseLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Expense added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          });
                        }
                        if (state is ExpenseError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          });
                        }
                      },
                      builder: (context, state) {
                        return SubmitButton(
                          label: 'Add Expense',
                          color: theme.colorScheme.error,
                          onPressed: isValid && state is! ExpenseLoading
                              ? () {
                            final userId = _getUserId(context);
                            if (userId.isNotEmpty) {
                              context.read<ExpenseCubit>().addExpense(
                                userId: userId,
                                amount: double.parse(
                                    amountController.text),
                                category: selectedCategory,
                                note: noteController.text,
                                date: selectedDate,
                                currentBalance:
                                _getCurrentBalance(context),
                              );
                            }
                          }
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}