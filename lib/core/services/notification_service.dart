// core/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../data/models/expense_model.dart';
import '../../data/models/income_model.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _repository;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Budget limits per category (can be made user-configurable later).
  static const Map<String, double> _categoryBudgets = {
    'food': 350,
    'shopping': 400,
    'entertainment': 200,
    'transport': 150,
    'health': 300,
    'education': 500,
    'bills': 600,
    'other': 200,
  };

  NotificationService({required NotificationRepository repository})
      : _repository = repository;

  /// Call once at app start to request FCM permission and store the token.
  Future<void> init() async {
    await _fcm.requestPermission();
  }

  // ── Transaction added ────────────────────────────────────────────────────

  Future<void> onExpenseAdded({
    required String userId,
    required ExpenseModel expense,
    required List<ExpenseModel> allExpenses,
    required double currentBalance,
  }) async {
    final settings = await _repository.getSettings(userId);

    if (settings.transactionAdded) {
      await _addNotification(
        userId: userId,
        title: 'Expense Added',
        body:
        '\$${expense.amount.toStringAsFixed(2)} spent on ${expense.category}.',
        type: NotificationType.transactionAdded,
        metadata: {'expenseId': expense.id, 'category': expense.category},
      );
    }

    if (settings.budgetWarnings) {
      await _checkBudgetWarning(
          userId: userId, expense: expense, allExpenses: allExpenses);
    }

    if (settings.lowBalance) {
      await _checkLowBalance(
          userId: userId,
          balance: currentBalance,
          threshold: settings.lowBalanceThreshold);
    }
  }

  Future<void> onIncomeAdded({
    required String userId,
    required IncomeModel income,
  }) async {
    final settings = await _repository.getSettings(userId);
    if (!settings.transactionAdded) return;

    await _addNotification(
      userId: userId,
      title: 'Income Added',
      body:
      '\$${income.amount.toStringAsFixed(2)} received from ${income.source}.',
      type: NotificationType.transactionAdded,
      metadata: {'incomeId': income.id, 'source': income.source},
    );
  }

  // ── Budget warning ────────────────────────────────────────────────────────

  Future<void> _checkBudgetWarning({
    required String userId,
    required ExpenseModel expense,
    required List<ExpenseModel> allExpenses,
  }) async {
    final category = expense.category.toLowerCase();
    final limit = _categoryBudgets[category];
    if (limit == null) return;

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    // Total spent in this category this month (including the new expense).
    final monthlyTotal = allExpenses
        .where((e) =>
    e.category.toLowerCase() == category &&
        !e.date.isBefore(monthStart))
        .fold(0.0, (sum, e) => sum + e.amount);

    final percentage = (monthlyTotal / limit * 100).round();

    if (percentage >= 100) {
      await _addNotification(
        userId: userId,
        title: '${_capitalize(expense.category)} Budget Exceeded!',
        body:
        'You\'ve exceeded your \$${limit.toStringAsFixed(0)} ${expense.category} budget this month.',
        type: NotificationType.budgetWarning,
        metadata: {
          'category': expense.category,
          'percentage': percentage,
          'limit': limit,
        },
      );
    } else if (percentage >= 80) {
      await _addNotification(
        userId: userId,
        title: '${_capitalize(expense.category)} Budget Warning',
        body:
        'You\'ve used $percentage% of your \$${limit.toStringAsFixed(0)} ${expense.category} budget.',
        type: NotificationType.budgetWarning,
        metadata: {
          'category': expense.category,
          'percentage': percentage,
          'limit': limit,
        },
      );
    }
  }

  // ── Low balance ───────────────────────────────────────────────────────────

  Future<void> _checkLowBalance({
    required String userId,
    required double balance,
    required double threshold,
  }) async {
    if (balance <= threshold) {
      await _addNotification(
        userId: userId,
        title: 'Low Balance Alert',
        body:
        'Your balance is \$${balance.toStringAsFixed(2)}, which is below your \$${threshold.toStringAsFixed(0)} threshold.',
        type: NotificationType.lowBalance,
        metadata: {'balance': balance, 'threshold': threshold},
      );
    }
  }

  // ── Summary ───────────────────────────────────────────────────────────────

  Future<void> sendWeeklySummary({
    required String userId,
    required double totalIncome,
    required double totalExpenses,
  }) async {
    final settings = await _repository.getSettings(userId);
    if (!settings.weeklySummary) return;

    final net = totalIncome - totalExpenses;
    await _addNotification(
      userId: userId,
      title: 'Weekly Summary',
      body:
      'This week: +\$${totalIncome.toStringAsFixed(2)} in, -\$${totalExpenses.toStringAsFixed(2)} out. Net: ${net >= 0 ? '+' : ''}\$${net.toStringAsFixed(2)}.',
      type: NotificationType.weeklySummary,
      metadata: {
        'income': totalIncome,
        'expenses': totalExpenses,
        'net': net,
      },
    );
  }

  Future<void> sendMonthlySummary({
    required String userId,
    required double totalIncome,
    required double totalExpenses,
  }) async {
    final settings = await _repository.getSettings(userId);
    if (!settings.monthlySummary) return;

    final net = totalIncome - totalExpenses;
    await _addNotification(
      userId: userId,
      title: 'Monthly Summary',
      body:
      'This month: +\$${totalIncome.toStringAsFixed(2)} in, -\$${totalExpenses.toStringAsFixed(2)} out. Net: ${net >= 0 ? '+' : ''}\$${net.toStringAsFixed(2)}.',
      type: NotificationType.monthlySummary,
      metadata: {
        'income': totalIncome,
        'expenses': totalExpenses,
        'net': net,
      },
    );
  }

  // ── Internal helper ───────────────────────────────────────────────────────

  Future<void> _addNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic> metadata = const {},
  }) async {
    final notification = NotificationModel(
      id: '',
      userId: userId,
      title: title,
      body: body,
      type: type,
      isRead: false,
      createdAt: DateTime.now(),
      metadata: metadata,
    );
    await _repository.addNotification(userId, notification);
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}