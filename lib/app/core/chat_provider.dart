import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;

  ChatProvider() {
    loadApiKey();
  }

  Future<void> loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('apiKey');
    if (apiKey is String && apiKey!.isNotEmpty) {
      OpenAI.apiKey = apiKey!;
    }
    notifyListeners();
  }

  Future<void> saveApiKey(String newApiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', newApiKey);
    apiKey = newApiKey;
    if (apiKey is String) {
      OpenAI.apiKey = apiKey!;
    }
    notifyListeners();
  }

  bool get isApiKeySet => apiKey != null && apiKey!.isNotEmpty;
}
