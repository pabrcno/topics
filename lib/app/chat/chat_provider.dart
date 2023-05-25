import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/openAi/chat_api.dart';
import '../../services/exeption_notifier.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;
  final OpenAIChatApi _chatApi;
  List<OpenAIChatCompletionChoiceMessageModel> messages = [];

  final ExceptionNotifier exceptionNotifier;

  ChatProvider({required this.exceptionNotifier})
      : _chatApi = OpenAIChatApi(),
        super() {
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

  Future<void> sendMessage(String content) async {
    try {
      if (apiKey != null && apiKey!.isNotEmpty) {
        final message = OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: content,
        );
        messages.add(message);

        final response = await _chatApi.createChatCompletion(messages);

        final aiMessage = response.choices.first;
        messages.add(aiMessage.message);
        print(aiMessage.message.role);
        notifyListeners();
      } else {
        throw Exception('API Key is not set');
      }
    } catch (e) {
      exceptionNotifier.addException(e);
    }
  }

  bool get isApiKeySet => apiKey != null && apiKey!.isNotEmpty;
}
