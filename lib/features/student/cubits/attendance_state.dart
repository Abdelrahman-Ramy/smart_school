import 'package:smart_school/features/student/data/attendance_model.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<StudentAttendanceModel> history;
  final Map<String, dynamic> summary;

  AttendanceLoaded({required this.history, required this.summary});
}

class AttendanceError extends AttendanceState {
  final String error;

  AttendanceError(this.error);
}
