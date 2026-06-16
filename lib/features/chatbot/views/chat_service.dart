import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl =
      'https://school-chatbot-api-production.up.railway.app/chat';

  Future<String> sendMessage(String question) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"question": question, "history": []}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["answer"];
    } else {
      throw Exception("Failed");
    }
  }
}
