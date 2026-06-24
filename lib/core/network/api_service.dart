import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_exception.dart';
import 'package:smart_school/core/network/dio_client.dart';

class ApiService {
  // to use dioClient into class
  final DioClient _dioClient = DioClient();

  void updateToken(String token) {
    _dioClient.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // CURD Methods

  /// get
  Future<dynamic> get(String endPoint) async {
    try {
      final response = await _dioClient.dio.get(endPoint);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// post
  // send body(email, pass)
  Future<dynamic> post(String endPoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// put || patch || update
  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// delete
  /// Sends parameters as query string and ensures the HTTP method is DELETE
  /// (some servers/proxies reject DELETE bodies or mis-handle Dio's delete with data).
  Future<dynamic> delete(String endPoint, [Map<String, dynamic>? body]) async {
    try {
      final response = await _dioClient.dio.request(
        endPoint,
        options: Options(method: 'DELETE'),
        queryParameters: body,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}
