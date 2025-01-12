class Assignment {
  final String? id; // Firestore document ID
  final String title;
  final String description;
  final DateTime? timestamp;

  Assignment({
    this.id,
    required this.title,
    required this.description,
    this.timestamp,
  });

  // Convert Firestore document to Assignment object
  factory Assignment.fromFirestore(Map<String, dynamic> data, String id) {
    return Assignment(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      timestamp: data['timestamp']?.toDate(),
    );
  }

  // Convert Assignment object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp,
    };
  }
}
