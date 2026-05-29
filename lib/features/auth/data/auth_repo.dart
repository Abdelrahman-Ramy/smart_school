import 'package:dio/dio.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/network/api_exception.dart';
import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  // login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post("/auth/login", {
        'email': email,
        'password': password,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected response from server');
      }

      final successRaw = response['success'];
      final success = successRaw == true || successRaw == 1;

      final msg = response['message'];

      // fail case
      if (!success) {
        throw ApiError(message: msg ?? 'Login failed');
      }

      final data = response['data'];

      if (data == null) {
        throw ApiError(message: 'Missing data from server');
      }

      final userData = data['user'];
      final token = data['token'];

      if (userData == null) {
        throw ApiError(message: 'Missing user data');
      }

      final user = UserModel.fromJson(userData);

      if (token != null) {
        await PrefHelper.saveToken(token);
      }

      return user;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // register
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await apiService.post("/auth/register", {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "phone": phone,
        "address": address,
      });
      print("RESPONSE: $response");
      print("FULL RESPONSE: ${response.toString()}");

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final success = response['success'];
        final msg = response['message'];

        final userData = response['data']?['user'];

        if (success != true || userData == null) {
          throw ApiError(message: msg ?? 'Unknown Error');
        }

        final user = UserModel.fromJson(userData);

        return user;
      } else {
        throw ApiError(message: 'Unexpected Error From Server');
      }
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
  // get profile

  // update profile

  // logout
}
