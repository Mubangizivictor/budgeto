// data/models/export_model.dart
import '../../data/models/expense_model.dart';
import '../../data/models/income_model.dart';

class ExportRequest {
  final DateTime startDate;
  final DateTime endDate;
  final List<ExpenseModel> expenses;
  final List<IncomeModel> income;
  final String userName;
  final String userEmail;

  const ExportRequest({
    required this.startDate,
    required this.endDate,
    required this.expenses,
    required this.income,
    required this.userName,
    required this.userEmail,
  });

  double get totalExpenses =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  double get totalIncome =>
      income.fold(0.0, (sum, i) => sum + i.amount);

  double get netBalance => totalIncome - totalExpenses;
}