class ClassAttendanceResponse {
  final bool success;
  final String date;
  final int classId;
  final int count;
  final List<ClassAttendanceItem> data;

  ClassAttendanceResponse({
    required this.success,
    required this.date,
    required this.classId,
    required this.count,
    required this.data,
  });

  factory ClassAttendanceResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List? ?? [];

    return ClassAttendanceResponse(
      success: json['success'] ?? false,
      date: json['date']?.toString() ?? '',
      classId: _parseInt(json['class_id']),
      count: _parseInt(json['count']),
      data: list
          .map((e) => ClassAttendanceItem.fromJson(e))
          .toList(),
    );
  }
}

class ClassAttendanceItem {
  final int id;
  final int studentId;
  final String studentCode;
  final String studentName;
  final String status;

  ClassAttendanceItem({
    required this.id,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.status,
  });

  factory ClassAttendanceItem.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceItem(
      id: _parseInt(json['id']),
      studentId: _parseInt(json['student_id']),
      studentCode: json['student_code']?.toString() ??
          json['student_id']?.toString() ??
          '',
      studentName: json['student_name']?.toString() ?? 'Unknown Student',
      status: json['status']?.toString() ?? 'absent',
    );
  }
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}