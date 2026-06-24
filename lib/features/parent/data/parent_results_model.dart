class ParentResultModel {
  final int id;
  final int score;
  final String quizTitle;
  final int maxScore;
  final String studentName;
  final String studentCode;

  ParentResultModel({
    required this.id,
    required this.score,
    required this.quizTitle,
    required this.maxScore,
    required this.studentName,
    required this.studentCode,
  });

  factory ParentResultModel.fromJson(Map<String, dynamic> json) {
    return ParentResultModel(
      id: json['id'] ?? 0,
      score: json['score'] ?? 0,
      quizTitle: json['quiz']?['title'] ?? '',
      maxScore: json['quiz']?['max_score'] ?? 0,
      studentName: json['student']?['user']?['name'] ?? '',
      studentCode: json['student']?['student_id'] ?? '',
    );
  }
}
