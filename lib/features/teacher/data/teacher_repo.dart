import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/network/api_exception.dart';
import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/teacher/data/attendance_mark_model.dart';
import 'package:smart_school/features/teacher/data/class_attendance_model.dart';
import 'package:smart_school/features/teacher/data/material_response_model.dart';
import 'package:smart_school/features/teacher/data/quiz_model.dart';
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
      // Use the teacher classes endpoint which returns classes owned by the
      // authenticated teacher. The backend route is GET /api/v1/teacher/classes
      final response = await apiService.get("/teacher/classes");

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
          .map(
            (json) => TeacherClassModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  /// Fetch a single class by id from the teacher classes list.
  Future<TeacherClassModel?> fetchClassById(String classId) async {
    try {
      final classes = await fetchTeacherClasses();
      final idInt = int.tryParse(classId) ?? 0;
      for (final c in classes) {
        final cid = c.classId ?? c.id ?? 0;
        if (cid == idInt) return c;
      }
      return null;
    } catch (e) {
      return null;
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
        print("API Error: ${e.response?.data}");
      }
      rethrow;
    }
  }

  Future<SubmissionResponse> getAssignmentSubmissions({
    required int assignmentId,
  }) async {
    try {
      final response = await apiService.post(
        '/teacher/assignments/submissions',
        {'assignment_id': assignmentId},
      );

      // Log raw response for debugging runtime type issues
      try {
        print(
          'getAssignmentSubmissions raw response type: ${response.runtimeType}',
        );
        print('getAssignmentSubmissions raw response: $response');
      } catch (_) {}

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
    required dynamic studentId,
    required int classId,
    required String status,
  }) async {
    try {
      final Map<String, dynamic> bodyData = {
        'student_id': studentId,
        'class_id': classId,
        'status': status,
      };

      final response = await apiService.post(
        '/teacher/attendance/mark',
        bodyData,
      );

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
      final response = await apiService.get('/teacher/attendance/student/22');

      if (response is Map<String, dynamic>) {
        return StudentAttendanceResponse.fromJson(response);
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print(e);
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
      print(e);
      rethrow;
    }
  }

  Future<QuizModel?> createQuiz({
    required String title,
    required String maxScore,
  }) async {
    try {
      final response = await apiService.post('/teacher/quizzes', {
        'title': title,
        'max_score': maxScore,
      });

      if (response['success'] == true) {
        return QuizModel.fromJson(response['data']);
      }

      return null;
    } catch (e) {
      print('Create Quiz Error: $e');
      return null;
    }
  }

  Future<bool> saveGradeResult({
    required String title,
    required String studentId,
    required String score,
    required String maxScore,
  }) async {
    try {
      final response = await apiService.post('/teacher/grades-results', {
        'title': title,
        'student_id': studentId,
        'score': score,
        'max_score': maxScore,
      });

      return response['success'] == true;
    } catch (e) {
      print('Save Grade Error: $e');
      return false;
    }
  }

  Future<void> createNotification({
    required String receiverId,
    required String senderId,
    required String senderName,
    required String title,
    required String body,
    required String type,
    required String relatedId,
  }) async {
    try {
      print("CREATE NOTIFICATION CALLED");
      print("receiverId = $receiverId");

      final doc = await FirebaseFirestore.instance
          .collection('notifications')
          .add({
            'receiverId': receiverId,
            'senderId': senderId,
            'senderName': senderName,
            'title': title,
            'body': body,
            'type': type,
            'relatedId': relatedId,
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });

      print("Notification Created: ${doc.id}");
    } catch (e) {
      print("CREATE NOTIFICATION ERROR: $e");
    }
  }

  Future<String?> getFirebaseIdFromStudentApiId(String apiId) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('api_id', isEqualTo: apiId.toString())
        .limit(1)
        .get();
    print("QUERY RESULT: ${query.docs.length}");
    print("DATA: ${query.docs}");

    if (query.docs.isEmpty) return null;

    return query.docs.first.id;
  }
  // Future<QuizCreateResponse> addQuiz({
  //   required String classId,
  //   required String title,
  //   required String description,
  //   required String quizDate,
  //   required String totalMarks,
  // }) async {
  //   try {
  //     final Map<String, dynamic> quizBody = {
  //       'class_id': classId,
  //       'title': title,
  //       'description': description,
  //       'quiz_date': quizDate,
  //       'total_marks': totalMarks,
  //     };

  //     final response = await apiService.post('/teacher/quizzes', quizBody);

  //     if (response is Map<String, dynamic>) {
  //       return QuizCreateResponse.fromJson(response);
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<QuizListResponse> getClassQuizzes({required int classId}) async {
  //   try {
  //     final response = await apiService.get('/teacher/quizzes/$classId');

  //     if (response is Map<String, dynamic>) {
  //       return QuizListResponse.fromJson(response);
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
}

  // Future<QuizDeleteResponse> deleteQuiz({required int quizId}) async {
  //   try {
  //     final response = await apiService.delete('/teacher/quizzes/$quizId', {});

  //     if (response != null) {
  //       return QuizDeleteResponse.fromJson(response);
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<QuizResultSaveResponse> saveStudentQuizResult({
  //   required String quizId,
  //   required int studentId,
  //   required String score,
  // }) async {
  //   try {
  //     final Map<String, dynamic> resultBody = {
  //       'quiz_id': quizId,
  //       'student_id': studentId,
  //       'score': score,
  //     };

  //     final response = await apiService.post(
  //       '/teacher/quiz-results',
  //       resultBody,
  //     );

  //     if (response is Map<String, dynamic>) {
  //       return QuizResultSaveResponse.fromJson(response);
  //     } else {
  //       throw Exception('Unexpected response format');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
