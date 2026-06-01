// presentation/cubits/notification_cubit/notification_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/notification_model.dart';
import '../../../../data/models/notification_settings_model.dart';
import '../../../../data/repositories/notification_repository.dart';


part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;
  StreamSubscription<NotificationSettingsModel>? _settingsSubscription;

  NotificationCubit({required NotificationRepository repository})
      : _repository = repository,
        super(NotificationInitial());

  void init(String userId) {
    if (userId.isEmpty) return;

    _notificationsSubscription?.cancel();
    _settingsSubscription?.cancel();

    emit(NotificationLoading());

    _notificationsSubscription =
        _repository.streamNotifications(userId).listen(
              (notifications) {
            if (!isClosed) {
              final currentSettings = state is NotificationLoaded
                  ? (state as NotificationLoaded).settings
                  : const NotificationSettingsModel();
              emit(NotificationLoaded(
                notifications: notifications,
                settings: currentSettings,
              ));
            }
          },
          onError: (e) {
            if (!isClosed) emit(NotificationError(e.toString()));
          },
        );

    _settingsSubscription =
        _repository.streamSettings(userId).listen(
              (settings) {
            if (!isClosed) {
              final currentNotifications = state is NotificationLoaded
                  ? (state as NotificationLoaded).notifications
                  : <NotificationModel>[];
              emit(NotificationLoaded(
                notifications: currentNotifications,
                settings: settings,
              ));
            }
          },
          onError: (_) {}, // settings errors are non-fatal
        );
  }

  Future<void> markAsRead(String userId, String notificationId) async {
    try {
      await _repository.markAsRead(userId, notificationId);
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllAsRead(String userId) async {
    try {
      await _repository.markAllAsRead(userId);
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteNotification(
      String userId, String notificationId) async {
    try {
      await _repository.deleteNotification(userId, notificationId);
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> deleteAll(String userId) async {
    try {
      await _repository.deleteAllNotifications(userId);
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  Future<void> saveSettings(
      String userId, NotificationSettingsModel settings) async {
    try {
      await _repository.saveSettings(userId, settings);
    } catch (e) {
      if (!isClosed) emit(NotificationError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _notificationsSubscription?.cancel();
    await _settingsSubscription?.cancel();
    return super.close();
  }
}