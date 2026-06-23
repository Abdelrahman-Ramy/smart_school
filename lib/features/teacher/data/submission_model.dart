class SubmissionResponse {
  final bool success;
  final List<SubmissionModel> data;

  SubmissionResponse({
    required this.success,
    required this.data,
  });

  factory SubmissionResponse.fromJson(dynamic json) {
    if (json is List) {
      return SubmissionResponse(
        success: true,
        data: json
            .map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    if (json is Map<String, dynamic>) {
      final rawData = json['data'];

      final listData = rawData is List ? rawData : <dynamic>[];

      return SubmissionResponse(
        success: json['success'] == true,
        data: listData
            .map((e) => SubmissionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    return SubmissionResponse(success: false, data: []);
  }
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
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
      id: _toInt(json['id']),
      assignmentId: _toInt(json['assignment_id']),
      studentId: _toInt(json['student_id']),
      filePath: json['file_path']?.toString() ?? '',
      score: _toInt(json['score']),
      feedback: json['feedback']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      student: SubmissionStudentModel.fromJson(
        json['student'] is Map<String, dynamic>
            ? json['student']
            : {},
      ),
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
      id: _toInt(json['id']),
      studentCode: json['student_id']?.toString() ?? '',
      gradeLevel: json['grade_level']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      classId: _toInt(json['class_id']),
      user: SubmissionUserModel.fromJson(
        json['user'] is Map<String, dynamic> ? json['user'] : {},
      ),
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
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}