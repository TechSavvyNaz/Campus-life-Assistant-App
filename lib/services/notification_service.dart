import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:campuslife_assistant/storage/notification_database.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Initialize local notifications
    const AndroidInitializationSettings androidInitialization =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: androidInitialization);
    await _localNotificationsPlugin.initialize(initializationSettings);

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      _showNotification(
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body');

      // Save notification locally
      NotificationDatabase().insertNotification({
        'title': message.notification?.title ?? 'No Title',
        'body': message.notification?.body ?? 'No Body',
        'timestamp': DateTime.now().toString(),
      });
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Main channel notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
    );
  }
}
