// data/datasources/notification_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';

class NotificationDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Notifications ─────────────────────────────────────────────────────────

  /// Real-time stream of all notifications for [userId], newest first.
  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => NotificationModel.fromFirestore(doc, null))
        .toList());
  }

  Future<void> addNotification(
      String userId, NotificationModel notification) async {
    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc();
    await ref.set(notification.copyWith(id: ref.id).toFirestore());
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> deleteNotification(
      String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> deleteAllNotifications(String userId) async {
    final batch = _firestore.batch();
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  Stream<NotificationSettingsModel> streamSettings(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return NotificationSettingsModel.fromFirestore(doc, null);
      }
      return const NotificationSettingsModel();
    });
  }

  Future<NotificationSettingsModel> getSettings(String userId) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .get();
    if (doc.exists) {
      return NotificationSettingsModel.fromFirestore(doc, null);
    }
    return const NotificationSettingsModel();
  }

  Future<void> saveSettings(
      String userId, NotificationSettingsModel settings) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('notifications')
        .set(settings.toFirestore(), SetOptions(merge: true));
  }
}