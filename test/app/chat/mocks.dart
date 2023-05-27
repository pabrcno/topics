import 'package:mockito/mockito.dart';
import 'package:topics/domain/api/chat/i_chat_api.dart';
import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/models/topic/topic.dart';
import 'package:topics/domain/repo/i_chat_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:topics/services/exception_handling_service.dart';

class MockChatApi extends Mock implements IChatApi {}

class MockChatRepository extends Mock implements IChatRepository {
  @override
  Future<List<Message>> getMessages(String chatId) {
    return noSuchMethod(Invocation.method(#getMessages, [chatId]),
        returnValue: Future.value(mockMessages),
        returnValueForMissingStub: Future.value(mockMessages));
  }

  @override
  Future<List<Topic>> getTopics(String userId) {
    return noSuchMethod(Invocation.method(#getTopics, [userId]),
        returnValue: Future.value(mockTopics),
        returnValueForMissingStub: Future.value(mockTopics));
  }

  @override
  Future<List<Chat>> getChats(String topicId) {
    return noSuchMethod(Invocation.method(#getTopicChats, [topicId]),
        returnValue: Future.value(mockChats),
        returnValueForMissingStub: Future.value(mockChats));
  }

  @override
  Future<Chat> createChat(Chat chat) {
    return noSuchMethod(Invocation.method(#createChat, [chat]),
        returnValue: Future.value(mockChat),
        returnValueForMissingStub: Future.value(mockChat));
  }
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockErrorCommander extends Mock implements ErrorCommander {}

final mockMessages = [
  Message(
    id: 'msg1',
    chatId: 'chat1',
    content: 'test message',
    sentAt: DateTime.now(),
    isUser: false,
    role: EMessageRole.assistant,
  ),
  Message(
    id: 'msg2',
    chatId: 'chat1',
    content: 'test message',
    sentAt: DateTime.now(),
    isUser: false,
    role: EMessageRole.user,
  ),
];
final mockChat = Chat(
  id: 'chat1',
  userId: 'user1',
  topicId: 'topic1',
  createdAt: DateTime.now(),
  lastModified: DateTime.now(),
  summary: 'test chat',
);

final mockTopics = [
  Topic(
    id: 'topic1',
    userId: 'user1',
    title: 'test topic',
    createdAt: DateTime.now(),
    lastModified: DateTime.now(),
  ),
];
final mockChats = [
  Chat(
    id: 'chat1',
    userId: 'user1',
    topicId: 'topic1',
    createdAt: DateTime.now(),
    lastModified: DateTime.now(),
    summary: 'test chat',
  ),
];
final mockTopic = Topic(
    createdAt: DateTime.now(),
    id: 'topic1',
    title: 'test topic',
    userId: 'user1',
    lastModified: DateTime.now());
