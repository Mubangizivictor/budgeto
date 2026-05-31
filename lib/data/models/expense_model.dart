// data/models/expense_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/expense.dart';

class ExpenseModel extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });

  // ✅ From Firestore
  factory ExpenseModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      SnapshotOptions? options,
      ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Expense data is null');
    }

    return ExpenseModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      category: data['category'] as String? ?? '',
      note: data['note'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ✅ From JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      note: json['note'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // ✅ To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'amount': amount,
      'category': category,
      'note': note,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ✅ CopyWith
  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ✅ To Entity
  Expense toEntity() {
    return Expense(
      id: id,
      userId: userId,
      amount: amount,
      category: category,
      note: note,
      date: date,
      createdAt: createdAt,
    );
  }

  // ✅ From Entity
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      userId: expense.userId,
      amount: expense.amount,
      category: expense.category,
      note: expense.note,
      date: expense.date,
      createdAt: expense.createdAt,
    );
  }

  // ✅ Empty instance (FIXED - no null values)
  static ExpenseModel empty() {
    return ExpenseModel(
      id: '',
      userId: '',
      amount: 0,
      category: '',
      note: '',
      date: DateTime(1970), // Use a default date instead of null
      createdAt: DateTime(1970),
    );
  }

  // ✅ Helper to check if empty
  bool get isEmpty =>
      id == '' &&
          userId == '' &&
          amount == 0 &&
          category == '' &&
          note == '';

  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [id, userId, amount, category, note, date, createdAt];
}