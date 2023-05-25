import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:uuid/uuid.dart';

import '../../domain/api/chat/IChatApi.dart';
import '../../services/exception_notifier.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;

  List<Message> messages = [];
  final IChatApi _chatApi;
  final ExceptionNotifier exceptionNotifier;

  bool _isLoading = false;

  ChatProvider({
    required this.exceptionNotifier,
    required IChatApi chatApi,
  })  : _chatApi = chatApi,
        super() {
    loadApiKey();
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
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
      if (!isApiKeySet) {
        throw Exception('OpenAI API Key is not set');
      }
      final message = Message(
          id: const Uuid().v4(),
          content: content,
          sentAt: DateTime.now(),
          isUser: true,
          role: EMessageRole.user);

      messages.add(message);
      notifyListeners();
      setLoading(true);
      final response = await _chatApi.createChatCompletion(messages);

      final aiMessage = response;

      messages.add(aiMessage);
      setLoading(false);
      notifyListeners();
    } // catch only exceptions
    catch (e) {
      exceptionNotifier.addException(e);

      messages.add(
        Message(
          id: const Uuid().v4(),
          content:
              'Sorry, I am not feeling well today, apparently I have a bug 🐛. ${e.toString()}',
          sentAt: DateTime.now(),
          isUser: false,
          role: EMessageRole.system,
        ),
      );
      notifyListeners();
      setLoading(false);

      if (e is Error) {
        rethrow;
      }
    }
  }

  bool get isApiKeySet => apiKey != null && apiKey!.isNotEmpty;
}
