import 'package:smart_school/features/student/data/student_schedule_model.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<StudentScheduleModel> schedule;
  final String selectedDay;

  ScheduleLoaded({
    required this.schedule,
    this.selectedDay = 'Sat',
  });

  ScheduleLoaded copyWith({
    List<StudentScheduleModel>? schedule,
    String? selectedDay,
  }) {
    return ScheduleLoaded(
      schedule: schedule ?? this.schedule,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}

class ScheduleError extends ScheduleState {
  final String error;

  ScheduleError(this.error);
}