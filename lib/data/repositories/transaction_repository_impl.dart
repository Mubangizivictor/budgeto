// data/repositories/transaction_repository_impl.dart
import '../../core/local_storage/hive_service.dart';
import 'transaction_repository.dart';
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
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID for local
      userId: userId,
      amount: amount,
      category: category,
      note: note,
      date: date,
      createdAt: DateTime.now(),
    );
    
    // I'm saving locally first for that snappy offline feel
    await HiveService.saveData(HiveService.expenseBox, expense.id, expense.toJson());
    
    // Then I'll try to sync with Firestore
    await _firestoreDataSource.addExpense(expense);
  }

  @override
  Stream<List<ExpenseModel>> getExpenses(String userId, {DateTime? startDate, DateTime? endDate}) {
    // I should probably merge local and remote data here later
    if (startDate != null && endDate != null) {
      return _firestoreDataSource.getExpensesByDateRange(userId, startDate, endDate);
    }
    return _firestoreDataSource.getExpenses(userId);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    // Removing from both places to keep them in sync
    await HiveService.deleteData(HiveService.expenseBox, expenseId);
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
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      amount: amount,
      source: source,
      note: note,
      date: date,
      createdAt: DateTime.now(),
    );

    await HiveService.saveData(HiveService.incomeBox, income.id, income.toJson());
    await _firestoreDataSource.addIncome(income);
  }

  @override
  Stream<List<IncomeModel>> getIncome(String userId, {DateTime? startDate, DateTime? endDate}) {
    if (startDate != null && endDate != null) {
      return _firestoreDataSource.getIncomeByDateRange(userId, startDate, endDate);
    }
    return _firestoreDataSource.getIncome(userId);
  }

  @override
  Future<void> deleteIncome(String incomeId) async {
    await HiveService.deleteData(HiveService.incomeBox, incomeId);
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
