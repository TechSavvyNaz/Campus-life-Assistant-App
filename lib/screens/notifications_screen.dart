import 'package:flutter/material.dart';
import 'package:campuslife_assistant/storage/notification_database.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    final notifications = await NotificationDatabase().getNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

  void _clearNotifications() async {
    await NotificationDatabase().clearNotifications();
    setState(() {
      _notifications = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearNotifications,
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return ListTile(
            title: Text(notification['title']),
            subtitle: Text(notification['body']),
            trailing: Text(notification['timestamp']),
          );
        },
      ),
    );
  }
}
