import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:intl/intl.dart';

class ScheduleNotification {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static Future<void> init() async {
    tz.initializeTimeZones(); // Initialize timezone
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  static Future<void> showScheduleNotification(
      String title, String description, DateTime scheduleDateTime) async {
    final String formattedDateTime =
    DateFormat('yyyy-MM-dd HH:mm').format(scheduleDateTime);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'schedule_channel_id',
      'Schedule Notifications',
      channelDescription: 'Channel for schedule notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      '$description\nScheduled for: $formattedDateTime',
      platformChannelSpecifics,
      payload: 'schedule_notification_payload',
    );
  }

  // Method to schedule a notification at a specific time
  static Future<void> scheduleNotificationAtDateTime(
      String title, String description, DateTime scheduleDateTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'schedule_channel_id',
      'Schedule Notifications',
      channelDescription: 'Channel for schedule notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Convert DateTime to TZDateTime
    final tz.TZDateTime tzDateTime =
    tz.TZDateTime.from(scheduleDateTime, tz.local);

    // Log the scheduled time
    print('Scheduled for: $tzDateTime');

    // Schedule the notification using TZDateTime
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      description,
      tzDateTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
