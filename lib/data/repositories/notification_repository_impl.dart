// data/repositories/notification_repository_impl.dart
import '../datasources/notification_datasource.dart';
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;

  NotificationRepositoryImpl({required NotificationDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Stream<List<NotificationModel>> streamNotifications(String userId) =>
      _dataSource.streamNotifications(userId);

  @override
  Future<void> addNotification(
      String userId, NotificationModel notification) =>
      _dataSource.addNotification(userId, notification);

  @override
  Future<void> markAsRead(String userId, String notificationId) =>
      _dataSource.markAsRead(userId, notificationId);

  @override
  Future<void> markAllAsRead(String userId) =>
      _dataSource.markAllAsRead(userId);

  @override
  Future<void> deleteNotification(String userId, String notificationId) =>
      _dataSource.deleteNotification(userId, notificationId);

  @override
  Future<void> deleteAllNotifications(String userId) =>
      _dataSource.deleteAllNotifications(userId);

  @override
  Stream<NotificationSettingsModel> streamSettings(String userId) =>
      _dataSource.streamSettings(userId);

  @override
  Future<NotificationSettingsModel> getSettings(String userId) =>
      _dataSource.getSettings(userId);

  @override
  Future<void> saveSettings(
      String userId, NotificationSettingsModel settings) =>
      _dataSource.saveSettings(userId, settings);
}