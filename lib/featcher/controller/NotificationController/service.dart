import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:justtsham/core/utils/app_icons.dart';

import 'notification_controller.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _requestPermission();
    await _initLocalNotification();
    await _setupListeners();
    await _getToken();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission: ${settings.authorizationStatus}");
  }

  Future<void> _initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification Clicked: ${response.payload}");
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'channel_id',
        'channel_name',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _setupListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground Message: ${message.notification?.title}");
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked (background)");
      _handleNavigation(message);
    });

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("Opened from terminated");
      _handleNavigation(initialMessage);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("New Token: $newToken");

      if (Get.isRegistered<NotificationController>()) {
        Get.find<NotificationController>().updateToken(newToken);
      }
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: 0,
      title:message.notification?.title ?? "No Title",
      body:message.notification?.body ?? "No Body",
      notificationDetails :details,
      payload: message.data.toString(),
    );
  }
  String getToken = "";

  Future<void> _getToken() async {
    String? token = await _messaging.getToken();

    if (token != null && token.isNotEmpty) {
      getToken = token;
      debugPrint("[FCM]: $getToken");
    }
  }

  void _handleNavigation(RemoteMessage message) {
    final type = message.data['type'];
    final id = message.data['id'];

  }
}