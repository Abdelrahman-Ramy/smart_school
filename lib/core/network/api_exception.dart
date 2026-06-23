import 'package:dio/dio.dart';
import 'package:smart_school/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    
    if (data is Map<String, dynamic>) {

      // backend validation format
      if (data['errors'] != null) {
        final errors = data['errors'];

        String message = "";

        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            message += "${value.first}\n";
          }
        });

        return ApiError(message: message.trim());
      }

      // normal message
      if (data["message"] != null) {
        return ApiError(message: data["message"]);
      }
    }

    // status handling
    if (statusCode == 409) {
      return ApiError(message: "Email already exists");
    }
    if (statusCode == 422) {
      return ApiError(message: "Password is incorrect");
    }

    if (statusCode == 422) {
      return ApiError(message: "Validation error");
    }

    return ApiError(message: "Something went wrong");
  }
}