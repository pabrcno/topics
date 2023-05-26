import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:uuid/uuid.dart';

import '../../domain/api/chat/IChatApi.dart';
import '../../domain/models/chat/chat.dart';
import '../../domain/models/topic/topic.dart';
import '../../mock_data.dart';
import '../../services/exception_notifier.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;
  final userId = const Uuid().v4();
  List<Message> messages = [];
  final IChatApi _chatApi;
  final ExceptionNotifier exceptionNotifier;

  bool _isLoading = false;
  String? currentChatId;
  Chat? currentChat;
  Topic? currentTopic;
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
      _handleError(e);
    }
  }

  Future<void> createChat(String initialMessage, Topic topic) async {
    try {
      // Ensure we have an API key before proceeding
      if (!isApiKeySet) {
        throw Exception('OpenAI API Key is not set');
      }
      setLoading(true);

      // Define a unique id for the new chat
      final newChatId = const Uuid().v4();

      // Create a new Chat object
      final newChat = Chat(
        id: newChatId,
        userId: topic.userId, // replace with actual userId
        topicId: topic.id, // replace with actual topicId
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        summary: initialMessage, // using the initial message as a summary
      );

      // Send this new chat to your backend for storage
      // await _chatApi.createChat(newChat);

      // Then, send the initial message
      final initialMessageObject = Message(
        id: const Uuid().v4(),
        content: initialMessage,
        chatId: newChatId,
        sentAt: DateTime.now(),
        isUser: true,
        role: EMessageRole.user,
      );

      // Store this message in your backend as well
      // await _chatApi.createMessage(initialMessageObject);
      currentChatId = newChatId;
      currentChat = newChat;

      // Add the message to the messages list
      sendMessage(initialMessageObject.content);

      notifyListeners();

      setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic e) {
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
      throw e;
    }
  }

  Future<Chat> getChat(String chatId) async {
    // Fetch the chat from your backend based on the chatId.
    // Since we're mocking this function, I'll return a hardcoded Chat
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return Chat(
      id: chatId,
      userId: "userId", // replace with actual userId
      topicId: "topicId", // replace with actual topicId
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary: "This is a chat summary", // replace with actual summary
    );
  }

// Inside ChatProvider
  Future<void> fetchChatAndMessages() async {
    currentChat = Chat(
      id: currentChatId ?? '',
      userId: "userId", // replace with actual userId
      topicId: "topicId", // replace with actual topicId
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary: "This is a chat summary", // replace with actual summary
    ); // Assuming getChat is a method that fetches chat based on ID.
    // Assuming getMessages is a method that fetches messages for a chat.
    // add error handling as needed.
  }

  Future<void> createTopic(String title, String initialMessage) async {
    try {
      // Ensure we have an API key before proceeding
      if (!isApiKeySet) {
        throw Exception('OpenAI API Key is not set');
      }
      setLoading(true);

      // Define a unique id for the new topic
      final newTopicId = const Uuid().v4();

      // Create a new Topic object
      final newTopic = Topic(
        id: newTopicId,
        userId: userId,
        title: title, // set the topic title
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Send this new topic to your backend for storage
      // await _topicApi.createTopic(newTopic);

      // Now create a new Chat associated with this topic
      await createChat(initialMessage, newTopic);

      // Update the current topic
      currentTopic = newTopic;

      // Update local state if necessary
      setLoading(false);
    } catch (e) {
      _handleError(e);
    }
  }

  bool get isApiKeySet => apiKey != null && apiKey!.isNotEmpty;
}
