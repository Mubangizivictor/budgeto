// data/models/notification_settings_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class NotificationSettingsModel extends Equatable {
  final bool budgetWarnings;
  final bool transactionAdded;
  final bool weeklySummary;
  final bool monthlySummary;
  final bool lowBalance;
  final double lowBalanceThreshold;

  const NotificationSettingsModel({
    this.budgetWarnings = true,
    this.transactionAdded = true,
    this.weeklySummary = true,
    this.monthlySummary = true,
    this.lowBalance = true,
    this.lowBalanceThreshold = 100.0,
  });

  factory NotificationSettingsModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      SnapshotOptions? options,
      ) {
    final data = doc.data() ?? {};
    return NotificationSettingsModel(
      budgetWarnings: data['budgetWarnings'] as bool? ?? true,
      transactionAdded: data['transactionAdded'] as bool? ?? true,
      weeklySummary: data['weeklySummary'] as bool? ?? true,
      monthlySummary: data['monthlySummary'] as bool? ?? true,
      lowBalance: data['lowBalance'] as bool? ?? true,
      lowBalanceThreshold:
      (data['lowBalanceThreshold'] as num?)?.toDouble() ?? 100.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'budgetWarnings': budgetWarnings,
      'transactionAdded': transactionAdded,
      'weeklySummary': weeklySummary,
      'monthlySummary': monthlySummary,
      'lowBalance': lowBalance,
      'lowBalanceThreshold': lowBalanceThreshold,
    };
  }

  NotificationSettingsModel copyWith({
    bool? budgetWarnings,
    bool? transactionAdded,
    bool? weeklySummary,
    bool? monthlySummary,
    bool? lowBalance,
    double? lowBalanceThreshold,
  }) {
    return NotificationSettingsModel(
      budgetWarnings: budgetWarnings ?? this.budgetWarnings,
      transactionAdded: transactionAdded ?? this.transactionAdded,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      lowBalance: lowBalance ?? this.lowBalance,
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
    );
  }

  @override
  List<Object?> get props => [
    budgetWarnings,
    transactionAdded,
    weeklySummary,
    monthlySummary,
    lowBalance,
    lowBalanceThreshold,
  ];
}