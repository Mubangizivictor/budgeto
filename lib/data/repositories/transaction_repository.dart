// domain/repositories/transaction_repository.dart
import '../../data/models/expense_model.dart';
import '../../data/models/income_model.dart';

abstract class TransactionRepository {
  // ============ EXPENSES ============
  Future<void> addExpense({
    required String userId,
    required double amount,
    required String category,
    required String note,
    required DateTime date,
  });

  Stream<List<ExpenseModel>> getExpenses(String userId);

  Future<void> deleteExpense(String expenseId);

  Future<double> getTotalExpenses(String userId);

  // ============ INCOME ============
  Future<void> addIncome({
    required String userId,
    required double amount,
    required String source,
    required String note,
    required DateTime date,
  });

  Stream<List<IncomeModel>> getIncome(String userId);

  Future<void> deleteIncome(String incomeId);

  Future<double> getTotalIncome(String userId);
}