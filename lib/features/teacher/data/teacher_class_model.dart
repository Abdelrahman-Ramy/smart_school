class TeacherClassModel {
  final int? id;
  final int? classId;
  final String? subject;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? className;
  final String? sectionName;
  final int? studentsCount;

  TeacherClassModel({
    this.id,
    this.classId,
    this.subject,
    this.day,
    this.startTime,
    this.endTime,
    this.className,
    this.sectionName,
    this.studentsCount,
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    // Support two backend response shapes:
    // 1) Schedule entry: contains keys like 'class', 'subject', 'start_time'
    // 2) Class object: contains 'id', 'name', 'description', 'students_count'

    if (json.containsKey('class') || json.containsKey('start_time')) {
      final classMap = json['class'] as Map<String, dynamic>? ?? {};
      return TeacherClassModel(
        id: json['id'] ?? 0,
        classId: json['class_id'] ?? (classMap['id'] ?? 0),
        subject: json['subject'] ?? classMap['name'] ?? '',
        day: json['day'] ?? '',
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        className: classMap['name'] ?? '',
        sectionName: classMap['section'] ?? '',
        studentsCount:
            json['students_count'] ?? classMap['students_count'] ?? null,
      );
    }

    // Fallback: treat json as a ClassModel object
    return TeacherClassModel(
      id: json['id'] ?? 0,
      classId: json['id'] ?? 0,
      subject: json['name'] ?? json['subject'] ?? '',
      day: '',
      startTime: '',
      endTime: '',
      className: json['name'] ?? '',
      sectionName: json['description'] ?? '',
      studentsCount: json['students_count'] ?? null,
    );
  }
}
