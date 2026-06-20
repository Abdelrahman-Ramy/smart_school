class QuizCreateResponse {
  final bool success;
  final String message;
  final QuizData? data;

  QuizCreateResponse({required this.success, required this.message, this.data});

  factory QuizCreateResponse.fromJson(Map<String, dynamic> json) {
    return QuizCreateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? QuizData.fromJson(json['data']) : null,
    );
  }
}

class QuizData {
  final int id;
  final String classId;
  final String title;
  final String description;
  final String quizDate;
  final String totalMarks;

  QuizData({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.quizDate,
    required this.totalMarks,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      id: json['id'] ?? 0,
      classId: json['class_id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      quizDate: json['quiz_date'] ?? '',
      totalMarks: json['total_marks']?.toString() ?? '',
    );
  }
}
