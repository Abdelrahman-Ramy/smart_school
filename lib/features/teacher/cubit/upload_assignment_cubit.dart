import 'package:bloc/bloc.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'upload_assignment_state.dart';

class UploadAssignmentCubit extends Cubit<UploadAssignmentState> {
  final TeacherRepo _repo;
  UploadAssignmentCubit(this._repo) : super(UploadAssignmentInitial());

  Future<void> uploadAssignment({
    required String teacherId,
    required String classId,
    required String title,
    required String description,
    required String dueDate,
    required String maxScore,
    required String type,
    String? filePath,
  }) async {
    emit(UploadAssignmentSubmitting());
    try {
      final res = await _repo.uploadAssignment(
        teacherId: teacherId,
        classId: classId,
        title: title,
        description: description,
        dueDate: dueDate,
        maxScore: maxScore,
        type: type,
        filePath: filePath,
      );

      final success =
          res is Map && (res['success'] == true || res['success'] == 1);
      final msg = (res is Map && res['message'] != null)
          ? res['message'] as String
          : 'Completed';

      if (success) {
        emit(UploadAssignmentSuccess(msg, data: res));
      } else {
        emit(UploadAssignmentFailure(msg));
      }
    } catch (e) {
      emit(UploadAssignmentFailure(e.toString()));
    }
  }
}
