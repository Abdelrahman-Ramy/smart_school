class QuizDeleteResponse {
  final bool success;
  final String message;

  QuizDeleteResponse({
    required this.success,
    required this.message,
  });

  factory QuizDeleteResponse.fromJson(Map<String, dynamic> json) {
    return QuizDeleteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}