class StudentAttendanceResponse {
  final bool success;
  final List<AttendanceHistoryItem> data;

  StudentAttendanceResponse({required this.success, required this.data});

  factory StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List? ?? [])
          .map((item) => AttendanceHistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class AttendanceHistoryItem {
  final int id;
  final String date;
  final String status;

  AttendanceHistoryItem({
    required this.id,
    required this.date,
    required this.status,
  });

  factory AttendanceHistoryItem.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryItem(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? 'absent',
    );
  }
}
