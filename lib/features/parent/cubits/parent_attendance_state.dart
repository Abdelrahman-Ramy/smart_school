import 'package:equatable/equatable.dart';
import '../data/parent_attendance_model.dart';

abstract class ParentAttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParentAttendanceInitial extends ParentAttendanceState {}

class ParentAttendanceLoading extends ParentAttendanceState {}

class ParentAttendanceSuccess extends ParentAttendanceState {
  final List<ParentAttendanceModel> attendance;

  ParentAttendanceSuccess(this.attendance);

  @override
  List<Object?> get props => [attendance];
}

class ParentAttendanceError extends ParentAttendanceState {
  final String message;

  ParentAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
