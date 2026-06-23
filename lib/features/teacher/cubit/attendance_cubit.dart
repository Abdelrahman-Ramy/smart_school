import 'package:bloc/bloc.dart';
import 'package:smart_school/features/teacher/cubit/attendance_state.dart';
import 'package:smart_school/features/teacher/data/class_attendance_model.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final TeacherRepo _repo;

  AttendanceCubit(this._repo) : super(AttendanceInitial());

  /// =====================
  /// Load Class Students
  /// =====================
  Future<void> loadClassStudents(int classId) async {
    emit(AttendanceLoading());

    try {
      final response = await _repo.apiService.get(
        '/teacher/classes/$classId/students',
      );
      print(response);

      final List<dynamic> list = response['data']?['students'] ?? [];
      print('Students Count: ${list.length}');
      

      final List<ClassAttendanceItem> students = [];
      final Map<int, String> studentCodeMap = {};

      int syntheticId = 1;

      for (var e in list) {
        final item = e as Map<String, dynamic>;

        final name = item['student_name']?.toString() ?? '';
        final status = item['status']?.toString() ?? 'not_marked';
        final code = item['student_id']?.toString() ?? '';

        students.add(
          ClassAttendanceItem(
            id: 0,
            studentId: syntheticId,
            studentName: name,
            status: status,
            studentCode: code,
          ),
        );

        studentCodeMap[syntheticId] = code;
        syntheticId++;
      }

      final local = {for (var s in students) s.studentId: 'absent'};

      emit(
        AttendanceLoaded(
          students: students,
          localStatus: local,
          modified: {},
          studentCodeMap: studentCodeMap,
        ),
      );
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  /// =====================
  /// Toggle
  /// =====================
  void toggleStatus(int studentId) {
    final stateNow = state;

    if (stateNow is AttendanceLoaded) {
      final local = Map<int, String>.from(stateNow.localStatus);
      final modified = Set<int>.from(stateNow.modified);

      final current = local[studentId] ?? 'absent';
      local[studentId] = current == 'present' ? 'absent' : 'present';

      modified.add(studentId);

      emit(stateNow.copyWith(localStatus: local, modified: modified));
    }
  }

  /// =====================
  /// Save Attendance
  /// =====================
  Future<void> saveAttendance(int classId) async {
    final stateNow = state;

    if (stateNow is! AttendanceLoaded) return;

    emit(AttendanceSaving());

    try {
      final tasks = <Future>[];

      for (var entry in stateNow.localStatus.entries) {
        if (entry.value != 'present') continue;

        final studentIdForApi = stateNow.studentCodeMap[entry.key] ?? entry.key;

        tasks.add(
          _repo.markStudentAttendance(
            studentId: studentIdForApi,
            classId: classId,
            status: 'present',
          ),
        );
      }

      await Future.wait(tasks);

      final reset = {for (var s in stateNow.students) s.studentId: 'absent'};

      emit(AttendanceSaved());

      emit(stateNow.copyWith(localStatus: reset, modified: {}));
    } catch (e) {
      emit(AttendanceError(e.toString()));
      emit(stateNow);
    }
  }

  /// =====================
  /// TODAY ATTENDANCE (FIXED)
  /// =====================
  Future<void> loadTodayClassAttendance(int classId) async {
    emit(TodayAttendanceLoading());

    try {
      final response = await _repo.getClassAttendanceToday(classId: classId);

      emit(TodayAttendanceLoaded(response));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}
