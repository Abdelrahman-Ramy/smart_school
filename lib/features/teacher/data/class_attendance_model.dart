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
    var list = json['data'] as List?;
    List<ClassAttendanceItem> parsedList = list != null
        ? list.map((i) => ClassAttendanceItem.fromJson(i)).toList()
        : [];

    return ClassAttendanceResponse(
      success: json['success'] ?? false,
      date: json['date']?.toString() ?? "",
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id']?.toString() ?? '') ?? 0,
      count: json['count'] is int
          ? json['count']
          : int.tryParse(json['count']?.toString() ?? '') ?? 0,
      data: parsedList,
    );
  }
}

class ClassAttendanceItem {
  final int id;
  final int studentId;
  final String studentName;
  final String status;

  ClassAttendanceItem({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.status,
  });

  factory ClassAttendanceItem.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceItem(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      studentId: json['student_id'] is int
          ? json['student_id']
          : int.tryParse(json['student_id']?.toString() ?? '') ?? 0,
      studentName: json['student_name']?.toString() ?? "Unknown Student",
      status: json['status']?.toString() ?? "absent",
    );
  }
}
