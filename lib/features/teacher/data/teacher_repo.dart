import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/network/api_exception.dart';
import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/teacher/data/attendance_mark_model.dart';
import 'package:smart_school/features/teacher/data/class_attendance_model.dart';
import 'package:smart_school/features/teacher/data/material_response_model.dart';
import 'package:smart_school/features/teacher/data/quiz_delete_model.dart';
import 'package:smart_school/features/teacher/data/quiz_list_model.dart';
import 'package:smart_school/features/teacher/data/quiz_model.dart';
import 'package:smart_school/features/teacher/data/quiz_result_model.dart';
import 'package:smart_school/features/teacher/data/student_attendance_model.dart';
import 'package:smart_school/features/teacher/data/submission_model.dart';
import 'package:smart_school/features/teacher/data/teacher_class_model.dart';

class TeacherRepo {
  ApiService apiService = ApiService();

  // ----------------------------------------------------------------─
  // 1. Get Teacher Classes
  // ----------------------------------------------------------------─
  Future<List<TeacherClassModel>> fetchTeacherClasses() async {
    try {
      final response = await apiService.get("/teacher/schedules");

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected response from server');
      }

      final successRaw = response['success'];
      final success = successRaw == true || successRaw == 1;
      final msg = response['message'];

      if (!success) {
        throw ApiError(message: msg ?? 'Failed to fetch classes');
      }

      final data = response['data'];
      if (data == null) {
        throw ApiError(message: 'Missing data from server');
      }

      final List<dynamic> classesList =
          (data is Map<String, dynamic> && data.containsKey('classes'))
          ? data['classes']
          : data;

      return classesList
          .map((json) => TeacherClassModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // ----------------------------------------------------------------─
  // 2. Upload Assignment
  // ----------------------------------------------------------------─
  Future<dynamic> uploadAssignment({
    required String teacherId,
    required String classId,
    required String title,
    required String description,
    required String dueDate,
    required String maxScore,
    required String type,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> fields = {
        'teacher_id': int.tryParse(teacherId) ?? 0,
        'class_id': int.tryParse(classId) ?? 0,
        'title': title,
        'description': description,
        'due_date': dueDate,
        'max_score': int.tryParse(maxScore) ?? 100,
        'type': type,
      };

      dynamic data;
      if (filePath != null) {
        data = FormData.fromMap({
          ...fields,
          'attachment': await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        });
      } else {
        data = fields;
      }

      final response = await apiService.post('/teacher/assignments', data);
      return response;
    } catch (e) {
      if (e is DioException) {
        print("❌ API Error: ${e.response?.data}");
      }
      rethrow;
    }
  }

  Future<SubmissionResponse> getAssignmentSubmissions({
    required String assignmentId,
  }) async {
    try {
      final response = await apiService.post(
        '/teacher/assignments/submissions',
        {'assignment_id': assignmentId},
      );
      return SubmissionResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> gradeAssignment({
    required String submissionId,
    required String assignmentId,
    required String studentId,
    required String score,
    required String feedback,
    required String teacherId,
    required String classId,
  }) async {
    final Map<String, dynamic> data = {
      'assignment_id': assignmentId,
      'student_id': studentId,
      'score': score,
      'feedback': feedback,
      'teacher_id': teacherId,
      'class_id': classId,
    };

    try {
      final response = await apiService.post(
        '/teacher/assignment-submissions/grade',
        data,
      );

      return response['success'] == true;
    } catch (e) {
      if (e is DioException) {
        print("❌ خطأ الـ API: ${e.response?.data}");
      }
      return false;
    }
  }

  Future<MaterialUploadResponse> uploadMaterial({
    required String classId,
    required String title,
    required String filePath,
  }) async {
    try {
      final FormData formData = FormData.fromMap({
        'class_id': int.tryParse(classId) ?? 0,
        'title': title,
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await apiService.post(
        '/teacher/upload_materials',
        formData,
      );

      if (response is String) {
        return MaterialUploadResponse(success: false, message: response);
      }

      return MaterialUploadResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print("REPO CATCH ERROR: $e");
      rethrow;
    }
  }

  Future<AttendanceMarkResponse> markStudentAttendance({
    required int studentId,
    required int classId,
    required String status,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'student_id': studentId,
        'class_id': classId,
        'status': status,
      };

      final response = await apiService.post('/attendance/mark', bodyData);

      if (response is Map<String, dynamic>) {
        return AttendanceMarkResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("خطأ الـ Repo في mark attendance: $e");
      rethrow;
    }
  }

  Future<StudentAttendanceResponse> getStudentAttendanceHistory({
    required int studentId,
  }) async {
    try {
      final response = await apiService.get(
        '/attendance/student/$studentId/history',
      );

      if (response is Map<String, dynamic>) {
        return StudentAttendanceResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("خطأ الـ Repo في جلب غياب الطالب: $e");
      rethrow;
    }
  }

  Future<ClassAttendanceResponse> getClassAttendanceToday({
    required int classId,
  }) async {
    try {
      final response = await apiService.get(
        '/teacher/attendance/class/today/$classId',
      );

      if (response is Map<String, dynamic>) {
        return ClassAttendanceResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print("خطأ الـ Repo في جلب غياب الفصل لليوم: $e");
      rethrow;
    }
  }

  Future<QuizCreateResponse> addQuiz({
    required String classId,
    required String title,
    required String description,
    required String quizDate,
    required String totalMarks,
  }) async {
    try {
      final Map<String, dynamic> quizBody = {
        'class_id': classId,
        'title': title,
        'description': description,
        'quiz_date': quizDate,
        'total_marks': totalMarks,
      };

      final response = await apiService.post('/teacher/quizzes', quizBody);

      if (response is Map<String, dynamic>) {
        return QuizCreateResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<QuizListResponse> getClassQuizzes({required int classId}) async {
    try {
      final response = await apiService.get('/teacher/quizzes/$classId');

      if (response is Map<String, dynamic>) {
        return QuizListResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<QuizDeleteResponse> deleteQuiz({required int quizId}) async {
    try {
      final response = await apiService.delete('/teacher/quizzes/$quizId', {});

      if (response != null) {
        return QuizDeleteResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<QuizResultSaveResponse> saveStudentQuizResult({
    required String quizId,
    required int studentId,
    required String score,
  }) async {
    try {
      final Map<String, dynamic> resultBody = {
        'quiz_id': quizId,
        'student_id': studentId,
        'score': score,
      };

      final response = await apiService.post(
        '/teacher/quiz-results',
        resultBody,
      );

      if (response is Map<String, dynamic>) {
        return QuizResultSaveResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      rethrow;
    }
  }
}
