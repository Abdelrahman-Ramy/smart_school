class AssignmentModel {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final Map<String, dynamic>? classData;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.classData,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    // Support response shape: { success: true, data: { assignment: { ... } } }
    final map = json['data'] is Map && json['data']['assignment'] != null
        ? json['data']['assignment'] as Map<String, dynamic>
        : (json['assignment'] is Map
              ? json['assignment'] as Map<String, dynamic>
              : json);

    return AssignmentModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['due_date'] ?? map['dueDate'] ?? '',
      classData: map['class'] as Map<String, dynamic>?,
    );
  }
}
