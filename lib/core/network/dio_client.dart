import 'package:dio/dio.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: " ", headers: {" ": " "}));
  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await PrefHelper.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
