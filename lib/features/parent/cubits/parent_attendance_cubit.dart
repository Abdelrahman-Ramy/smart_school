import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/parent_repo.dart';
import 'parent_attendance_state.dart';

class ParentAttendanceCubit extends Cubit<ParentAttendanceState> {
  final ParentRepo repo;

  ParentAttendanceCubit(this.repo) : super(ParentAttendanceInitial());

  Future<void> getAttendance() async {
    emit(ParentAttendanceLoading());

    try {
      final attendance = await repo.getAttendance();

      emit(ParentAttendanceSuccess(attendance));
    } catch (e) {
      emit(ParentAttendanceError(e.toString()));
    }
  }
}
