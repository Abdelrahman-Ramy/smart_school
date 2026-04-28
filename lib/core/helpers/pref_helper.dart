import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static SharedPreferences? _pref;
  static Future<void> init() async {
    _pref = await SharedPreferences.getInstance();
  }
  static const String _tokenKey = "auth_token";

  static Future<void> saveToken(String token) async {
    await _pref?.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    return _pref?.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    await _pref?.remove(_tokenKey);
  }
}
