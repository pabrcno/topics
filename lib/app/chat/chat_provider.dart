import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';
import 'package:topics/services/auth_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/api/chat/i_chat_api.dart';
import '../../domain/models/chat/chat.dart';
import '../../domain/models/topic/topic.dart';
import '../../main.dart';

import '../../presentation/chat/chat_screen.dart';
import '../../services/exception_notifier.dart';
import '../../utils/constants.dart';

class ChatProvider with ChangeNotifier {
  String? apiKey;

  List<Message> messages = [];
  final IChatApi _chatApi;
  final IChatRepository _chatRepository;
  final ExceptionNotifier exceptionNotifier;

  bool _isLoading = false;

  Chat? currentChat;
  Topic? currentTopic;
  List<Topic> topics = [];
  List<Chat> currentTopicChats = [];

  ChatProvider({
    required this.exceptionNotifier,
    required IChatApi chatApi,
    required IChatRepository chatRepository,
  })  : _chatApi = chatApi,
        _chatRepository = chatRepository,
        super() {
    loadApiKey();
    _init();
  }

  void _init() async {
    await fetchTopics();
    notifyListeners(); // Notifies listeners about the change
  }

  Future<void> fetchMessages() async {
    if (currentChat?.id != null) {
      setLoading(true);
      List<Message> fetchedMessages = await _chatRepository.getMessages(
        currentChat!.id,
      );
      setLoading(false);
      messages = fetchedMessages;
      notifyListeners();
    }
  }

  Future<void> fetchTopics() async {
    setLoading(true);
    topics = await _chatRepository.getTopics(
      authServiceProvider.getUser()!.uid,
    );
    setLoading(false);
  }

  Future<void> fetchChatsForTopic(String topicId) async {
    setLoading(true);
    currentTopicChats = await _chatRepository.getChats(
      topicId,
    );
    setLoading(false);
  }

  void setCurrentChat(Chat chat) {
    currentChat = chat;
    // Clear the messages list to prevent showing old messages
    messages.clear();
    // You might want to fetch the messages for this chat here
    fetchMessages();
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiKey = prefs.getString('apiKey');
    if (apiKey is String && apiKey!.length == OPENAI_API_KEY_LENGTH) {
      OpenAI.apiKey = apiKey!;
      notifyListeners();
    }
  }

  Future<bool> saveApiKey(String newApiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', newApiKey);
    apiKey = newApiKey;
    if (apiKey is String) {
      OpenAI.apiKey = apiKey!;
      notifyListeners();
      return true;
    }
    return false;
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
          chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
          isUser: true,
          role: EMessageRole.user);

      messages.add(message);
      notifyListeners();
      setLoading(true);

      _chatApi.createChatCompletionStream(messages).listen((event) {
        updateMessageBuffer(event.content);
      }, onDone: () async {
        final answer = Message(
          id: const Uuid().v4(),
          content: messageBuffer,
          sentAt: DateTime.now(),
          chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
          isUser: false,
          role: EMessageRole.assistant,
        );

        messages.add(answer);
        messageBuffer = '';

        notifyListeners();
        setLoading(false);
        _chatRepository.createMessage(message);
        _chatRepository.createMessage(answer);
      });
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

      clearChatStates();

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

      Navigator.push(
        navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chat: newChat,
            isNew: true,
          ), // your chat screen widget
        ),
      );
      // Send this new chat to your backend for storage
      await _chatRepository.createChat(newChat).then((value) {
        sendMessage(initialMessage);
      });
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
            'Sorry, I am not feeling well today, apparently I have a bug 🐛.\n ${e.toString()}',
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

// Inside ChatProvider
  Future<void> fetchChatAndMessages(String chatId) async {
    if (currentChat == null) return;

    currentChat = await _chatRepository.getChat(chatId);

    messages = await _chatRepository.getMessages(chatId);
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
        userId: authServiceProvider.getUser()?.uid ?? '',
        title: title, // set the topic title
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Send this new topic to your backend for storage
      await _chatRepository.createTopic(newTopic);

      // Now create a new Chat associated with this topic
      await createChat(initialMessage, newTopic);

      // Update the current topic
      currentTopic = newTopic;
      await fetchTopics();
    } catch (e) {
      _handleError(e);
    }
  }

  bool get isApiKeySet => apiKey != null && apiKey!.isNotEmpty;

  void clearChatStates() {
    currentChat = null;
    currentChat = null;
    currentTopic = null;
    messages = [];
    notifyListeners();
  }

  void clearOpenAiStates() {
    apiKey = null;
    OpenAI.apiKey = "YOUR_API_KEY_HERE";
    notifyListeners();
  }
}
