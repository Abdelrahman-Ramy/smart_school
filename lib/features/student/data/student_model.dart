class StudentModel {
  final int? id;
  final String? studentId;
  final int? userId;
  final String? gradeLevel;
  final int? classId;

  StudentModel({
    this.id,
    this.studentId,
    this.userId,
    this.gradeLevel,
    this.classId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      studentId: json['student_id'],
      userId: json['user_id'],
      gradeLevel: json['grade_level'],
      classId: json['class_id'],
    );
  }
}