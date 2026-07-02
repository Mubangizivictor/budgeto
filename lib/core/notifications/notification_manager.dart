// core/notifications/notification_manager.dart
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/datasources/firestore_datasource.dart';

class NotificationManager {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirestoreDataSource _firestoreDataSource;

  NotificationManager({required FirestoreDataSource firestoreDataSource})
      : _firestoreDataSource = firestoreDataSource;

  // Initialize notifications for the app
  Future<void> init() async {
    // Configure local notifications first so _showLocalNotification is
    // ready before any FCM message can arrive.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Request permission from the user
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // User granted permission, now let's get the token and save it so
      // targeted/server-side push notifications can reach this device.
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenForCurrentUser(token);
      }
    }

    // Keep the saved token current if it rotates.
    _fcm.onTokenRefresh.listen(_saveTokenForCurrentUser);

    // Listen for incoming messages while the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  Future<void> _saveTokenForCurrentUser(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      log('No signed-in user yet; FCM token not persisted.');
      return;
    }
    try {
      await _firestoreDataSource.updateFcmToken(userId, token);
    } catch (e) {
      log('Failed to persist FCM token: $e');
    }
  }

  // Shows a heads-up notification. Used both for real FCM pushes and for
  // in-app events (budget warnings, low balance, etc.) that want an
  // immediate local banner.
  Future<void> showLocalNotification({
    required String title,
    required String body,
    int? id,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'budgeto_main_channel',
      'Main Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
      title,
      body,
      details,
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    await showLocalNotification(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      id: message.hashCode,
    );
  }
}
