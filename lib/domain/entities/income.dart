// domain/entities/income.dart
class Income {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  const Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.note,
    required this.date,
    required this.createdAt,
  });
}