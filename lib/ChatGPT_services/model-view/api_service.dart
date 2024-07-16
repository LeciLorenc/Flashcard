import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiService {
  static const String BASE_URL = "https://api.openai.com/v1";
  //DO NOT UPDATE THIS, IS HERE ONLY FOR BE COPIED AND PASTED
  static String API_KEY = 'sk-proj-aQvYlyyW9KFv20a2bcR7T3BlbkFJc7NOWp5UzMTsulkUyUQr';
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  String get apiKey => API_KEY;

  set apiKey(String newKey) {
    API_KEY = newKey;
    _saveApiKeyToFile(newKey); // Save API key to file when it's updated
  }

  // Method to initialize API key from file on app startup
  Future<void> initializeApiKey() async {
    API_KEY = await _readApiKeyFromFile();
  }

  // Private method to get file object for API key
  static Future<File> _getApiKeyFile() async {
    // Get directory path for documents
    String dir = await _getDocumentsDirectory();
    return File('$dir/api_key.txt');
  }

  // Private method to read API key from file
  static Future<String> _readApiKeyFromFile() async {
    try {
      final file = await _getApiKeyFile();
      // Read the file
      return await file.readAsString();
    } catch (e) {
      // Return a default API key or handle error
      return 'default-api-key-value';
    }
  }

  // Private method to save API key to file
  static Future<File> _saveApiKeyToFile(String apiKey) async {
    final file = await _getApiKeyFile();
    // Write the file
    return file.writeAsString(apiKey);
  }

  // Method to get documents directory path
  static Future<String> _getDocumentsDirectory() async {
    // Determine platform-specific directory path
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }





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