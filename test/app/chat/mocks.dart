import 'package:topics/domain/core/enums.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/models/topic/topic.dart';
import 'package:topics/domain/models/user/app_user.dart';

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
final mockMessage = Message(
  id: 'msg1',
  chatId: 'chat1',
  content: 'test message',
  sentAt: DateTime.now(),
  isUser: false,
  role: EMessageRole.assistant,
);

final AppUser mockAppUserWithMessages = AppUser(
  uid: 'testMessages',
  email: 'testEmail',
  displayName: 'testDisplayName',
  photoURL: 'testPhotoURL',
  emailVerified: true,
  subscription: ESubscriptions.basic,
  messageCount: 1,
  createdAt: DateTime.now(),
  openAiApiKey: 'testApiKey',
);

final AppUser mockAppUserWithoutMessages = AppUser(
    uid: 'testNoMessages',
    email: 'testEmail',
    displayName: 'testDisplayName',
    photoURL: 'testPhotoURL',
    emailVerified: true,
    subscription: ESubscriptions.basic,
    messageCount: 0,
    createdAt: DateTime.now(),
    openAiApiKey: 'testApiKey');
