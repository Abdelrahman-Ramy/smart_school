import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/parent/data/link_student_model.dart';
import 'package:smart_school/features/parent/data/parent_attendance_model.dart';
import 'package:smart_school/features/parent/data/parent_profile_model.dart';
import 'package:smart_school/features/parent/data/parent_results_model.dart';
import 'package:smart_school/features/parent/data/parent_schedule_model.dart';
import 'package:smart_school/features/parent/data/parent_student_model.dart';

class ParentRepo {
  final ApiService apiService = ApiService();

  Future<LinkStudentModel> linkStudent({required String studentId}) async {
    final response = await apiService.post('/parent/link-student', {
      "student_id": studentId,
    });

    return LinkStudentModel.fromJson(response);
  }

  Future<List<ParentStudentModel>> getMyChildren() async {
    final response = await apiService.get('/parent/profile');

    final List data = response as List;

    return data.map((e) => ParentStudentModel.fromJson(e)).toList();
  }

  Future<String> unlinkStudent({required String studentId}) async {
    final response = await apiService.delete('/parent/unlink-student', {
      "student_id": studentId,
    });

    return response['message'] ?? 'Success';
  }

  Future<ParentProfileModel> getProfile() async {
    final response = await apiService.get('/parent/get-profile');

    return ParentProfileModel.fromJson(response);
  }

  Future<List<ParentResultModel>> getResults({String? studentId}) async {
    var endpoint = '/parent/results';

    if (studentId != null) {
      endpoint = '$endpoint?student_id=$studentId';
    }

    final response = await apiService.get(endpoint);

    return (response['data'] as List)
        .map((e) => ParentResultModel.fromJson(e))
        .toList();
  }

  Future<List<ParentAttendanceModel>> getAttendance({String? studentId}) async {
    var endpoint = '/parent/children/attendance';

    if (studentId != null) {
      endpoint = '$endpoint?student_id=$studentId';
    }

    final response = await apiService.get(endpoint);

    final List data = response['data'];

    return data.map((e) => ParentAttendanceModel.fromJson(e)).toList();
  }

  Future<List<ParentScheduleModel>> getSchedules({String? studentId}) async {
    var endpoint = '/parent/schedules';

    if (studentId != null) {
      endpoint = '$endpoint?student_id=$studentId';
    }

    final response = await apiService.get(endpoint);

    final List data = response['data'];

    return data.map((e) => ParentScheduleModel.fromJson(e)).toList();
  }
}
