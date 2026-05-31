// domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String fullName;
  final DateTime createdAt;
  final double totalBalance;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.createdAt,
    required this.totalBalance,
  });
}