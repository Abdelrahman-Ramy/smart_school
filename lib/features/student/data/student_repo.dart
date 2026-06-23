import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/student/data/student_schedule_model.dart';

class StudentRepo {

  Future<List<StudentScheduleModel>> getSchedule() async {
    ApiService apiService = ApiService();
    try {
      final response = await apiService.get('/student/schedule');

      final List<dynamic> data = response['data'] ?? [];

      return data
          .map<StudentScheduleModel>(
            (e) => StudentScheduleModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }


}
