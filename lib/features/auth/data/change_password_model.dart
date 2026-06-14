class ChangePasswordModel {
  final bool success;
  final String message;

  ChangePasswordModel({
    required this.success,
    required this.message,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordModel(
      success: json['success'],
      message: json['message'],
    );
  }
}