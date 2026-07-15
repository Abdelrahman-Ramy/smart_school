import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/routing/app_navigator.dart';
import 'package:smart_school/features/notifications/data/notification_navigation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationPushService {
  NotificationPushService._();

  static final NotificationPushService instance = NotificationPushService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StreamSubscription<String>? _tokenRefreshSubscription;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'smart_school_chat_notifications',
        'Smart School Notifications',
        description: 'Push notifications for chat and school updates',
        importance: Importance.high,
      );

  Future<void> bootstrap() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _configureLocalNotifications();

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleMessageTap(initialMessage);
    }

    await syncCurrentUserToken();
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalNotifications() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;

        final data = Map<String, dynamic>.from(jsonDecode(payload));
        NotificationNavigation.openFromNotificationPayload(
          AppNavigator.navigatorKey,
          data,
        );
      },
    );

    final androidPlugin = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  Future<void> syncCurrentUserToken() async {
    final userId = PrefHelper.getUserId();
    if (userId == null || userId.isEmpty) return;

    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) return;

    await _saveToken(userId, token);

    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((newToken) {
      _saveToken(userId, newToken);
    });
  }

  Future<void> _saveToken(String userId, String token) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'smart_school_chat_notifications',
      'Smart School Notifications',
      channelDescription: 'Push notifications for chat and school updates',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails();

    final payload = jsonEncode(message.data);

    await _localNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    await NotificationNavigation.openFromNotificationPayload(
      AppNavigator.navigatorKey,
      message.data,
    );
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
  }
}
