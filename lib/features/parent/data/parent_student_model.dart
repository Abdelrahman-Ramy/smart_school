class ParentStudentModel {
  final int id;
  final String studentCode;
  final String name;
  final String email;
  final String className;
  final String gradeLevel;
  final String? section;

  ParentStudentModel({
    required this.id,
    required this.studentCode,
    required this.name,
    required this.email,
    required this.className,
    required this.gradeLevel,
    required this.section,
  });

  factory ParentStudentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final classData = json['class'];

    return ParentStudentModel(
      id: json['id'] ?? 0,
      studentCode: json['student_id'] ?? '',
      name: user is Map ? user['name'] ?? '' : '',
      email: user is Map ? user['email'] ?? '' : '',
      className: classData is Map ? classData['name'] ?? '' : '',
      gradeLevel: json['grade_level'] ?? '',
      section: json['section'],
    );
  }
}