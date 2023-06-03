import 'dart:async';

import 'package:flutter/material.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';
import 'package:topics/domain/repo/i_user_repository.dart';
import 'package:topics/domain/services/i_auth_service.dart';
import 'package:uuid/uuid.dart';

import '../../domain/api/chat/i_chat_api.dart';
import '../../domain/models/chat/chat.dart';
import '../../domain/models/topic/topic.dart';
import '../../main.dart';

import '../../presentation/chat/chat_screen.dart';

import '../../services/exception_handling_service.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages;

  set messages(List<Message> val) {
    _messages = val;
    notifyListeners();
  }

  final IChatApi _chatApi;
  final IChatRepository _chatRepository;
  final IUserRepository _userRepository;
  final ErrorCommander errorCommander = ErrorCommander();
  final IAuthService authServiceProvider;
  bool _isLoading = false;

  Chat? currentChat;
  Topic? currentTopic;
  List<Topic> topics = [];
  List<Chat> currentTopicChats = [];

  ChatProvider({
    required IChatApi chatApi,
    required IChatRepository chatRepository,
    required IUserRepository userRepository,
    required this.authServiceProvider,
  })  : _chatApi = chatApi,
        _chatRepository = chatRepository,
        _userRepository = userRepository,
        super();

  Future<void> fetchMessages() async {
    await errorCommander.run(() async {
      if (currentChat?.id != null) {
        setLoading(true);
        List<Message> fetchedMessages = await _chatRepository.getMessages(
          currentChat!.id,
        );

        fetchedMessages.sort(
          (a, b) => a.sentAt.compareTo(b.sentAt),
        );
        messages = fetchedMessages; // Use the setter here
        setLoading(false);
      }
    });
  }

  Future<void> fetchTopics([String? userId]) async {
    await errorCommander.run(() async {
      setLoading(true);
      topics = await _chatRepository.getTopics(
        userId ?? authServiceProvider.getCurrentUser()!.uid,
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

  String _messageBuffer = '';
  String get messageBuffer => _messageBuffer;

  set messageBuffer(String value) {
    _messageBuffer = value;
    notifyListeners();
  }

  Future<bool> _decrementUserMessages() async {
    return await _userRepository
        .getUser(authServiceProvider.getCurrentUser()?.uid ?? '')
        .then((user) async {
      if (user == null || user.messageCount <= 0) {
        messages.add(Message(
            id: 'warning',
            content:
                'It seems you ran out of messages. Please contact your admin.',
            chatId: currentChat?.id ?? '',
            sentAt: DateTime.now(),
            isUser: false,
            role: EMessageRole.system));
        notifyListeners();

        return false;
      }
      await _userRepository.reduceMessages(
          authServiceProvider.getCurrentUser()?.uid ?? '', 1);
      return true;
    });
  }

  StreamSubscription?
      streamSubscription; // Declare the StreamSubscription variable

  Future<void> sendMessage(String content) async {
    await errorCommander.run(() async {
      final message = Message(
        id: const Uuid().v4(),
        content: content,
        sentAt: DateTime.now(),
        chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
        isUser: true,
        role: EMessageRole.user,
      );

      messages.add(message);

      notifyListeners();
      setLoading(true);
      final userHasMessages = await _decrementUserMessages();
      if (!userHasMessages) throw Exception('You ran out of messages');

      final stream = await _chatApi.createChatCompletionStream(
          messages, currentChat?.temperature ?? 0.5);

      streamSubscription = stream.listen(
        (event) {
          messageBuffer = messageBuffer + event.content;
          setLoading(false);
        },
        onDone: () async {
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

          streamSubscription?.cancel();
          streamSubscription = null;
          notifyListeners();
          setLoading(false);

          await Future.wait([
            _chatRepository.createMessage(answer),
            _chatRepository.createMessage(message)
          ]);
        },
        onError: (e) {
          setLoading(false);
          throw Exception('Error while receiving message: $e');
        },
      );
    });
  }

  void stopStream() {
    streamSubscription?.cancel();
    streamSubscription = null; // Cancel the stream subscription if it exists
    messages.add(
      Message(
        id: const Uuid().v4(),
        content: messageBuffer,
        sentAt: DateTime.now(),
        chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
        isUser: false,
        role: EMessageRole.system,
      ),
    );
    messageBuffer = '';
    setLoading(false);
    notifyListeners();
  }

  Future<void> createChat(String? initialMessage, Topic topic) async {
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
        summary: initialMessage ??
            'New chat', // using the initial message as a summary
      );
      currentChat = newChat;

      currentTopicChats.add(newChat);

      currentTopic = topic;
      if (navigatorKey.currentState != null) {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chat: newChat,
              isNew: true,
            ), // your chat screen widget
          ),
        );
      }
      // Send this new chat to your backend for storage

      await _chatRepository.createChat(newChat).then((value) {
        if (initialMessage != null) {
          sendMessage(initialMessage);
          return;
        }
        setLoading(false);
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

  Future<void> createTopic(String title) async {
    await errorCommander.run(() async {
      setLoading(true);

      // Define a unique id for the new topic
      final newTopicId = const Uuid().v4();

      // Create a new Topic object
      final newTopic = Topic(
        id: newTopicId,
        userId: authServiceProvider.getCurrentUser()?.uid ?? '',
        title: title, // set the topic title
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
      );

      // Send this new topic to your backend for storage
      await _chatRepository.createTopic(newTopic);

      // Now create a new Chat associated with this topic
      await createChat(null, newTopic);

      // Update the current topic
      currentTopic = newTopic;
      await fetchTopics();
    });
  }

  Future<void> deleteTopic(Topic topic) async {
    await errorCommander.run(() async {
      setLoading(true);

      // Delete the topic from the repository
      await _chatRepository.deleteTopic(topic.id);

      // Remove the topic from the topics list
      topics.remove(topic);

      setLoading(false);
    });
  }

  Future<void> deleteChat(Chat chat) async {
    await errorCommander.run(() async {
      setLoading(true);

      // Delete the chat from the repository
      await _chatRepository.deleteChat(chat.id);

      // Remove the chat from the chats list
      currentTopicChats.remove(chat);

      setLoading(false);
    });
  }

  Future<void> modifyTopicTitle(Topic topicNewTitle) async {
    await errorCommander.run(() async {
      setLoading(true);

      // Modify the topic title in the repository
      await _chatRepository.updateTopic(topicNewTitle);

      // Update the topic title in the topics list

      final topicIndex =
          topics.indexWhere((topic) => topic.id == topicNewTitle.id);
      topics[topicIndex] = topicNewTitle;
      setLoading(false);
    });
  }

  Future<void> modifyChatSummary(Chat chatWithNewTitle) async {
    await errorCommander.run(() async {
      setLoading(true);

      // Modify the chat summary in the repository
      await _chatRepository.updateChat(chatWithNewTitle);

      // Update the chat summary in the chats list
      final chatIndex = currentTopicChats
          .indexWhere((chat) => chat.id == chatWithNewTitle.id);
      currentTopicChats[chatIndex] = chatWithNewTitle;
      setLoading(false);
    });
  }

  Future<void> setCurrentChatTemperature(double chatTemperature) async {
    if (currentChat == null) return;
    currentChat = currentChat?.copyWith(temperature: chatTemperature);
    await _chatRepository.updateChat(currentChat!);
    notifyListeners();
  }

  void clearChatStates() {
    currentChat = null;
    currentChat = null;
    currentTopic = null;
    messages = [];
    notifyListeners();
  }
}
