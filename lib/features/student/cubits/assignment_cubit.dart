import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/student/data/student_repo.dart';
import 'assignment_state.dart';

class AssignmentCubit extends Cubit<AssignmentState> {
  final StudentRepo repo;

  AssignmentCubit(this.repo) : super(AssignmentInitial());

  Future<void> getAssignments() async {
    emit(AssignmentLoading());

    try {
      final data = await repo.getAssignments();
      emit(AssignmentLoaded(assignments: data));
    } catch (e) {
      emit(AssignmentError(e.toString()));
    }
  }

  Future<void> uploadSolution({
    required String assignmentId,
    required String filePath,
  }) async {
    try {
      emit(AssignmentUploading());

      await repo.uploadAssignmentSolution(
        assignmentId: assignmentId,
        filePath: filePath,
      );

      emit(AssignmentUploadSuccess("Assignment submitted successfully"));

      final assignments = await repo.getAssignments();

      emit(AssignmentLoaded(assignments: assignments));
    } catch (e) {
      final msg = e.toString().toLowerCase();

      if (msg.contains("already")) {
        emit(AssignmentAlreadySubmitted("Already submitted"));

        final assignments = await repo.getAssignments();

        emit(AssignmentLoaded(assignments: assignments));

        return;
      }

      emit(AssignmentError(e.toString()));
    }
  }
}
