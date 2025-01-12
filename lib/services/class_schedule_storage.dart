import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // To convert objects to/from JSON
import '../model/class_schedule.dart'; // Import the class schedule model

class ClassScheduleStorage {
  static const String _classScheduleKey = 'class_schedule';

  // Save the class schedule to local storage
  static Future<void> saveSchedule(List<ClassSchedule> schedules) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> schedulesJson = schedules.map((schedule) {
      final scheduleMap = schedule.toMap();
      return json.encode(scheduleMap);
    }).toList();
    await prefs.setStringList(_classScheduleKey, schedulesJson);
  }

  // Load the class schedule from local storage
  static Future<List<ClassSchedule>> loadSchedule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? schedulesJson = prefs.getStringList(_classScheduleKey);

    if (schedulesJson != null) {
      return schedulesJson.map((scheduleJson) {
        final Map<String, dynamic> scheduleMap = json.decode(scheduleJson);

        // You need to ensure you pass the ID as well
        // If you stored the ID within the map, you can extract it
        final id = scheduleMap['id'] ?? 'generated_id_${DateTime.now().millisecondsSinceEpoch}';

        return ClassSchedule.fromMap(scheduleMap, id);
      }).toList();
    } else {
      return [];
    }
  }

  // Remove the class schedule from local storage
  static Future<void> clearSchedule() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_classScheduleKey);
  }
}
