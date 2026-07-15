class TeacherModel {
  final int? teacherId;
  final String? subject;
  final List<TeacherClassModel> classes;

  TeacherModel({this.teacherId, this.subject, this.classes = const []});

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      teacherId: json['teacher_id'],
      subject: json['subject'],
      classes: (json['classes'] as List<dynamic>? ?? [])
          .map((e) => TeacherClassModel.fromJson(e))
          .toList(),
    );
  }
}

class TeacherClassModel {
  final int? id;
  final String? name;
  final int? teacherId;
  final String? gradeLevel;
  final String? section;

  TeacherClassModel({
    this.id,
    this.name,
    this.teacherId,
    this.gradeLevel,
    this.section,
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassModel(
      id: json['id'],
      name: json['name'],
      teacherId: json['teacher_id'],
      gradeLevel: json['grade_level'],
      section: json['section'],
    );
  }
}
