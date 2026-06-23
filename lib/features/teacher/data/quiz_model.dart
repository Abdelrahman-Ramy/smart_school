class QuizModel {
  final String title;
  final int maxScore;

  QuizModel({
    required this.title,
    required this.maxScore,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      title: json['title']?.toString() ?? '',
      maxScore: int.tryParse(
            json['max_score'].toString(),
          ) ??
          0,
    );
  }
}