class TeacherClassModel {
  final int? id;
  final int? classId;
  final String? subject;
  final String? day;
  final String? startTime;
  final String? endTime;
  final String? className;
  final String? sectionName;

  TeacherClassModel({
    this.id,
    this.classId,
    this.subject,
    this.day,
    this.startTime,
    this.endTime,
    this.className,
    this.sectionName,
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    
    final classMap = json['class'] as Map<String, dynamic>? ?? {};

    return TeacherClassModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      subject: json['subject'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      className: classMap['name'] ?? 'Class 1',
      sectionName: classMap['section'] ?? 'Section A',
    );
  }
}