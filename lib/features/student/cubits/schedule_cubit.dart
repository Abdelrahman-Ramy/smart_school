import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/features/student/cubits/schedule_state.dart';
import 'package:smart_school/features/student/data/student_repo.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final StudentRepo repo;

  ScheduleCubit(this.repo) : super(ScheduleInitial());

  String selectedDay = 'Sat';

  // =====================
  // LOAD SCHEDULE ONCE
  // =====================
  Future<void> getSchedule() async {
    emit(ScheduleLoading());

    try {
      final schedule = await repo.getSchedule();

      emit(
        ScheduleLoaded(
          schedule: schedule,
          selectedDay: selectedDay,
        ),
      );
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  // =====================
  // CHANGE DAY (IMPORTANT)
  // =====================
  void changeDay(String day) {
    selectedDay = day;

    final currentState = state;

    if (currentState is ScheduleLoaded) {
      emit(
        currentState.copyWith(selectedDay: day),
      );
    }
  }
}