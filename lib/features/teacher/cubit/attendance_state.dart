import 'package:equatable/equatable.dart';
import 'package:smart_school/features/teacher/data/class_attendance_model.dart';

abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// =====================
/// Initial
/// =====================
class AttendanceInitial extends AttendanceState {}

/// =====================
/// Class Students Flow
/// =====================
class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<ClassAttendanceItem> students;
  final Map<int, String> localStatus;
  final Set<int> modified;
  final Map<int, String> studentCodeMap;

  AttendanceLoaded({
    required this.students,
    required this.localStatus,
    required this.modified,
    this.studentCodeMap = const {},
  });

  AttendanceLoaded copyWith({
    List<ClassAttendanceItem>? students,
    Map<int, String>? localStatus,
    Set<int>? modified,
    Map<int, String>? studentCodeMap,
  }) {
    return AttendanceLoaded(
      students: students ?? this.students,
      localStatus: localStatus ?? Map.from(this.localStatus),
      modified: modified ?? Set.from(this.modified),
      studentCodeMap: studentCodeMap ?? Map.from(this.studentCodeMap),
    );
  }

  @override
  List<Object?> get props => [students, localStatus, modified, studentCodeMap];
}

/// =====================
/// Today Attendance Flow (NEW FIX)
/// =====================
class TodayAttendanceLoading extends AttendanceState {}

class TodayAttendanceLoaded extends AttendanceState {
  final ClassAttendanceResponse response;

  TodayAttendanceLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

/// =====================
/// Save Flow
/// =====================
class AttendanceSaving extends AttendanceState {}

class AttendanceSaved extends AttendanceState {}

/// =====================
/// Error
/// =====================
class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
