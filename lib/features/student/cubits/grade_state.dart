import 'package:smart_school/features/student/data/grade_model.dart';

abstract class GradeState {}

class GradeInitial extends GradeState {}

class GradeLoading extends GradeState {}

class GradeLoaded extends GradeState {
  final List<GradeModel> grades;
  final Map<String, dynamic> summary;

  GradeLoaded({
    required this.grades,
    required this.summary,
  });
}

class GradeError extends GradeState {
  final String error;

  GradeError(this.error);
}