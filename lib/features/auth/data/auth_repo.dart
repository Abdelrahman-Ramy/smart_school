import 'package:dio/dio.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/network/api_error.dart';
import 'package:smart_school/core/network/api_exception.dart';
import 'package:smart_school/core/network/api_service.dart';
import 'package:smart_school/features/auth/data/change_password_model.dart';
import 'package:smart_school/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  // login
  Future<UserModel?> login(String email, String password) async {
    try {
      // Clear old token before starting a new login session
      await PrefHelper.clearToken();

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
      final token = data['token'] ?? response['token'];

      if (userData == null) {
        throw ApiError(message: 'Missing user data');
      }

      final user = UserModel.fromJson(userData);

      if (token != null) {
        await PrefHelper.saveToken(token);
        // FORCE update current dio headers if needed
        apiService.updateToken(token);
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
      // Clear old token before starting a new registration
      await PrefHelper.clearToken();

      final response = await apiService.post("/auth/register", {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
        "phone": phone,
        "address": address,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final success = response['success'];
        final msg = response['message'];
        final data = response['data'];

        // In some APIs, the data itself is the user, in others it's data['user']
        final userData =
            (data is Map<String, dynamic> && data.containsKey('user'))
            ? data['user']
            : data;

        final token =
            (data is Map<String, dynamic> && data.containsKey('token'))
            ? data['token']
            : response['token']; // check top level too just in case

        if (success != true || userData == null) {
          throw ApiError(message: msg ?? 'Unknown Error');
        }

        final user = UserModel.fromJson(userData);

        if (token != null) {
          await PrefHelper.saveToken(token);
          apiService.updateToken(token);
        } else {
          print("WARNING: No token found in register response");
        }

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
  Future<UserModel?> getProfile() async {
    try {
      final response = await apiService.get("/auth/profile");
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
        throw ApiError(message: msg ?? 'Failed to fetch profile');
      }

      final data = response['data'];

      if (data == null) {
        throw ApiError(message: 'Missing data from server');
      }

      final userData = data['user'];

      if (userData == null) {
        throw ApiError(message: 'Missing user data');
      }

      final user = UserModel.fromJson(userData);

      return user;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // update profile
  Future<UserModel?> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await apiService.put("/auth/profile", {
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
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
        throw ApiError(message: msg ?? 'Failed to update profile');
      }

      final data = response['data'];

      if (data == null) {
        throw ApiError(message: 'Missing data from server');
      }

      // Check if user data is wrapped in 'user' key or is directly in 'data'
      final userData =
          (data is Map<String, dynamic> && data.containsKey('user'))
          ? data['user']
          : data;

      if (userData == null) {
        throw ApiError(message: 'Missing user data');
      }

      final user = UserModel.fromJson(userData);

      return user;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // logout
  Future<void> logout() async {
    try {
      await PrefHelper.clearToken();
      apiService.updateToken(''); // Clear token in ApiService
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  // change password
  Future<ChangePasswordModel?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await apiService.put("/auth/password", {
        "current_password": currentPassword,
        "password": newPassword,
      });
      print({"current_password": currentPassword, "new_password": newPassword});

      if (response is! Map<String, dynamic>) {
        throw ApiError(message: 'Unexpected response from server');
      }

      final model = ChangePasswordModel.fromJson(response);

      if (!model.success) {
        throw ApiError(message: model.message);
      }

      return model;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
