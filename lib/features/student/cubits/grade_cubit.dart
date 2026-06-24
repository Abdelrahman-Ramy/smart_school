import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/student/cubits/grade_state.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class GradesCubit extends Cubit<GradeState> {
  final StudentRepo repo;

  GradesCubit(this.repo) : super(GradeInitial());

  Future<void> getGrades() async {
    emit(GradeLoading());

    try {
      final grades = await repo.getGrades();

      final summary = {
        "total": grades.length,
        "average": grades.isEmpty
            ? 0
            : grades.map((e) => e.percentage).reduce((a, b) => a + b) ~/
                  grades.length,
      };

      emit(GradeLoaded(grades: grades, summary: summary));
    } catch (e) {
      emit(GradeError(e.toString()));
    }
  }
}
