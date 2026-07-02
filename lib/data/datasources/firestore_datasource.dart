// data/datasources/firestore_datasource.dart
// ignore_for_file: avoid_types_as_parameter_names

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

  Future<void> updateUserBalance(String userId, double newBalance) async {
    await _firestore.collection('users').doc(userId).update({
      'totalBalance': newBalance,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserFullName(String userId, String fullName) async {
    await _firestore.collection('users').doc(userId).update({
      'fullName': fullName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserPhotoUrl(String userId, String photoUrl) async {
    await _firestore.collection('users').doc(userId).update({
      'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes the user document, all their expenses, all their income,
  /// and all their notifications in Firestore.
  /// Call this BEFORE deleting the Firebase Auth account so the user
  /// is still authenticated for the Firestore security rules.
  Future<void> deleteAllUserData(String userId) async {
    // Firestore batch limit is 500 ops. For most users this is fine.
    // If you expect >400 transactions, paginate the deletes.
    final batch = _firestore.batch();

    // 1. User document
    batch.delete(_firestore.collection('users').doc(userId));

    // 2. Expenses
    final expenses = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in expenses.docs) {
      batch.delete(doc.reference);
    }

    // 3. Income
    final income = await _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in income.docs) {
      batch.delete(doc.reference);
    }

    // 4. Notifications subcollection
    final notifications = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();
    for (final doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    // 5. Settings subcollection
    final settings = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .get();
    for (final doc in settings.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ============ EXPENSES ============
  Future<void> addExpense(ExpenseModel expense) async {
    final docRef = _firestore.collection('expenses').doc();
    final expenseWithId = expense.copyWith(id: docRef.id);
    await docRef.set(expenseWithId.toFirestore());
  }

  Future<void> addMultipleExpenses(List<ExpenseModel> expenses) async {
    final batch = _firestore.batch();
    for (final expense in expenses) {
      final docRef = _firestore.collection('expenses').doc();
      final expenseWithId = expense.copyWith(id: docRef.id);
      batch.set(docRef, expenseWithId.toFirestore());
    }
    await batch.commit();
  }

  Stream<List<ExpenseModel>> getExpenses(String userId, {int? limit}) {
    var query = _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      final expenses = snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc, null))
          .toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return expenses;
    });
  }

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
        .map((snapshot) => snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc, null))
        .toList());
  }

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
        .map((snapshot) => snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc, null))
        .toList());
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    await _firestore
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toFirestore());
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
  }

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

  Stream<List<IncomeModel>> getIncome(String userId) {
    return _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final income = snapshot.docs
          .map((doc) => IncomeModel.fromFirestore(doc, null))
          .toList();
      income.sort((a, b) => b.date.compareTo(a.date));
      return income;
    });
  }

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
        .map((snapshot) => snapshot.docs
        .map((doc) => IncomeModel.fromFirestore(doc, null))
        .toList());
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

  // ============ AGGREGATION ============
  Future<double> getTotalExpenses(String userId) async {
    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.fold<double>(0.0, (sum, doc) {
      final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });
  }

  Future<double> getTotalIncome(String userId) async {
    final snapshot = await _firestore
        .collection('income')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.fold<double>(0.0, (sum, doc) {
      final amount = (doc.data()['amount'] as num?)?.toDouble() ?? 0.0;
      return sum + amount;
    });
  }
}