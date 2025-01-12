import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TodayScreen extends StatelessWidget {
  final List<Map<String, dynamic>> classes;

  // Constructor expects a list of classes
  TodayScreen({required this.classes});

  String _formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');
    return '${dateFormat.format(dateTime)} at ${timeFormat.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Today\'s Classes'),
        backgroundColor: Color(0xFF1765ED),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: classes.isEmpty
            ? Center(child: Text('No classes for today!'))
            : ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final schedule = classes[index];
            DateTime scheduleDateTime = DateTime.parse(schedule['dateTime']);
            return Card(
              child: ListTile(
                title: Text(schedule['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${schedule['room']}'),
                    Text(
                      _formatDateTime(scheduleDateTime),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

    );
  }
}
