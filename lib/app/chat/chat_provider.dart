import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:topics/domain/api/image_generation/i_image_generation_api.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';
import 'package:topics/domain/repo/i_user_repository.dart';
import 'package:topics/domain/services/i_auth_service.dart';
import 'package:topics/services/notification_service.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../domain/api/chat/i_chat_api.dart';
import '../../domain/models/chat/chat.dart';
import '../../domain/models/image_generation_request/image_generation_request.dart';
import '../../domain/models/topic/topic.dart';
import '../../main.dart';

import '../../presentation/chat/chat_screen.dart';

import '../../services/exception_handling_service.dart';
import '../../utils/constants.dart';

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

  final IImageGenerationApi _imageGenerationApi;
  Chat? currentChat;
  Topic? currentTopic;
  List<Topic> topics = [];
  List<Chat> currentTopicChats = [];
  bool _isImageMode = false;
  List<Chat> userChats = [];
  String? _initImagePath;

  int _currentMessageIndex = 0;
  String? get initImagePath => _initImagePath;

  int get currentMessageIndex => _currentMessageIndex;

  set currentMessageIndex(int val) {
    _currentMessageIndex = val;
    notifyListeners();
  }

  set initImagePath(String? val) {
    _initImagePath = val;
    notifyListeners();
  }

  int userMessageCount = 0;
  ChatProvider({
    required IChatApi chatApi,
    required IChatRepository chatRepository,
    required IUserRepository userRepository,
    required IImageGenerationApi imageGenerationApi,
    required this.authServiceProvider,
  })  : _chatApi = chatApi,
        _chatRepository = chatRepository,
        _userRepository = userRepository,
        _imageGenerationApi = imageGenerationApi,
        currentChat = Chat(
            createdAt: DateTime.now(),
            id: const Uuid().v4(),
            summary: 'Chat',
            topicId: '',
            userId: authServiceProvider.getCurrentUser()?.uid ?? '',
            lastModified: DateTime.now()),
        super();

  set isImageMode(bool value) {
    _isImageMode = value;
    notifyListeners();
  }

  bool get isImageMode => _isImageMode;

  Future<void> fetchMessagesCount() async {
    await errorCommander.run(() async {
      setLoading(true);

      String userId = authServiceProvider.getCurrentUser()!.uid;
      final user = await _userRepository.getUser(userId);

      userMessageCount = user?.messageCount ?? 0;

      setLoading(false);
    });
  }

  Future<void> fetchUserChats() {
    return errorCommander.run(() async {
      setLoading(true);
      final fetched = await _chatRepository.getUserChats(
        authServiceProvider.getCurrentUser()!.uid,
      );
      fetched.sort(
        (a, b) => b.lastModified.compareTo(a.lastModified),
      );
      userChats = fetched;
      setLoading(false);
    });
  }

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
      final fetched = await _chatRepository.getTopics(
        userId ?? authServiceProvider.getCurrentUser()!.uid,
      );
      fetched.sort(
        (a, b) => a.lastModified.compareTo(b.lastModified),
      );

      topics = fetched;
      setLoading(false);
    });
  }

  Future<void> fetchChatsForTopic(String topicId) async {
    await errorCommander.run(() async {
      setLoading(true);

      final fetched = await _chatRepository.getChats(
        topicId,
      );

      fetched.sort(
        (a, b) => a.lastModified.compareTo(b.lastModified),
      );

      currentTopicChats = fetched;
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

  Future<bool> _decrementUserMessages({int decrementValue = 1}) async {
    return await _userRepository
        .getUser(authServiceProvider.getCurrentUser()?.uid ?? '')
        .then((user) async {
      userMessageCount = user?.messageCount ?? 0;
      if (user == null || user.messageCount <= 0) {
        messages.add(Message(
            id: 'warning',
            content:
                'It seems you ran out of messages. Please contact your admin.',
            chatId: currentChat?.id ?? '',
            sentAt: DateTime.now(),
            isUser: false,
            role: EMessageRole.system));
        setLoading(false);
        notifyListeners();
        return false;
      }
      await _userRepository.reduceMessages(
          authServiceProvider.getCurrentUser()?.uid ?? '', decrementValue);
      return true;
    });
  }

  StreamSubscription?
      streamSubscription; // Declare the StreamSubscription variable

  Future<void> sendMessage(String content) async {
    await errorCommander.run(() async {
      final message = await _prepareChatAndMessage(content);

      await _validateUserHasMessages();

      final stream = await _createChatStream(messages
          .where((element) =>
              element.role == EMessageRole.user ||
              element.role == EMessageRole.assistant)
          .toList());
      final platformAllowsVibration = _checkPlatformForVibration();

      await _listenToStream(
          stream, platformAllowsVibration, message, EMessageRole.assistant);
    });
  }

  Future<Message> _prepareChatAndMessage(String content) async {
    final message = _createNewUserMessage(content);

    messages.add(message);

    if (!userChats.map((e) => e.id).contains(currentChat?.id)) {
      if (currentChat?.summary == 'Chat') {
        currentChat = currentChat?.copyWith(
          summary: message.content,
        );
      }

      userChats.add(currentChat!);
      userChats.sort(
        (a, b) => b.lastModified.compareTo(a.lastModified),
      );

      await _chatRepository.createChat(currentChat!);
    }
    currentMessageIndex = messages.length - 1;
    notifyListeners();

    setLoading(true);
    return message;
  }

  Message _createNewUserMessage(String content) {
    return Message(
      id: const Uuid().v4(),
      content: content,
      sentAt: DateTime.now(),
      chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
      isUser: true,
      role: EMessageRole.user,
    );
  }

  Future<void> _validateUserHasMessages() async {
    final userHasMessages = await _decrementUserMessages();
    if (!userHasMessages) throw Exception('You ran out of messages');
  }

  Future<Stream> _createChatStream(List<Message> chatMessages) async {
    return await _chatApi.createChatCompletionStream(
        chatMessages, currentChat?.temperature ?? 0.7);
  }

  bool _checkPlatformForVibration() {
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _listenToStream(Stream stream, bool platformAllowsVibration,
      Message message, EMessageRole answerRole) async {
    streamSubscription = stream.listen(
      (event) {
        _handleStreamEvent(event, platformAllowsVibration);
      },
      onDone: () {
        _handleStreamDone(message, answerRole);
      },
      onError: _handleStreamError,
    );
  }

  Future<void> _listenToStreamNotification(
      Stream stream,
      bool platformAllowsVibration,
      Message message,
      EMessageRole answerRole) async {
    streamSubscription = stream.listen(
      (event) {
        _handleStreamEvent(event, platformAllowsVibration);
        NotificationService.updateChatNotification(
            messageBuffer, EMessageRole.assistant, isLoading);
      },
      onDone: () {
        _handleNotificationStreamDone(message, answerRole);
      },
      onError: _handleStreamError,
    );
  }

  void _handleStreamEvent(event, bool platformAllowsVibration) {
    messageBuffer = messageBuffer + event.content;
    if (platformAllowsVibration) {
      Vibration.vibrate(amplitude: 20, duration: 10);
    }
  }

  void _handleStreamDone(Message message, EMessageRole answerRole) async {
    final answer = Message(
      id: const Uuid().v4(),
      content: messageBuffer,
      sentAt: DateTime.now(),
      chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
      isUser: false,
      role: answerRole,
    );

    messages.add(answer);
    messageBuffer = '';

    _cancelStreamSubscription();
    notifyListeners();
    setLoading(false);

    await Future.wait([
      _chatRepository.createMessage(answer),
      _chatRepository.createMessage(message)
    ]);
    currentMessageIndex = messages.length - 1;
    final hasAmplitude = await Vibration.hasAmplitudeControl() ?? false;
    if (hasAmplitude) Vibration.vibrate(duration: 100);
  }

  void _handleNotificationStreamDone(
      Message message, EMessageRole answerRole) async {
    final answer = Message(
      id: const Uuid().v4(),
      content: messageBuffer,
      sentAt: DateTime.now(),
      chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
      isUser: false,
      role: answerRole,
    );

    messages.add(answer);

    messageBuffer = '';

    _cancelStreamSubscription();
    notifyListeners();
    setLoading(false);

    currentMessageIndex = messages.length - 1;
    NotificationService.updateChatNotification(
        messages.last.content, EMessageRole.assistant, isLoading);

    await Future.wait([
      _chatRepository.createMessage(answer),
      _chatRepository.createMessage(message)
    ]);
  }

  void _cancelStreamSubscription() {
    streamSubscription?.cancel();
    streamSubscription = null;
  }

  void _handleStreamError(e) {
    messageBuffer = '';
    setLoading(false);
    throw Exception('Error while receiving message: $e');
  }

  Future<void> clearChat() async {
    setLoading(true);
    // Define a unique id for the new chat
    final newChatId = const Uuid().v4();

    // Create a new Chat object
    final newChat = Chat(
      id: newChatId,
      userId: authServiceProvider
          .getCurrentUser()!
          .uid, // replace with actual userId
      topicId: currentTopic?.id ?? '', // replace with actual topicId
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary: 'Chat', // using the initial message as a summary
    );
    currentChat = newChat;

    messages = [];

    messages.clear();
    setLoading(false);
  }

  Future<void> createChat(Topic? topic) async {
    await errorCommander.run(() async {
      // Ensure we have an API key before proceeding

      setLoading(true);

      // Define a unique id for the new chat
      final newChatId = const Uuid().v4();

      // Create a new Chat object
      final newChat = Chat(
        id: newChatId,
        userId: authServiceProvider
            .getCurrentUser()!
            .uid, // replace with actual userId
        topicId: topic?.id ?? '', // replace with actual topicId
        createdAt: DateTime.now(),
        lastModified: DateTime.now(),
        summary:
            'Chat ${newChatId.substring(0, 4)}', // using the initial message as a summary
      );
      currentChat = newChat;

      messages = [];

      currentTopic = topic;
      if (navigatorKey.currentState != null) {
        Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
            builder: (context) => const ChatScreen(), // your chat screen widget
          ),
        );
      }
      // Send this new chat to your backend for storage

      setLoading(false);
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
      await createChat(newTopic);

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

      userChats.remove(chat);

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

      if (await _chatRepository.getChat(chatWithNewTitle.id) == null) {
        await _chatRepository.createChat(chatWithNewTitle);
        userChats.add(chatWithNewTitle);
        currentChat = chatWithNewTitle;

        setLoading(false);
        return;
      }

      // Modify the chat summary in the repository
      await _chatRepository.updateChat(chatWithNewTitle);

      // Update the chat summary in the chats list
      final chatIndex = currentTopicChats
          .indexWhere((chat) => chat.id == chatWithNewTitle.id);
      if (chatIndex != -1) {
        currentTopicChats[chatIndex] = chatWithNewTitle;
      }
      final userChatIndex =
          userChats.indexWhere((chat) => chat.id == chatWithNewTitle.id);
      if (userChatIndex != -1) {
        userChats[userChatIndex] = chatWithNewTitle;
      }
      currentChat = chatWithNewTitle;

      setLoading(false);
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

  Future<void> setCurrentChatTemperature(double chatTemperature) async {
    if (currentChat == null) return;
    currentChat = currentChat?.copyWith(temperature: chatTemperature);
    await _chatRepository.updateChat(currentChat!);
    notifyListeners();
  }

  Future<void> sendImageGenerationRequest({
    required String prompt,
    required double weight,
    required int height,
    required int width,
    String? initImageMode,
    List<Map<String, dynamic>>? textPrompts,
    String? clipGuidancePreset,
    String? sampler,
    int? samples,
  }) async {
    await errorCommander.run(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int steps = (prefs.getInt(ImageEqSharedPrefKeys.steps) ?? 50);
      double imageStrength =
          (prefs.getDouble(ImageEqSharedPrefKeys.imageStrength) ?? 0.35);
      int cfgScale = (prefs.getInt(ImageEqSharedPrefKeys.cfgScale) ?? 7);
      String? stylePreset =
          (prefs.getString(ImageEqSharedPrefKeys.stylePreset));

      if (!userChats
          .map(
            (chat) => chat.id,
          )
          .contains(currentChat?.id)) {
        if (currentChat!.summary == 'Chat') {
          currentChat = currentChat!.copyWith(summary: prompt);
        }
        await _chatRepository.createChat(currentChat!);
      }
      if (currentChat == null) return;
      setLoading(true);
      // Create a new ImageGenerationRequest object
      final newImageGenerationRequest = ImageGenerationRequest(
          prompt: prompt,
          weight: weight,
          height: height,
          width: width,
          steps: steps,
          chatId: currentChat!.id,
          imageStrength: initImagePath != null ? imageStrength : null,
          initImageMode: initImagePath != null ? "IMAGE_STRENGTH" : null,
          initImage: initImagePath != null
              ? const Base64Codec().encode(
                  File(initImagePath!).readAsBytesSync(),
                )
              : null,
          cfgScale: cfgScale,
          stylePreset: stylePreset == '' ? null : stylePreset);

      final userMessage = Message(
        id: const Uuid().v4(),
        content: prompt,
        sentAt: DateTime.now(),
        chatId: currentChat!.id,
        isUser: true,
        role: EMessageRole.user,
      );
      messages.add(userMessage);
      notifyListeners();
      await _chatRepository.createMessage(userMessage);
      final userHasMessages =
          await _decrementUserMessages(decrementValue: (steps ~/ 20).toInt());

      // Send this new image generation request to your backend for storage
      if (!userHasMessages) {
        setLoading(false);
        return;
      }
      final hasAmplitudeControl =
          await Vibration.hasAmplitudeControl() ?? false;
      final imageMessages =
          await _imageGenerationApi.generateImage(newImageGenerationRequest);
      messages.addAll(imageMessages);

      await Future.wait(imageMessages
          .map((message) => _chatRepository.createMessage(message)));

      setLoading(false);

      notifyListeners();
      if (hasAmplitudeControl) {
        Vibration.vibrate(duration: 500, amplitude: 20);
      }
    }, onError: (e) {
      setLoading(false);
      throw Exception('Error while sending image generation request: $e');
    });
  }

  Future<void> changeChatTopicId(String topicId, Chat? chat) async {
    await errorCommander.run(() async {
      if (chat != null) {
        await _chatRepository.updateChat(chat.copyWith(topicId: topicId));
        return;
      }
      currentChat = currentChat?.copyWith(topicId: topicId);
      await _chatRepository.updateChat(currentChat!.copyWith(topicId: topicId));
      notifyListeners();
    });
  }

  Future<void> generateMessageSearch(String title, Message message) async {
    final prompt =
        "Generate some google search links from the message content. Example: [search content](https://www.google.com/search?q=search%20content), include only the search list in your answer adn follow the markdown syntax for links. Message Content: ${message.content}";
    await errorCommander.run(() async {
      final searchMessage = Message(
        id: const Uuid().v4(),
        content: prompt,
        sentAt: DateTime.now(),
        chatId: currentChat?.id ?? 'EMPTY_CHAT_ID',
        isUser: true,
        role: EMessageRole.user,
      );

      await errorCommander.run(() async {
        await _validateUserHasMessages();

        final stream = await _createChatStream([searchMessage]);
        final platformAllowsVibration = _checkPlatformForVibration();

        messageBuffer += title;

        await _listenToStream(stream, platformAllowsVibration, message,
            EMessageRole.searchAssistant);
      });
    });
  }

  Future<void> sendNotificationImageGenerationRequest({
    required String prompt,
    required double weight,
    required int height,
    required int width,
    String? initImageMode,
    List<Map<String, dynamic>>? textPrompts,
    String? clipGuidancePreset,
    String? sampler,
    int? samples,
  }) async {
    await errorCommander.run(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      int steps = (prefs.getInt(ImageEqSharedPrefKeys.steps) ?? 50);
      double imageStrength =
          (prefs.getDouble(ImageEqSharedPrefKeys.imageStrength) ?? 0.35);
      int cfgScale = (prefs.getInt(ImageEqSharedPrefKeys.cfgScale) ?? 7);
      String? stylePreset =
          (prefs.getString(ImageEqSharedPrefKeys.stylePreset));

      if (!userChats
          .map(
            (chat) => chat.id,
          )
          .contains(currentChat?.id)) {
        if (currentChat!.summary == 'Chat') {
          currentChat = currentChat!.copyWith(summary: prompt);
        }
        await _chatRepository.createChat(currentChat!);
      }
      if (currentChat == null) return;
      setLoading(true);
      // Create a new ImageGenerationRequest object
      final newImageGenerationRequest = ImageGenerationRequest(
          prompt: prompt,
          weight: weight,
          height: height,
          width: width,
          steps: steps,
          chatId: currentChat!.id,
          imageStrength: initImagePath != null ? imageStrength : null,
          initImageMode: initImagePath != null ? "IMAGE_STRENGTH" : null,
          initImage: initImagePath != null
              ? const Base64Codec().encode(
                  File(initImagePath!).readAsBytesSync(),
                )
              : null,
          cfgScale: cfgScale,
          stylePreset: stylePreset == '' ? null : stylePreset);

      final userMessage = Message(
        id: const Uuid().v4(),
        content: prompt,
        sentAt: DateTime.now(),
        chatId: currentChat!.id,
        isUser: true,
        role: EMessageRole.user,
      );
      messages.add(userMessage);
      notifyListeners();
      await _chatRepository.createMessage(userMessage);
      final userHasMessages =
          await _decrementUserMessages(decrementValue: (steps ~/ 20).toInt());

      // Send this new image generation request to your backend for storage
      if (!userHasMessages) {
        setLoading(false);
        return;
      }
      final hasAmplitudeControl =
          await Vibration.hasAmplitudeControl() ?? false;
      final imageMessages =
          await _imageGenerationApi.generateImage(newImageGenerationRequest);
      messages.addAll(imageMessages);
      NotificationService.updateChatNotification(
          messages.last.content, EMessageRole.imageAssistant, isLoading);
      await Future.wait(imageMessages
          .map((message) => _chatRepository.createMessage(message)));

      setLoading(false);

      notifyListeners();
      if (hasAmplitudeControl) {
        Vibration.vibrate(duration: 500, amplitude: 20);
      }
    }, onError: (e) {
      setLoading(false);
      throw Exception('Error while sending image generation request: $e');
    });
  }

  Future<void> sendNotificationMessage(String content) async {
    await errorCommander.run(() async {
      final message = await _prepareChatAndMessage(content);
      await _validateUserHasMessages();

      final stream = await _createChatStream(messages
          .where((element) =>
              element.role == EMessageRole.user ||
              element.role == EMessageRole.assistant)
          .toList());
      final platformAllowsVibration = _checkPlatformForVibration();

      await _listenToStreamNotification(
          stream, platformAllowsVibration, message, EMessageRole.assistant);
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
