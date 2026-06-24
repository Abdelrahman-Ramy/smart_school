import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';

import 'parent_link_student_state.dart';

class ParentLinkStudentCubit extends Cubit<ParentLinkStudentState> {
  final ParentRepo repo;

  ParentLinkStudentCubit(this.repo) : super(ParentLinkStudentInitial());

  Future<void> linkStudent({required String studentId}) async {
    try {
      emit(ParentLinkStudentLoading());

      final result = await repo.linkStudent(studentId: studentId);

      emit(ParentLinkStudentSuccess(result.message));
    } catch (e) {
      emit(ParentLinkStudentError(e.toString()));
    }
  }
}
