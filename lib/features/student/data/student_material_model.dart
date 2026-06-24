class StudentMaterialModel {
  final int id;
  final String title;
  final String fileUrl;
  final String className;
  final String teacherName;

  StudentMaterialModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.className,
    required this.teacherName,
  });

  factory StudentMaterialModel.fromJson(Map<String, dynamic> json) {
    return StudentMaterialModel(
      id: json['id'],
      title: json['title'] ?? '',
      fileUrl: json['file_url'] ?? '',
      className: json['class_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
    );
  }
}
