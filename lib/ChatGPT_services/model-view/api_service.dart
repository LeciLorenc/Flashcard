import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String BASE_URL = "https://api.openai.com/v1";
  static const String API_KEY = 'sk-proj-aQvYlyyW9KFv20a2bcR7T3BlbkFJc7NOWp5UzMTsulkUyUQr';

  static Future<String> sendMessageToChatGPT(String message) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse.containsKey('choices') && jsonResponse['choices'].isNotEmpty) {
        return jsonResponse['choices'][0]['message']['content'];
      } else {
        throw Exception('No response from ChatGPT');
      }
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}