class AssignmentStudentModel {
  final int id;
  final int classId;
  final int teacherId;

  final String title;
  final String description;
  final String status;
  final String dueDate;

  final String? attachmentPath;

  final String className;
  final String teacherName;
  final String teacherSubject;

  AssignmentStudentModel({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.title,
    required this.description,
    required this.status,
    required this.dueDate,
    required this.attachmentPath,
    required this.className,
    required this.teacherName,
    required this.teacherSubject,
  });

  factory AssignmentStudentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentStudentModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      teacherId: json['teacher_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      dueDate: json['due_date'] ?? '',
      attachmentPath: json['attachment_path'] != null
          ? "http://YOUR_BASE_URL/storage/${json['attachment_path']}"
          : null,
      className: json['class']?['name'] ?? '',
      teacherName: json['teacher']?['name'] ?? '',
      teacherSubject: json['teacher']?['subject'] ?? '',
    );
  }
}

class AssignmentSubmissionModel {
  final int id;
  final int assignmentId;
  final int studentId;

  final String filePath;
  final String status;

  final DateTime createdAt;

  AssignmentSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.filePath,
    required this.status,
    required this.createdAt,
  });

  factory AssignmentSubmissionModel.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmissionModel(
      id: json['id'] ?? 0,
      assignmentId: int.tryParse(json['assignment_id'].toString()) ?? 0,
      studentId: json['student_id'] ?? 0,
      filePath: json['file_path'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}