// presentation/cubits/expense_cubits/expense_state.dart
part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<ExpenseModel> expenses;
  final double totalExpenses;

  const ExpenseLoaded({
    required this.expenses,
    required this.totalExpenses,
  });

  @override
  List<Object?> get props => [expenses, totalExpenses];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}