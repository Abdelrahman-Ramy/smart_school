import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorage {
  static const String key = "chat_messages";

  static Future<void> saveMessages(List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(messages);

    await prefs.setString(key, data);
  }

  static Future<List<Map<String, dynamic>>> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> clearMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
