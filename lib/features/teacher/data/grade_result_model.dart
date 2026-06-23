class GradeResultModel {
  final String title;
  final String studentId;
  final int score;
  final int maxScore;

  GradeResultModel({
    required this.title,
    required this.studentId,
    required this.score,
    required this.maxScore,
  });

  factory GradeResultModel.fromJson(Map<String, dynamic> json) {
    return GradeResultModel(
      title: json['title']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      score: int.tryParse(json['score'].toString()) ?? 0,
      maxScore: int.tryParse(json['max_score'].toString()) ?? 0,
    );
  }
}
