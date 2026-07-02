// presentation/cubits/expense_cubits/expense_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/services/notification_service.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final TransactionRepository _transactionRepository;
  final NotificationService _notificationService;
  StreamSubscription<List<ExpenseModel>>? _expensesSubscription;

  ExpenseCubit({
    required TransactionRepository transactionRepository,
    required NotificationService notificationService,
  })  : _transactionRepository = transactionRepository,
        _notificationService = notificationService,
        super(ExpenseInitial());

  void getExpenses(String userId, {DateTime? startDate, DateTime? endDate}) {
    if (userId.isEmpty) {
      emit(ExpenseError('User ID is empty'));
      return;
    }

    _expensesSubscription?.cancel();
    emit(ExpenseLoading());

    _expensesSubscription = _transactionRepository
        .getExpenses(userId, startDate: startDate, endDate: endDate)
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
    required double currentBalance,
  }) async {
    try {
      await _transactionRepository.addExpense(
        userId: userId,
        amount: amount,
        category: category,
        note: note,
        date: date,
      );

      // Trigger notifications after the write succeeds.
      final currentExpenses = state is ExpenseLoaded
          ? (state as ExpenseLoaded).expenses
          : <ExpenseModel>[];

      final newExpense = ExpenseModel(
        id: '',
        userId: userId,
        amount: amount,
        category: category,
        note: note,
        date: date,
        createdAt: DateTime.now(),
      );

      await _notificationService.onExpenseAdded(
        userId: userId,
        expense: newExpense,
        allExpenses: [...currentExpenses, newExpense],
        currentBalance: currentBalance,
      );
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