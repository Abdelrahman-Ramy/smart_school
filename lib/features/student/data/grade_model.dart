class GradeModel {
  final String title;
  final int score;
  final int maxScore;
  final int percentage;

  GradeModel({
    required this.title,
    required this.score,
    required this.maxScore,
    required this.percentage,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      title: json['title'] ?? '',

      score: (json['score'] ?? 0) is int
          ? json['score']
          : int.parse(json['score'].toString()),

      maxScore: (json['max_score'] ?? 0) is int
          ? json['max_score']
          : int.parse(json['max_score'].toString()),

      percentage: (json['percentage'] ?? 0) is int
          ? json['percentage']
          : int.parse(json['percentage'].toString()),
    );
  }
}