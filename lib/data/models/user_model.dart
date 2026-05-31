// data/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final DateTime createdAt;
  final double totalBalance;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.createdAt,
    this.totalBalance = 0.0,
  });

  // ✅ From Firestore (with proper error handling)
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      SnapshotOptions? options,
      ) {
    final data = doc.data();
    if (data == null) {
      throw Exception('User data is null');
    }

    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalBalance: (data['totalBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // ✅ From JSON (for local storage/caching)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalBalance: (json['totalBalance'] as num).toDouble(),
    );
  }

  // ✅ To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalBalance': totalBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // ✅ To JSON (for local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'createdAt': createdAt.toIso8601String(),
      'totalBalance': totalBalance,
    };
  }

  // ✅ CopyWith (for updating)
  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    DateTime? createdAt,
    double? totalBalance,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  // ✅ To Entity (Domain)
  User toEntity() {
    return User(
      id: id,
      email: email,
      fullName: fullName,
      createdAt: createdAt,
      totalBalance: totalBalance,
    );
  }

  // ✅ From Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      createdAt: user.createdAt,
      totalBalance: user.totalBalance,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, createdAt, totalBalance];
}