import 'package:bloc/bloc.dart';
import 'package:smart_school/features/teacher/cubit/submission_search_state.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/features/teacher/data/assignment_model.dart';
import 'package:smart_school/features/teacher/data/submission_model.dart';

class SubmissionSearchCubit extends Cubit<SubmissionSearchState> {
  final TeacherRepo _repo;
  SubmissionSearchCubit(this._repo) : super(SubmissionSearchInitial());

  /// Search submissions by assignment/task ID
  Future<void> searchByTaskId(String taskId) async {
    final parsedId = int.tryParse(taskId);

    if (parsedId == null) {
      emit(SubmissionSearchFailure("Invalid Task ID"));
      return;
    }

    emit(SubmissionSearchLoading());

    try {
      final res = await _repo.getAssignmentSubmissions(assignmentId: parsedId);

      AssignmentModel? assignment;

      try {
        final assignmentResp = await _repo.apiService.get(
          '/assignments/$parsedId',
        );

        assignment = AssignmentModel.fromJson(
          assignmentResp as Map<String, dynamic>,
        );
      } catch (_) {
        assignment = null;
      }

      if (res.success && res.data.isNotEmpty) {
        emit(SubmissionSearchSuccess(assignment, res.data));
      } else {
        emit(SubmissionSearchEmpty());
      }
    } catch (e) {
      emit(SubmissionSearchFailure(e.toString()));
    }
  }
}
