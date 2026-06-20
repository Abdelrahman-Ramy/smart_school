class QuizListResponse {
  final bool success;
  final List<QuizItem> quizzes;

  QuizListResponse({required this.success, required this.quizzes});

  factory QuizListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'];
    List<QuizItem> quizList = [];

    if (list != null) {
      if (list is List) {
        quizList = list.map((i) => QuizItem.fromJson(i)).toList();
      } else if (list is Map<String, dynamic>) {
        quizList.add(QuizItem.fromJson(list));
      }
    }

    return QuizListResponse(
      success: json['success'] ?? false,
      quizzes: quizList,
    );
  }
}

class QuizItem {
  final int id;
  final int classId;
  final String title;
  final String description;
  final String quizDate;
  final int totalMarks;

  QuizItem({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.quizDate,
    required this.totalMarks,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
      id: json['id'] ?? 0,
      classId: json['class_id'] is int
          ? json['class_id']
          : int.tryParse(json['class_id'].toString()) ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      quizDate: json['quiz_date'] ?? '',
      totalMarks: json['total_marks'] is int
          ? json['total_marks']
          : int.tryParse(json['total_marks'].toString()) ?? 0,
    );
  }
}
