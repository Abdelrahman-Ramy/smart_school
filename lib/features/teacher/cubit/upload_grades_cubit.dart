import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/cubit/upload_grades_state.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';

class UploadGradesCubit extends Cubit<UploadGradesState> {
  final TeacherRepo repo;

  UploadGradesCubit(this.repo) : super(UploadGradesInitial());

  List<dynamic> _students = [];

  /// ================= LOAD STUDENTS =================
  Future<void> loadStudents(String classId) async {
    
    emit(UploadGradesLoading());

    try {
      final response = await repo.apiService.get(
        '/teacher/classes/$classId/students',
      );

      final List<dynamic> students =
          response['data']?['students'] ?? [];

      _students = students;

      emit(UploadGradesStudentsLoaded(students));
    } catch (e) {
      emit(UploadGradesFailure(e.toString()));
    }
  }

  /// ================= UPLOAD GRADES =================
  Future<void> uploadGrades({
    required String title,
    required String maxScore,
    required Map<String, String> scores,
  }) async {
    emit(UploadGradesSubmitting());

    try {
      final quiz = await repo.createQuiz(
        title: title,
        maxScore: maxScore,
      );

      if (quiz == null) {
        emit(UploadGradesFailure('Failed to create quiz'));
        return;
      }

      for (final student in _students) {
        final String studentId =
            student['student_id'].toString();

        final bool success = await repo.saveGradeResult(
          title: title,
          studentId: studentId,
          score: scores[studentId] ?? '0',
          maxScore: maxScore,
        );

        if (!success) {
          emit(
            UploadGradesFailure(
              'Failed to save grade for $studentId',
            ),
          );
          return;
        }
      }

      emit(
        UploadGradesSuccess(
          'Grades uploaded successfully',
        ),
      );
    } catch (e) {
      emit(UploadGradesFailure(e.toString()));
    }
  }
}