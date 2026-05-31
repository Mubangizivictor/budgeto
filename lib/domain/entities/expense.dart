// domain/entities/expense.dart
class Expense {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });
}