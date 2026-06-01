// data/repositories/notification_repository.dart
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';

abstract class NotificationRepository {
  Stream<List<NotificationModel>> streamNotifications(String userId);
  Future<void> addNotification(String userId, NotificationModel notification);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String userId, String notificationId);
  Future<void> deleteAllNotifications(String userId);

  Stream<NotificationSettingsModel> streamSettings(String userId);
  Future<NotificationSettingsModel> getSettings(String userId);
  Future<void> saveSettings(String userId, NotificationSettingsModel settings);
}