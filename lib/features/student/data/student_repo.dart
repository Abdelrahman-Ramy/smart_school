import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/student/data/assignment_student_model.dart';
import 'package:smart_school/features/student/data/attendance_model.dart';
import 'package:smart_school/features/student/data/grade_model.dart';
import 'package:smart_school/features/student/data/student_material_model.dart';
import 'package:smart_school/features/student/data/student_schedule_model.dart';
import 'package:smart_school/features/teacher/data/assignment_model.dart';

class StudentRepo {
  final ApiService apiService = ApiService();

  Future<List<StudentScheduleModel>> getSchedule() async {
    final response = await apiService.get('/student/schedule');

    final List<dynamic> data = response['data'] ?? [];

    return data
        .map<StudentScheduleModel>(
          (e) => StudentScheduleModel.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList();
  }

  Future<List<StudentMaterialModel>> getMaterials() async {
    final response = await apiService.get('/student/materials');

    final List data = response['data'] ?? [];

    return data
        .map((e) => StudentMaterialModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<Map<String, dynamic>> getAttendance() async {
    try {
      final response = await apiService.get('/student/attendance/my-history');

      final data = response['data'];

      final summary = data['summary'];

      final List history = data['history'];

      return {
        "summary": summary,
        "history": history
            .map((e) => StudentAttendanceModel.fromJson(e))
            .toList(),
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GradeModel>> getGrades() async {
    try {
      final response = await apiService.get('/student/results');

      final List data = response['data'] ?? [];

      return data.map((e) => GradeModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AssignmentStudentModel>> getAssignments() async {
    try {
      final response = await apiService.get('/student/assignments');

      final Map<String, dynamic> data = response['data'] ?? {};

      final List list = data['data'] ?? [];

      return list.map((e) => AssignmentStudentModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadAssignmentSolution({
    required String assignmentId,
    required String filePath,
  }) async {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      "assignment_id": assignmentId,
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });

    await apiService.post(
      "/student/assignment-submissions", // أو confirm endpoint
      formData,
    );
  }
}
