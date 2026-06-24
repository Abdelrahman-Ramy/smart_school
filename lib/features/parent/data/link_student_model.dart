class LinkStudentModel {
  final bool success;
  final String message;

  LinkStudentModel({required this.success, required this.message});

  factory LinkStudentModel.fromJson(Map<String, dynamic> json) {
    return LinkStudentModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
