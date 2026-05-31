// features/add_income_expense/income_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import '../../presentation/cubits/expense_cubits/expense_cubit.dart';
import 'widgets/drag_handle.dart';
import 'widgets/modal_header.dart';
import 'widgets/amount_field.dart';
import 'widgets/date_field.dart';
import 'widgets/source_field.dart';
import 'widgets/note_field.dart';
import 'widgets/submit_button.dart';

class IncomeModal extends StatefulWidget {
  final ExpenseCubit expenseCubit;
  final IncomeCubit incomeCubit;

  const IncomeModal({
    super.key,
    required this.expenseCubit,
    required this.incomeCubit,
  });

  @override
  State<IncomeModal> createState() => _IncomeModalState();
}

class _IncomeModalState extends State<IncomeModal> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedSource;

  bool get isValid =>
      amountController.text.isNotEmpty &&
          double.tryParse(amountController.text) != null &&
          double.parse(amountController.text) > 0 &&
          selectedSource != null;

  String _getUserId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      return authState.user.id;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 500,
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
            title: 'Add Income',
            icon: LucideIcons.trendingUp,
            iconColor: Colors.green,
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
                  DateField(
                    selectedDate: selectedDate,
                    onDateSelected: (date) => setState(() => selectedDate = date),
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  SourceField(
                    selectedSource: selectedSource,
                    onChanged: (value) => setState(() => selectedSource = value),
                  ),
                  const SizedBox(height: 24),
                  NoteField(
                    controller: noteController,
                    hintText: 'Add a note about this income...',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  BlocProvider.value(
                    value: widget.incomeCubit,
                    child: BlocConsumer<IncomeCubit, IncomeState>(
                      listener: (context, state) {
                        if (state is IncomeLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Income added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          });
                        }
                        if (state is IncomeError) {
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
                          label: 'Add Income',
                          color: Colors.green,
                          onPressed: isValid && state is! IncomeLoading
                              ? () {
                            final userId = _getUserId(context);
                            if (userId.isNotEmpty) {
                              context.read<IncomeCubit>().addIncome(
                                userId: userId,
                                amount: double.parse(amountController.text),
                                source: selectedSource!,
                                note: noteController.text,
                                date: selectedDate,
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