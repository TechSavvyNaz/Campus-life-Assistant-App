
import 'package:timezone/timezone.dart';
class StudyPlan {
  final String id; // Unique ID for the study plan
  final String title; // Title of the study plan
  final String description; // Description or goal of the study plan
  final DateTime startDate; // Start date of the study plan
  final DateTime endDate; // End date of the study plan
  final List<String> subjects; // List of subjects or topics to cover
  final bool isCompleted; // Status of the study plan

  // Constructor
  StudyPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.subjects,
    this.isCompleted = false, // Defaults to false
  });

  // Factory method to create a StudyPlan from Firestore document
  factory StudyPlan.fromFirestore(Map<String, dynamic> data, String id) {
    return StudyPlan(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      subjects: List<String>.from(data['subjects'] ?? []),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // Convert StudyPlan to Firestore document format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'subjects': subjects,
      'isCompleted': isCompleted,
    };
  }
}

class Timestamp {
  toDate() {}
}
