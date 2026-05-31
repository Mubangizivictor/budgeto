// data/datasources/firestore_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';
import '../models/income_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ USERS ============
  Future<void> saveUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toFirestore(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc, null);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Real-time user stream
  Stream<UserModel?> streamUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc, null);
      }
      return null;
    });
  }

  // Update user balance
  Future<void> updateUserBalance(String userId, double newBalance) async {
    await _firestore.collection('users').doc(userId).update({
      'totalBalance': newBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============ EXPENSES ============
  Future<void> addExpense(ExpenseModel expense) async {
    final docRef = _firestore.collection('expenses').doc();
    final expenseWithId = expense.copyWith(id: docRef.id);
    await docRef.set(expenseWithId.toFirestore());
  }

  // Batch add multiple expenses
  Future<void> addMultipleExpenses(List<ExpenseModel> expenses) async {
    final batch = _firestore.batch();

    for (final expense in expenses) {
      final docRef = _firestore.collection('expenses').doc();
      final expenseWithId = expense.copyWith(id: docRef.id);
      batch.set(docRef, expenseWithId.toFirestore());
    }

    await batch.commit();
  }

  // Real-time expenses stream with query (FIXED - removed orderBy)
  Stream<List<ExpenseModel>> getExpenses(String userId, {int? limit}) {
    var query = _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId);

    // REMOVED .orderBy('date', descending: true) to avoid index requirement

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      final expenses = snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc, null))
          .toList();
      // Sort in memory instead
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    });
  }

  // Get expenses by date range
  Stream<List<ExpenseModel>> getExpensesByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc, null))
          .toList();
    });
  }

  // Get expenses by category
  Stream<List<ExpenseModel>> getExpensesByCategory(
      String userId,
      String category,
      ) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc, null))
          .toList();
    });
  }

  // Update expense
  Future<void> updateExpense(ExpenseModel expense) async {
    await _firestore
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toFirestore());
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
  }

  // Delete multiple expenses (batch)
  Future<void> deleteMultipleExpenses(List<String> expenseIds) async {
    final batch = _firestore.batch();

    for (final id in expenseIds) {
      batch.delete(_firestore.collection('expenses').doc(id));
    }

    await batch.commit();
  }

  // ============ INCOME ============
  Future<void> addIncome(IncomeModel income) async {
    final docRef = _firestore.collection('income').doc();
    final incomeWithId = income.copyWith(id: docRef.id);
    await docRef.set(incomeWithId.toFirestore());
  }

  // Real-time income stream (FIXED - removed orderBy)
  Stream<List<IncomeModel>> getIncome(String userId) {
    var query = _firestore
        .collection('income')
        .where('userId', isEqualTo: userId);

    // REMOVED .orderBy('date', descending: true) to avoid index requirement

    return query.snapshots().map((snapshot) {
      final income = snapshot.docs
          .map((doc) => IncomeModel.fromFirestore(doc, null))
          .toList();
      // Sort in memory instead
      income.sort((a, b) => b.date.compareTo(a.date));
      return income;
    });
  }

  // Get income by date range
  Stream<List<IncomeModel>> getIncomeByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) {
    return _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => IncomeModel.fromFirestore(doc, null))
          .toList();
    });
  }

  Future<void> updateIncome(IncomeModel income) async {
    await _firestore
        .collection('income')
        .doc(income.id)
        .update(income.toFirestore());
  }

  Future<void> deleteIncome(String incomeId) async {
    await _firestore.collection('income').doc(incomeId).delete();
  }

  // ============ AGGREGATION (For totals) ============
  Future<double> getTotalExpenses(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    double total = 0.0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      total = total + amount;
    }
    return total;
  }

  Future<double> getTotalIncome(String userId) async {
    final snapshot = await _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .get();

    double total = 0.0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      total = total + amount;
    }
    return total;
  }

  // Alternative using fold (with proper typing)
  Future<double> getTotalExpensesFold(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.fold<double>(0.0, (double sum, doc) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });
  }

  // Alternative for income using fold
  Future<double> getTotalIncomeFold(String userId) async {
    final snapshot = await _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.fold<double>(0.0, (double sum, doc) {
      final data = doc.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });
  }
}