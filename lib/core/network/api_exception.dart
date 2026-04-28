import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    // first get your data
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    // return message
    if (data is Map<String, dynamic> && data["message"] != null) {
      return ApiError(message: data["message"]);
    }

    // see this after api come
    if (statusCode == 302) {
      return ApiError(message: 'This Email Already Taken');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: 'Connection timeout. Please check your internet connection',
        );
      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request timeout. please try again");
      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Response timeout. please try again");

      default:
        return ApiError(message: 'Something Went Wrong, please try again');
    }
  }
}
