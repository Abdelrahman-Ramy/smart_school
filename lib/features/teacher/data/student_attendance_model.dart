class StudentAttendanceResponse {
  final bool success;
  final AttendanceHistoryData data;

  StudentAttendanceResponse({
    required this.success,
    required this.data,
  });

  factory StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceResponse(
      success: json['success'] ?? false,
      data: AttendanceHistoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class AttendanceHistoryData {
  final AttendanceSummary summary;
  final List<AttendanceHistoryItem> history;

  AttendanceHistoryData({
    required this.summary,
    required this.history,
  });

  factory AttendanceHistoryData.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryData(
      summary: AttendanceSummary.fromJson(json['summary'] ?? {}),
      history: (json['history']?['data'] as List? ?? [])
          .map((item) => AttendanceHistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class AttendanceSummary {
  final int totalSessions;
  final int present;
  final int absent;
  final int late;
  final String attendanceRate;

  AttendanceSummary({
    required this.totalSessions,
    required this.present,
    required this.absent,
    required this.late,
    required this.attendanceRate,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalSessions: json['total_sessions'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      attendanceRate: json['attendance_rate'] ?? '0%',
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