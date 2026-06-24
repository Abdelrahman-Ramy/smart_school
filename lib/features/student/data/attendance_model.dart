class StudentAttendanceModel {
  final int id;
  final int studentId;
  final int classId;
  final int teacherId;
  final String date;
  final String status;
  final String className;

  StudentAttendanceModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.teacherId,
    required this.date,
    required this.status,
    required this.className,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      id: json['id'],
      studentId: json['student_id'],
      classId: json['class_id'],
      teacherId: json['teacher_id'],
      date: json['date'],
      status: json['status'],
      className: json['class']?['name'] ?? '',
    );
  }
}