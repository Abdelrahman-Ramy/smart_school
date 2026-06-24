class ParentAttendanceModel {
  final String studentName;
  final int total;
  final int present;
  final int absent;
  final String rate;
  final List<AttendanceHistoryModel> history;

  ParentAttendanceModel({
    required this.studentName,
    required this.total,
    required this.present,
    required this.absent,
    required this.rate,
    required this.history,
  });

  factory ParentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ParentAttendanceModel(
      studentName: json['student']['name'] ?? '',
      total: json['summary']['total'] ?? 0,
      present: json['summary']['present'] ?? 0,
      absent: json['summary']['absent'] ?? 0,
      rate: json['summary']['rate'] ?? '0%',
      history: (json['history'] as List<dynamic>)
          .map((e) => AttendanceHistoryModel.fromJson(e))
          .toList(),
    );
  }
}

class AttendanceHistoryModel {
  final int id;
  final String date;
  final String status;

  AttendanceHistoryModel({
    required this.id,
    required this.date,
    required this.status,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
