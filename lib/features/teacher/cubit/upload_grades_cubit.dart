import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/teacher/cubit/upload_grades_state.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';

class UploadGradesCubit extends Cubit<UploadGradesState> {
  final TeacherRepo repo;

  UploadGradesCubit(this.repo) : super(UploadGradesInitial());

  List<dynamic> _students = [];

  // ================= LOAD STUDENTS =================
  Future<void> loadStudents(String classId) async {
    emit(UploadGradesLoading());

    try {
      final response = await repo.apiService.get(
        '/teacher/classes/$classId/students',
      );

      final List<dynamic> students = response['data']?['students'] ?? [];

      _students = students;

      emit(UploadGradesStudentsLoaded(students));
    } catch (e) {
      emit(UploadGradesFailure(e.toString()));
    }
  }

  // ================= UPLOAD GRADES =================
  Future<void> uploadGrades({
    required String title,
    required String maxScore,
    required Map<String, String> scores,
  }) async {
    emit(UploadGradesSubmitting());

    try {
      final quiz = await repo.createQuiz(title: title, maxScore: maxScore);

      if (quiz == null) {
        emit(UploadGradesFailure('Failed to create quiz'));
        return;
      }

      for (final student in _students) {
        final apiStudentId = student['student_id'].toString();

        final success = await repo.saveGradeResult(
          title: title,
          studentId: apiStudentId,
          score: scores[apiStudentId] ?? '0',
          maxScore: maxScore,
        );

        if (!success) {
          emit(UploadGradesFailure('Failed to save grade for $apiStudentId'));
          return;
        }

        final firebaseId = await repo.getFirebaseIdFromStudentApiId(
          apiStudentId,
        );

        print("API ID: $apiStudentId");
        print("Firebase ID: $firebaseId");

        if (firebaseId == null || firebaseId.isEmpty) {
          print("No Firebase ID found for student $apiStudentId");
          continue;
        }

        await repo.createNotification(
          receiverId: student['student_id'].toString(),
          senderId: 'teacher',
          senderName: 'Teacher',
          title: 'New Grades Released',
          body: 'Your result for $title has been published',
          type: 'grade',
          relatedId: title,
        );

        print("Notification sent to $firebaseId");
      }

      print("ENTERED NOTIFICATION STEP");

      emit(UploadGradesSuccess('Grades uploaded successfully'));
    } catch (e) {
      emit(UploadGradesFailure(e.toString()));
    }
  }
}
