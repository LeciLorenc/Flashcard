import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../main.dart';

class ApiService {
  //DO NOT UPDATE THIS, IS HERE ONLY FOR BE COPIED AND PASTED
  static String API_KEY = 'sk-proj-aQvYlyyW9KFv20a2bcR7T3BlbkFJc7NOWp5UzMTsulkUyUQr';
  static const String BASE_URL = "https://api.openai.com/v1";

  static Map<String, String> userApiKeys = {};
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  // Method to get the API key for a specific user
  static String getApiKey(String globalUserId) {
    return userApiKeys[globalUserId] ?? 'default-api-key-value';
  }

  // Method to set the API key for a specific user
  static Future<void> setApiKey(String globalUserId, String newKey) async {
    userApiKeys[globalUserId] = newKey;
    await _saveApiKeyToFile(globalUserId, newKey);
  }

  // Method to initialize API keys from files on app startup
  Future<void> initializeApiKeys() async {
    userApiKeys = await _readAllApiKeysFromFiles();
  }

  // Private method to get file object for a user's API key
  static Future<File> _getApiKeyFile(String globalUserId) async {
    String dir = await _getDocumentsDirectory();
    return File('$dir/api_key_$globalUserId.txt');
  }

  // Private method to read all API keys from files
  static Future<Map<String, String>> _readAllApiKeysFromFiles() async {
    Map<String, String> keys = {};
    String dir = await _getDocumentsDirectory();
    Directory directory = Directory(dir);
    List<FileSystemEntity> files = directory.listSync();
    for (var file in files) {
      if (file is File && file.path.endsWith('.txt')) {
        String userId = file.path.split('_').last.split('.').first;
        String apiKey = await file.readAsString();
        keys[userId] = apiKey;
      }
    }
    return keys;
  }

  // Private method to save API key to file for a specific user
  static Future<File> _saveApiKeyToFile(String globalUserId, String apiKey) async {
    final file = await _getApiKeyFile(globalUserId);
    return file.writeAsString(apiKey);
  }

  // Method to get documents directory path
  static Future<String> _getDocumentsDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }




  static Future<String> sendMessageToChatGPT(String message) async {
    String tempAPI = getApiKey(globalUserId);
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $tempAPI',
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