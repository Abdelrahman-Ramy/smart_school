import 'package:dio/dio.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://13.53.168.190/api/v1",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await PrefHelper.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print("REQUEST URL: ${options.baseUrl}${options.path}");
          print("REQUEST DATA: ${options.data}");
          print("REQUEST HEADERS: ${options.headers}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("RESPONSE DATA: ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("ERROR RESPONSE: ${error.response?.data}");
          print("ERROR STATUS: ${error.response?.statusCode}");
          return handler.next(error);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
