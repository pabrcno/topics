import 'package:flutter/material.dart';
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

import '../../services/exception_handling_service.dart';

class ChatProvider with ChangeNotifier {
  List<Message> messages = [];
  final IChatApi _chatApi;
  final IChatRepository _chatRepository;
  final ErrorCommander errorCommander;
  bool _isLoading = false;

  Chat? currentChat;
  Topic? currentTopic;
  List<Topic> topics = [];
  List<Chat> currentTopicChats = [];

  ChatProvider({
    required IChatApi chatApi,
    required IChatRepository chatRepository,
    required this.errorCommander,
  })  : _chatApi = chatApi,
        _chatRepository = chatRepository,
        super();

  Future<void> fetchMessages() async {
    await errorCommander.run(() async {
      if (currentChat?.id != null) {
        setLoading(true);
        List<Message> fetchedMessages = await _chatRepository.getMessages(
          currentChat!.id,
        );

        messages = fetchedMessages;
        setLoading(false);
        notifyListeners();
      }
    });
  }

  Future<void> fetchTopics([String? userId]) async {
    await errorCommander.run(() async {
      setLoading(true);
      topics = await _chatRepository.getTopics(
        userId ?? authServiceProvider.getUser()!.uid,
      );
      setLoading(false);
    });
  }

  Future<void> fetchChatsForTopic(String topicId) async {
    await errorCommander.run(() async {
      setLoading(true);

      currentTopicChats = await _chatRepository.getChats(
        topicId,
      );
      setLoading(false);
    });
  }

  Future<void> setCurrentChat(Chat chat) async {
    await errorCommander.run(() async {
      currentChat = chat;
      // Clear the messages list to prevent showing old messages
      messages.clear();
      // You might want to fetch the messages for this chat here
      await fetchMessages();
    });
  }

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String messageBuffer = '';
  void updateMessageBuffer(String newValue) {
    messageBuffer += newValue;
    notifyListeners();
  }

  Future<void> sendMessage(String content) async {
    await errorCommander.run(() async {
      final message = Message(
          id: const Uuid().v4(),
          content: content,
          sentAt: DateTime.now(),
          chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
          isUser: true,
          role: EMessageRole.user);

      messages.add(message);

      await _chatRepository.createMessage(message);

      notifyListeners();
      _chatApi.createChatCompletionStream(messages).listen((event) {
        if (!isLoading) setLoading(true);
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

        await _chatRepository.createMessage(answer);
      });
    });
  }

  Future<void> createChat(String initialMessage, Topic topic) async {
    await errorCommander.run(() async {
      // Ensure we have an API key before proceeding

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
      currentChat = newChat;

      currentTopic = topic;
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
    });
  }

// Inside ChatProvider
  Future<void> fetchChatAndMessages(String chatId) async {
    await errorCommander.run(() async {
      if (currentChat == null) return;

      currentChat = await _chatRepository.getChat(chatId);

      messages = await _chatRepository.getMessages(chatId);
    });
  }

  Future<void> createTopic(String title, String initialMessage) async {
    await errorCommander.run(() async {
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
    });
  }

  void clearChatStates() {
    currentChat = null;
    currentChat = null;
    currentTopic = null;
    messages = [];
    notifyListeners();
  }
}
