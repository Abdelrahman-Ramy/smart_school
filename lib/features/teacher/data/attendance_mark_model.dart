class AttendanceMarkResponse {
  final bool success;
  final AttendanceMarkData? data;

  AttendanceMarkResponse({required this.success, this.data});

  factory AttendanceMarkResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceMarkResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? AttendanceMarkData.fromJson(json['data'])
          : null,
    );
  }
}

class AttendanceMarkData {
  final int id;
  final dynamic studentId;
  final String classId;
  final int teacherId;
  final String status;
  final String date;
  final String createdAt;
  final String updatedAt;

  AttendanceMarkData({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.teacherId,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceMarkData.fromJson(Map<String, dynamic> json) {
    return AttendanceMarkData(
      id: json['id'] ?? 0,
      studentId: json['student_id'],
      classId: json['class_id']?.toString() ?? "",
      teacherId: json['teacher_id'] ?? 0,
      status: json['status']?.toString() ?? "",
      date: json['date']?.toString() ?? "",
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
    );
  }
}
