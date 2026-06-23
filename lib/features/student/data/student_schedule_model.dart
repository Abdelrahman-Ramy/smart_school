class StudentScheduleModel {
  final int id;
  final int teacherId;
  final int classId;
  final String subject;
  final String day;
  final String startTime;
  final String endTime;

  StudentScheduleModel({
    required this.id,
    required this.teacherId,
    required this.classId,
    required this.subject,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory StudentScheduleModel.fromJson(Map<String, dynamic> json) {
    return StudentScheduleModel(
      id: json['id'] ?? 0,
      teacherId: json['teacher_id'] ?? 0,
      classId: json['class_id'] ?? 0,
      subject: json['subject'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
