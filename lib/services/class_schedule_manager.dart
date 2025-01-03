// lib/services/class_schedule_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/class_schedule.dart';

class ClassScheduleManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Database _database;

  // Initialize SQFlite Database
  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'class_schedule.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE schedules(
            id TEXT PRIMARY KEY,
            name TEXT,
            time TEXT,
            room TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Fetch schedules from Firestore
  Stream<List<ClassSchedule>> getSchedules() {
    return _firestore.collection('classSchedules').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        // Pass the doc.id to the ClassSchedule constructor
        return ClassSchedule.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add schedule to Firestore and SQFlite
  Future<void> addSchedule(ClassSchedule schedule) async {
    await _firestore.collection('classSchedules').add(schedule.toMap());

    await _database.insert(
      'schedules',
      schedule.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Edit schedule in Firestore and SQFlite
  Future<void> editSchedule(ClassSchedule schedule) async {
    await _firestore
        .collection('classSchedules')
        .doc(schedule.id)
        .update(schedule.toMap());

    await _database.update(
      'schedules',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  // Delete schedule from Firestore and SQFlite
  Future<void> deleteSchedule(String id) async {
    await _firestore.collection('classSchedules').doc(id).delete();

    await _database.delete(
      'schedules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
