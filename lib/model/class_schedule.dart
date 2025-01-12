class ClassSchedule {
  final String id;
  final String name;
  final String time;
  final String professor;
  final String date;
  final List<String> days;
  final String room;

  ClassSchedule({
    required this.id,
    required this.name,
    required this.time,
    required this.professor,
    required this.date,
    required this.days,
    this.room = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'professor': professor,
      'date': date,
      'days': days.join(','), // Store days as a comma-separated string
      'room': room,
    };
  }

  factory ClassSchedule.fromMap(Map<String, dynamic> map, String id) {
    return ClassSchedule(
      id: id,
      name: map['name'],
      time: map['time'],
      professor: map['professor'],
      date: map['date'],
      days: (map['days'] as String).split(','), // Convert comma-separated string back to a list
      room: map['room'] ?? '',
    );
  }
}
