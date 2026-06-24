class ParentProfileModel {
  final bool success;
  final ParentUser user;

  ParentProfileModel({required this.success, required this.user});

  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    return ParentProfileModel(
      success: json['success'] ?? false,
      user: ParentUser.fromJson(json['data']['user']),
    );
  }
}

class ParentUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final List<ParentStudent> students;

  ParentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    required this.students,
  });

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    // Safely obtain students list from possible locations
    List<dynamic> studentsList = [];

    final dynamic parentField = json['parent'];
    if (json['students'] is List) {
      studentsList = json['students'] as List<dynamic>;
    } else if (parentField is Map<String, dynamic> &&
        parentField['students'] is List) {
      studentsList = parentField['students'] as List<dynamic>;
    } else if (json['user'] is Map<String, dynamic> &&
        json['user']['parent'] is Map<String, dynamic> &&
        json['user']['parent']['students'] is List) {
      studentsList = json['user']['parent']['students'] as List<dynamic>;
    }

    return ParentUser(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString(),
      address: json['address']?.toString(),
      students: studentsList
          .map((e) => ParentStudent.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ParentStudent {
  final int id;
  final String studentId;
  final String name;
  final String email;
  final String gradeLevel;
  final String section;

  ParentStudent({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    required this.gradeLevel,
    required this.section,
  });

  factory ParentStudent.fromJson(Map<String, dynamic> json) {
    final dynamic userField = json['user'];

    final String name = userField is Map<String, dynamic>
        ? (userField['name'] ?? '').toString()
        : (userField?.toString() ?? '');

    final String email = userField is Map<String, dynamic>
        ? (userField['email'] ?? '').toString()
        : (userField?.toString() ?? '');

    return ParentStudent(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      studentId: json['student_id']?.toString() ?? '',
      name: name,
      email: email,
      gradeLevel: json['grade_level']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
    );
  }
}
