// presentation/cubits/income_cubit/income_state.dart
part of 'income_cubit.dart';

abstract class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object?> get props => [];
}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<IncomeModel> income;
  final double totalIncome;

  const IncomeLoaded({
    required this.income,
    required this.totalIncome,
  });

  @override
  List<Object?> get props => [income, totalIncome];
}

class IncomeError extends IncomeState {
  final String message;

  const IncomeError(this.message);

  @override
  List<Object?> get props => [message];
}