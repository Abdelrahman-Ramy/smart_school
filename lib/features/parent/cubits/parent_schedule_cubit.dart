import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/parent/cubits/parent_schedule_state.dart';
import 'package:smart_school/features/parent/data/parent_repo.dart';

class ParentScheduleCubit extends Cubit<ParentScheduleState> {
  final ParentRepo repo;

  ParentScheduleCubit(this.repo) : super(ParentScheduleInitial());

  Future<void> getSchedules() async {
    emit(ParentScheduleLoading());

    try {
      final schedules = await repo.getSchedules();

      emit(ParentScheduleSuccess(schedules));
    } catch (e) {
      emit(
        ParentScheduleError(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }
}