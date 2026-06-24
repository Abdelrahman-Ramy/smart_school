import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/student/cubits/attendance_state.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final StudentRepo repo;

  AttendanceCubit(this.repo) : super(AttendanceInitial());

  Future<void> getAttendance() async {
    emit(AttendanceLoading());

    try {
      final result = await repo.getAttendance();

      emit(
        AttendanceLoaded(
          history: result['history'],
          summary: result['summary'],
        ),
      );
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}
