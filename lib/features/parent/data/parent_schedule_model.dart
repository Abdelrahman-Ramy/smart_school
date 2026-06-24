class ParentScheduleModel {
  final String studentId;
  final String studentName;
  final int classId;
  final List<ScheduleItemModel> schedule;

  ParentScheduleModel({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.schedule,
  });

  factory ParentScheduleModel.fromJson(Map<String, dynamic> json) {
    return ParentScheduleModel(
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      classId: json['class_id'] ?? 0,
      schedule: (json['schedule'] as List<dynamic>? ?? [])
          .map((e) => ScheduleItemModel.fromJson(e))
          .toList(),
    );
  }
}

class ScheduleItemModel {
  final int id;
  final String subject;
  final String day;
  final String startTime;
  final String endTime;

  ScheduleItemModel({
    required this.id,
    required this.subject,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
