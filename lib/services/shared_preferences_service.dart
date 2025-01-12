import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  // Save a schedule locally
  Future<void> saveSchedule(String key, Map<String, dynamic> schedule) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonSchedule = json.encode(schedule);
    await prefs.setString(key, jsonSchedule);
  }

  // Retrieve a schedule locally
  Future<Map<String, dynamic>?> getSchedule(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonSchedule = prefs.getString(key);
    return jsonSchedule != null ? json.decode(jsonSchedule) : null;
  }

  // Clear all schedules
  Future<void> clearSchedules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
