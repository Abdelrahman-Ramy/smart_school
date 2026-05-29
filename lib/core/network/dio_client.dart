import 'package:dio/dio.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
    baseUrl: "https://transparency-raleigh-informal-lemon.trycloudflare.com/api/v1",
    headers: { 
      'Content-Type': 'application/json',
      'Accept': 'application/json',}));
  DioClient() {
    _dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      print("🔥 REQUEST URL: ${options.baseUrl}${options.path}");
      print("🔥 REQUEST DATA: ${options.data}");
      print("🔥 REQUEST HEADERS: ${options.headers}");
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print("🔥 RESPONSE DATA: ${response.data}");
      return handler.next(response);
    },
    onError: (error, handler) {
      print("🔥 ERROR RESPONSE: ${error.response?.data}");
      print("🔥 ERROR STATUS: ${error.response?.statusCode}");
      return handler.next(error);
    },
  ),
);
  }
  Dio get dio => _dio;
}
