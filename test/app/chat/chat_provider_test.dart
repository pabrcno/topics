import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:topics/app/chat/chat_provider.dart';
import 'package:topics/domain/api/chat/i_chat_api.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/models/topic/topic.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';

import 'package:topics/services/exception_notifier.dart';

late MockChatApi mockChatApi;
late MockChatRepository mockChatRepository;
late MockExceptionNotifier mockExceptionNotifier;
late ChatProvider chatProvider;

class MockChatApi extends Mock implements IChatApi {}

class MockChatRepository extends Mock implements IChatRepository {}

class MockExceptionNotifier extends Mock implements ExceptionNotifier {}

void main() {
  setUp(() {
    mockChatApi = MockChatApi();
    mockChatRepository = MockChatRepository();
    mockExceptionNotifier = MockExceptionNotifier();
    chatProvider = ChatProvider(
      chatApi: mockChatApi,
      chatRepository: mockChatRepository,
      exceptionNotifier: mockExceptionNotifier,
    );
    // Initialize an empty list of messages
    List<Message> mockMessages = [];

    // Define the behavior of the getMessages() function
    when(mockChatRepository.getMessages(''))
        .thenAnswer((_) async => mockMessages);
  });

  group('ChatProvider Tests', () {
    test('fetch messages test', () async {
      final chat = Chat(
          id: 'chat1',
          userId: 'user1',
          topicId: 'topic1',
          createdAt: DateTime.now(),
          lastModified: DateTime.now(),
          summary: 'Summary');
      chatProvider.setCurrentChat(chat);
      when(mockChatRepository.getMessages(chat.id)).thenAnswer((_) async => [
            Message(
                id: 'msg1',
                chatId: 'chat1',
                content: 'Hello',
                sentAt: DateTime.now(),
                isUser: true,
                role: EMessageRole.user),
            Message(
                id: 'msg2',
                chatId: 'chat1',
                content: 'Hello',
                sentAt: DateTime.now(),
                isUser: false,
                role: EMessageRole.assistant)
          ]);

      await chatProvider.fetchMessages();

      expect(chatProvider.messages.length, 2);
    });

    test('fetch topics test', () async {
      when(mockChatRepository.getTopics('topic1')).thenAnswer((_) async => [
            Topic(
                id: 'topic1',
                userId: 'user1',
                title: 'Topic 1',
                createdAt: DateTime.now(),
                lastModified: DateTime.now())
          ]);

      await chatProvider.fetchTopics();

      expect(chatProvider.topics.length, 1);
    });

    test('fetch chats for topic test', () async {
      when(mockChatRepository.getChats('topic1')).thenAnswer((_) async => [
            Chat(
                id: 'chat1',
                userId: 'user1',
                topicId: 'topic1',
                createdAt: DateTime.now(),
                lastModified: DateTime.now(),
                summary: 'Summary')
          ]);

      await chatProvider.fetchChatsForTopic('topic1');

      expect(chatProvider.currentTopicChats.length, 1);
    });
    // Add more tests for other functions of ChatProvider...
  });
}
