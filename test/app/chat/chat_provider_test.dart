import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:topics/app/chat/chat_provider.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';
import 'package:topics/domain/api/chat/i_chat_api.dart';
import 'package:topics/services/exception_handling_service.dart';

@GenerateMocks([IChatRepository, IChatApi])
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

void main() {
  late ChatProvider chatProvider;
  late MockIChatApi mockChatApi;
  late MockIChatRepository mockChatRepository;
  late MockErrorCommander mockErrorCommander;

  setUp(() {
    // Initialize Mock classes
    mockChatApi = MockIChatApi();
    mockChatRepository = MockIChatRepository();
    mockErrorCommander = MockErrorCommander();

    // Pass mock objects to the ChatProvider
    chatProvider = ChatProvider(
      chatApi: mockChatApi,
      chatRepository: mockChatRepository,
      errorCommander: mockErrorCommander,
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

  // test('_handleSendMessageCompletion completes with the answer message',
  //     () async {
  //   const mockContent = 'Hello!';
  //   final mockEvent = mockMessage;

  //   // Mock the necessary dependencies
  //   when(mockChatApi.createChatCompletionStream(any)).thenAnswer((_) {
  //     final controller = StreamController<Message>();
  //     controller.add(mockEvent);
  //     controller.close();
  //     return controller.stream;
  //   });

  //   // Invoke the method and await the result
  //   final result = await chatProvider.handleSendMessageCompletion();

  //   // Verify the result
  //   expect(result.content, equals(mockContent));
  //   expect(chatProvider.messageBuffer, equals(''));
  // });

  // test('_handleSendMessageCompletion throws an error on failure', () async {
  //   // Mock the necessary dependencies to simulate an error
  //   when(mockChatApi.createChatCompletionStream(any))
  //       .thenThrow(Exception('Failed'));

  //   // Invoke the method and expect an error to be thrown
  //   expect(chatProvider.handleSendMessageCompletion(), throwsException);
  // });

  // test('createChat creates a new chat and sends initial message', () async {
  //   const mockInitialMessage = 'Hello!';

  //   when(mockChatRepository.createChat(any)).thenAnswer((_) async {});
  //   when(mockChatRepository.createMessage(any)).thenAnswer((_) async {});

  //   await chatProvider.createChat(mockInitialMessage, mockTopic);

  //   verify(mockChatRepository.createChat(mockChat)).called(1);
  //   verify(mockChatRepository.createMessage(any)).called(1);
  //   expect(chatProvider.currentChat, equals(mockChat));
  //   expect(chatProvider.currentTopic, equals(mockTopic));
  //   expect(chatProvider.isLoading, equals(false));
  // });

  // test('fetchChatAndMessages fetches the chat and messages', () async {
  //   const mockChatId = 'chat2';
  //   when(mockChatRepository.getChat(mockChatId))
  //       .thenAnswer((_) async => mockChat);
  //   when(mockChatRepository.getMessages(mockChatId))
  //       .thenAnswer((_) async => mockMessages);

  //   await chatProvider.fetchChatAndMessages(mockChatId);

  //   verify(mockChatRepository.getChat(mockChatId)).called(1);
  //   verify(mockChatRepository.getMessages(mockChatId)).called(1);
  //   expect(chatProvider.currentChat, equals(mockChat));
  //   expect(chatProvider.messages, equals(mockMessages));
  //   expect(chatProvider.isLoading, equals(false));
  // });

  // test('createTopic creates a new topic and a chat', () async {
  //   when(mockChatRepository.createTopic(any)).thenAnswer((_) async {});
  //   when(mockChatRepository.createChat(any)).thenAnswer((_) async {});
  //   when(mockChatRepository.getTopics(any))
  //       .thenAnswer((_) async => [mockTopic]);

  //   const mockInitialMessage = 'Hello!';

  //   await chatProvider.createTopic(mockTopic.title, mockInitialMessage);

  //   verify(mockChatRepository.createTopic(mockTopic)).called(1);
  //   verify(mockChatRepository.createChat(mockChat)).called(1);
  //   verify(mockChatRepository.getTopics(any)).called(1);
  //   expect(chatProvider.currentTopic, equals(mockTopic));
  //   expect(chatProvider.isLoading, equals(false));
  // });

  test('clearChatStates clears the chat-related states', () async {
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
