// data/models/income_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/income.dart';

class IncomeModel extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String source;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  const IncomeModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.source,
    required this.note,
    required this.date,
    required this.createdAt,
  });

  // ✅ From Firestore
  factory IncomeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      SnapshotOptions? options,
      ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('Income data is null');
    }

    return IncomeModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      source: data['source'] as String? ?? '',
      note: data['note'] as String? ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ✅ From JSON
  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      source: json['source'] as String,
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
      'source': source,
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
      'source': source,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // ✅ CopyWith
  IncomeModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? source,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ✅ To Entity
  Income toEntity() {
    return Income(
      id: id,
      userId: userId,
      amount: amount,
      source: source,
      note: note,
      date: date,
      createdAt: createdAt,
    );
  }

  // ✅ From Entity
  factory IncomeModel.fromEntity(Income income) {
    return IncomeModel(
      id: income.id,
      userId: income.userId,
      amount: income.amount,
      source: income.source,
      note: income.note,
      date: income.date,
      createdAt: income.createdAt,
    );
  }

  // ✅ Empty instance (FIXED - no null values)
  static IncomeModel empty() {
    return IncomeModel(
      id: '',
      userId: '',
      amount: 0,
      source: '',
      note: '',
      date: DateTime(1970),
      createdAt: DateTime(1970),
    );
  }

  // ✅ Helper to check if empty
  bool get isEmpty =>
      id == '' &&
          userId == '' &&
          amount == 0 &&
          source == '' &&
          note == '';

  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [id, userId, amount, source, note, date, createdAt];
}