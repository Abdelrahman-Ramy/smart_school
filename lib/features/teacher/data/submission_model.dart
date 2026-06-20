class SubmissionResponse {
  final bool success;
  final List<SubmissionModel> data;

  SubmissionResponse({required this.success, required this.data});

  factory SubmissionResponse.fromJson(Map<String, dynamic> json) {
    return SubmissionResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}

class SubmissionModel {
  final int id;
  final int assignmentId;
  final int studentId;
  final String filePath;
  final int score;
  final String feedback;
  final String status;
  final String createdAt;
  final SubmissionStudentModel student;

  SubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.filePath,
    required this.score,
    required this.feedback,
    required this.status,
    required this.createdAt,
    required this.student,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id'] ?? 0,
      assignmentId: json['assignment_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      filePath: json['file_path'] ?? '',
      score: json['score'] ?? 0,
      feedback: json['feedback'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      student: SubmissionStudentModel.fromJson(json['student'] ?? {}),
    );
  }
}

class SubmissionStudentModel {
  final int id;
  final String studentCode;
  final String gradeLevel;
  final String section;
  final int classId;
  final SubmissionUserModel user;

  SubmissionStudentModel({
    required this.id,
    required this.studentCode,
    required this.gradeLevel,
    required this.section,
    required this.classId,
    required this.user,
  });

  factory SubmissionStudentModel.fromJson(Map<String, dynamic> json) {
    return SubmissionStudentModel(
      id: json['id'] ?? 0,
      studentCode: json['student_id']?.toString() ?? '',
      gradeLevel: json['grade_level']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      classId: json['class_id'] ?? 0,
      user: SubmissionUserModel.fromJson(json['user'] ?? {}),
    );
  }
}

class SubmissionUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;

  SubmissionUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory SubmissionUserModel.fromJson(Map<String, dynamic> json) {
    return SubmissionUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}