import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:uuid/uuid.dart';

import '../../domain/api/chat/IChatApi.dart';
import '../../mock_data.dart';
import '../../services/exception_notifier.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;

  List<Message> messages = [];
  final IChatApi _chatApi;
  final ExceptionNotifier exceptionNotifier;

  bool _isLoading = false;
  String? currentChatId;
  ChatProvider({
    required this.exceptionNotifier,
    required IChatApi chatApi,
  })  : _chatApi = chatApi,
        super() {
    loadApiKey();
  }

  void setCurrentChatId(String id) {
    currentChatId = id;
    // Clear the messages list to prevent showing old messages
    messages.clear();
    // You might want to fetch the messages for this chat here
    fetchMessagesForCurrentChat();
  }

  Future<void> fetchMessagesForCurrentChat() async {
    // Replace this with actual logic to get messages based on currentChatId
    // For example:
    if (currentChatId != null) {
      try {
        List<Message> fetchedMessages = mockMessages
            .where((element) => element.chatId == currentChatId)
            .toList();
        messages = fetchedMessages;
        notifyListeners();
      } catch (e) {
        // Handle exception
      }
    }
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

  String messageBuffer = '';
  void updateMessageBuffer(String newValue) {
    messageBuffer += newValue;
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
          chatId: currentChatId ?? '',
          isUser: true,
          role: EMessageRole.user);

      messages.add(message);
      notifyListeners();
      setLoading(true);

      _chatApi.createChatCompletionStream(messages).listen((event) {
        updateMessageBuffer(event.content);
      }, onDone: () {
        messages.add(
          Message(
            id: const Uuid().v4(),
            content: messageBuffer,
            sentAt: DateTime.now(),
            chatId: currentChatId ?? '',
            isUser: false,
            role: EMessageRole.assistant,
          ),
        );
        messageBuffer = '';
        notifyListeners();
        setLoading(false);
      });
      notifyListeners();
    } // catch only exceptions
    catch (e) {
      exceptionNotifier.addException(e);

      messages.add(
        Message(
          id: 'error',
          chatId: 'error',
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
