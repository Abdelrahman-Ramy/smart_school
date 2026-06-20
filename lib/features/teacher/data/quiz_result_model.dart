class QuizResultSaveResponse {
  final bool success;
  final String message;
  final QuizResultData? data;

  QuizResultSaveResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QuizResultSaveResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultSaveResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? QuizResultData.fromJson(json['data']) : null,
    );
  }
}

class QuizResultData {
  final int id;
  final int studentId;
  final String quizId;
  final String score;

  QuizResultData({
    required this.id,
    required this.studentId,
    required this.quizId,
    required this.score,
  });

  factory QuizResultData.fromJson(Map<String, dynamic> json) {
    return QuizResultData(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      quizId: json['quiz_id']?.toString() ?? '',
      score: json['score']?.toString() ?? '',
    );
  }
}
