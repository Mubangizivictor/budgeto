// presentation/cubits/expense_cubits/expense_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/transaction_repository.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final TransactionRepository _transactionRepository;
  StreamSubscription<List<ExpenseModel>>? _expensesSubscription;

  ExpenseCubit({required TransactionRepository transactionRepository})
      : _transactionRepository = transactionRepository,
        super(ExpenseInitial());

  void getExpenses(String userId) {
    if (userId.isEmpty) {
      emit(ExpenseError('User ID is empty'));
      return;
    }

    // Cancel any previous subscription before creating a new one —
    // prevents stacked listeners and duplicate state emissions.
    _expensesSubscription?.cancel();
    emit(ExpenseLoading());

    _expensesSubscription = _transactionRepository
        .getExpenses(userId)
        .listen(
          (expenses) {
        if (!isClosed) {
          final total =
          expenses.fold(0.0, (sum, e) => sum + e.amount);
          emit(ExpenseLoaded(expenses: expenses, totalExpenses: total));
        }
      },
      onError: (error) {
        if (!isClosed) emit(ExpenseError(error.toString()));
      },
    );
  }

  Future<void> addExpense({
    required String userId,
    required double amount,
    required String category,
    required String note,
    required DateTime date,
  }) async {
    try {
      await _transactionRepository.addExpense(
        userId: userId,
        amount: amount,
        category: category,
        note: note,
        date: date,
      );
      // No manual refresh needed — the live Firestore stream emits the
      // updated list automatically once the write lands.
    } catch (e) {
      if (!isClosed) emit(ExpenseError(e.toString()));
    }
  }

  Future<void> deleteExpense(String expenseId, String userId) async {
    try {
      await _transactionRepository.deleteExpense(expenseId);
    } catch (e) {
      if (!isClosed) emit(ExpenseError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _expensesSubscription?.cancel();
    return super.close();
  }
}