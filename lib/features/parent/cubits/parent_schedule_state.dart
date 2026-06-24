import 'package:equatable/equatable.dart';
import 'package:smart_school/features/parent/data/parent_schedule_model.dart';

abstract class ParentScheduleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParentScheduleInitial extends ParentScheduleState {}

class ParentScheduleLoading extends ParentScheduleState {}

class ParentScheduleSuccess extends ParentScheduleState {
  final List<ParentScheduleModel> schedules;

  ParentScheduleSuccess(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

class ParentScheduleError extends ParentScheduleState {
  final String message;

  ParentScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
