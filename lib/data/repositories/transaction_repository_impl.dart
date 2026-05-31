// data/repositories/transaction_repository_impl.dart
import 'package:budgeto/data/repositories/transaction_repository.dart';

import '../datasources/firestore_datasource.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final FirestoreDataSource _firestoreDataSource;

  TransactionRepositoryImpl({
    required FirestoreDataSource firestoreDataSource,
  }) : _firestoreDataSource = firestoreDataSource;

  // ============ EXPENSES ============
  @override
  Future<void> addExpense({
    required String userId,
    required double amount,
    required String category,
    required String note,
    required DateTime date,
  }) async {
    final expense = ExpenseModel(
      id: '', // Will be set in addExpense method
      userId: userId,
      amount: amount,
      category: category,
      note: note,
      date: date,
      createdAt: DateTime.now(),
    );
    await _firestoreDataSource.addExpense(expense);
  }

  @override
  Stream<List<ExpenseModel>> getExpenses(String userId) {
    return _firestoreDataSource.getExpenses(userId);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _firestoreDataSource.deleteExpense(expenseId);
  }

  // ============ INCOME ============
  @override
  Future<void> addIncome({
    required String userId,
    required double amount,
    required String source,
    required String note,
    required DateTime date,
  }) async {
    final income = IncomeModel(
      id: '', // Will be set in addIncome method
      userId: userId,
      amount: amount,
      source: source,
      note: note,
      date: date,
      createdAt: DateTime.now(),
    );
    await _firestoreDataSource.addIncome(income);
  }

  @override
  Stream<List<IncomeModel>> getIncome(String userId) {
    return _firestoreDataSource.getIncome(userId);
  }

  @override
  Future<void> deleteIncome(String incomeId) async {
    await _firestoreDataSource.deleteIncome(incomeId);
  }

  // ============ TOTALS ============
  @override
  Future<double> getTotalExpenses(String userId) async {
    return await _firestoreDataSource.getTotalExpenses(userId);
  }

  @override
  Future<double> getTotalIncome(String userId) async {
    return await _firestoreDataSource.getTotalIncome(userId);
  }
}