import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:topics/app/chat/chat_provider.dart';
import 'package:topics/domain/models/auth/app_user_credential.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/models/topic/topic.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';
import 'package:topics/domain/api/chat/i_chat_api.dart';
import 'package:topics/domain/repo/i_user_repository.dart';
import 'package:topics/domain/services/i_auth_service.dart';
import 'package:topics/services/exception_handling_service.dart';

@GenerateMocks([IChatRepository, IChatApi, IUserRepository])
import 'chat_provider_test.mocks.dart';
import 'mocks.dart';

class MockErrorCommander extends Mock implements ErrorCommander {
  @override
  Future<T> run<T>(Future<T> Function() execute,
      {void Function(dynamic)? onError}) async {
    try {
      return await execute();
    } catch (error) {
      rethrow;
    }
  }
}

class MockAuthService extends Mock implements IAuthService {
  final AppUserCredential _mockAppUserCredential = const AppUserCredential(
    uid: 'testUid',
    email: 'testEmail',
    displayName: 'testDisplayName',
    photoURL: 'testPhotoURL',
    emailVerified: true,
  );

  @override
  AppUserCredential? getCurrentUser() {
    return _mockAppUserCredential;
  }
}

void main() {
  late ChatProvider chatProvider;
  late MockIChatApi mockChatApi;
  late MockIChatRepository mockChatRepository;

  late MockAuthService mockAuthService;
  late MockIUserRepository mockUserRepository;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Initialize Mock classes
    mockChatApi = MockIChatApi();
    mockChatRepository = MockIChatRepository();

    mockAuthService = MockAuthService();
    mockUserRepository = MockIUserRepository();

    // Pass mock objects to the ChatProvider
    chatProvider = ChatProvider(
      chatApi: mockChatApi,
      chatRepository: mockChatRepository,
      userRepository: mockUserRepository,
      authServiceProvider: mockAuthService,
    );
  });

  tearDown(() {
    // Reset mockito state to avoid mock interactions and verifications
    // from leaking between test cases.
    resetMockitoState();
  });

  test('ChatProvider initializes with correct values', () {
    expect(chatProvider.messageBuffer, equals(''));
    expect(chatProvider.messages, equals([]));

    expect(chatProvider.currentChat, isNull);
    expect(chatProvider.currentTopic, isNull);
  });

  test('fetchMessages function runs when setting a chat', () async {
    // Set up the stub for getMessages
    when(mockChatRepository.getMessages('chat1'))
        .thenAnswer((_) async => mockMessages);

    await chatProvider.setCurrentChat(mockChat);

    // Verify the method was called with the expected argument
    verify(mockChatRepository.getMessages(mockChat.id)).called(1);
    expect(chatProvider.messages, equals(mockMessages));
    expect(chatProvider.isLoading, equals(false));
  });

  test('fetchTopics function works as expected', () async {
    // Set up the stub for getTopics
    when(mockChatRepository.getTopics('user1'))
        .thenAnswer((_) async => mockTopics);

    await chatProvider.fetchTopics('user1');

    // Verify the method was called with the expected argument
    verify(mockChatRepository.getTopics('user1')).called(1);
    expect(chatProvider.topics, equals(mockTopics));
    expect(chatProvider.isLoading, equals(false));
  });

  test('fetchChatsForTopic function works as expected', () async {
    when(mockChatRepository.getChats('topic1'))
        .thenAnswer((_) async => mockChats);

    await chatProvider.fetchChatsForTopic('topic1');

    verify(mockChatRepository.getChats('topic1')).called(1);
    expect(chatProvider.currentTopicChats, equals(mockChats));
    expect(chatProvider.isLoading, equals(false));
  });

  test('setCurrentChat function works as expected', () async {
    // Set up the stub for getMessages
    when(mockChatRepository.getMessages(mockChat.id))
        .thenAnswer((_) async => mockMessages);

    await chatProvider.setCurrentChat(mockChat);

    // Verify the method was called with the expected argument
    verify(mockChatRepository.getMessages(mockChat.id)).called(1);
    expect(chatProvider.messages, equals(mockMessages));
    expect(chatProvider.isLoading, equals(false));
  });

  test('sendMessage adds the message to messages list', () async {
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithMessages);

    const mockContent = 'Hello!';
    final mockEvent = mockMessage;

    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockEvent);
      controller.close();
      return controller.stream;
    });

    await chatProvider.sendMessage(mockContent);

    // check if the message is in the list
    expect(
        chatProvider.messages.any((msg) => msg.content == mockContent), isTrue);
  });

  test('sendMessage creates a message with correct properties', () async {
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithMessages);

    const mockContent = 'Hello!';
    final mockEvent = mockMessage;

    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockEvent);
      controller.close();
      return controller.stream;
    });

    await chatProvider.sendMessage(mockContent);

    final message =
        chatProvider.messages.firstWhere((msg) => msg.content == mockContent);
    expect(message.content, mockContent);
    expect(message.isUser, true);
    expect(message.chatId, isNotNull);
  });

  test('sendMessage completes when the user has messages', () async {
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithMessages);
    const mockContent = 'Hello!';
    final mockEvent = mockMessage;

    // Mock the necessary dependencies
    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockEvent);
      controller.close();
      return controller.stream;
    });

    // Invoke the method and await the result
    await chatProvider.sendMessage(mockContent);

    // Verify the result
    expect(mockChatRepository.createMessage(mockEvent), completes);
    expect(
        chatProvider.messages
            .firstWhere((element) => (element.content == mockContent)),
        isNotNull);
    expect(chatProvider.messageBuffer, equals(''));
  });

  test('sendMessage throws exception when the user has no messages', () async {
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithoutMessages);
    const mockContent = 'Hello!';
    final mockEvent = mockMessage;

    // Mock the necessary dependencies
    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockEvent);
      controller.close();
      return controller.stream;
    });

    expectLater(
      chatProvider.sendMessage(mockContent),
      throwsA(isA<Exception>()),
    );
  });
  test('createChat creates a new chat and adds it to currentTopicChats',
      () async {
    when(mockChatRepository.createChat(any)).thenAnswer((_) async {});
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithMessages);
    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockMessage);
      controller.close();
      return controller.stream;
    });

    await chatProvider.createChat(mockMessage.content, mockTopic);

    // Check if new chat is created
    expect(
        chatProvider.currentTopicChats
            .any((chat) => chat.summary == mockMessage.content),
        isTrue);
    // Check if loading status is false after execution
  });

  test('createTopic creates a new topic and adds it to topics', () async {
    final Topic mockTopicNewTitle = Topic(
      id: 'topic1',
      title: 'topic1',
      lastModified: DateTime.now(),
      userId: '',
      createdAt: DateTime.now(),
    );
    when(mockUserRepository.getUser(any))
        .thenAnswer((_) async => mockAppUserWithMessages);
    when(mockChatRepository.createTopic(any)).thenAnswer((_) async {});
    when(mockChatRepository.getTopics(any))
        .thenAnswer((_) async => mockTopics..add(mockTopicNewTitle));
    when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
      final controller = StreamController<Message>();
      controller.add(mockMessage);
      controller.close();
      return controller.stream;
    });

    const mockInitialMessage = 'Hello!';
    await chatProvider.createTopic(mockTopicNewTitle.title, mockInitialMessage);

    // Check if new topic is created
    expect(
        chatProvider.topics
            .any((topic) => topic.title == mockTopicNewTitle.title),
        isTrue);
  });

  test('deleteTopic deletes a topic and removes it from topics', () async {
    when(mockChatRepository.deleteTopic(any)).thenAnswer((_) async {});

    await chatProvider.deleteTopic(mockTopic);

    // Check if the topic is deleted
    expect(
        chatProvider.topics.any((topic) => topic.id == mockTopic.id), isFalse);
    // Check if loading status is false after execution
    expect(chatProvider.isLoading, equals(false));
  });

  test('deleteChat deletes a chat and removes it from currentTopicChats',
      () async {
    when(mockChatRepository.deleteChat(any)).thenAnswer((_) async {});

    await chatProvider.deleteChat(mockChat);

    // Check if the chat is deleted
    expect(chatProvider.currentTopicChats.any((chat) => chat.id == mockChat.id),
        isFalse);
    // Check if loading status is false after execution
    expect(chatProvider.isLoading, equals(false));
  });

  test('modifyTopicTitle modifies a topic title and updates it in topics',
      () async {
    chatProvider.topics = [mockTopic];

    final mockTopicNewTitle = Topic(
      id: mockTopic.id,
      userId: mockTopic.userId,
      title: 'Updated Title',
      createdAt: mockTopic.createdAt,
      lastModified: DateTime.now(),
    );

    when(mockChatRepository.updateTopic(any))
        .thenAnswer((_) async => mockTopicNewTitle);

    await chatProvider.modifyTopicTitle(mockTopicNewTitle);

    // Check if the topic title is updated
    expect(
        chatProvider.topics
            .firstWhere((topic) => topic.id == mockTopicNewTitle.id)
            .title,
        equals('Updated Title'));
    // Check if loading status is false after execution
    expect(chatProvider.isLoading, equals(false));
  });

  test(
      'modifyChatSummary modifies a chat summary and updates it in currentTopicChats',
      () async {
    when(mockChatRepository.updateChat(any)).thenAnswer((_) async {});
    chatProvider.currentTopicChats = [mockChat];
    final mockChatWithNewSummary = Chat(
      id: mockChat.id,
      userId: mockChat.userId,
      topicId: mockChat.topicId,
      summary: 'Updated Summary',
      createdAt: mockChat.createdAt,
      lastModified: DateTime.now(),
    );

    await chatProvider.modifyChatSummary(mockChatWithNewSummary);

    // Check if the chat summary is updated
    expect(
        chatProvider.currentTopicChats
            .firstWhere((chat) => chat.id == mockChatWithNewSummary.id)
            .summary,
        equals('Updated Summary'));
    // Check if loading status is false after execution
    expect(chatProvider.isLoading, equals(false));
  });

  test('setLoading sets loading to true and notify listeners', () async {
    bool isNotified = false;
    chatProvider.addListener(() {
      isNotified = true;
    });

    chatProvider.setLoading(true);

    // Check if isLoading is set to true
    expect(chatProvider.isLoading, equals(true));
    // Check if listeners are notified
    expect(isNotified, equals(true));
  });

  test('clearChatStates clears the chat-related states', () async {
    when(mockChatRepository.getMessages(mockChat.id))
        .thenAnswer((_) async => mockMessages);
    chatProvider.currentChat = mockChat;
    chatProvider.currentTopic = mockTopic;
    chatProvider.messages = mockMessages;

    chatProvider.clearChatStates();

    expect(chatProvider.currentChat, isNull);
    expect(chatProvider.currentTopic, isNull);
    expect(chatProvider.messages, isEmpty);
    expect(chatProvider.isLoading, equals(false));
  });
}
