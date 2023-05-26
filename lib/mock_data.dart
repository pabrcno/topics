import 'package:topics/domain/models/message/message.dart';

import 'domain/core/enums.dart';
import 'domain/models/chat/chat.dart';
import 'domain/models/topic/topic.dart';

List<Topic> topics = [
  Topic(
      id: '3',
      userId: '1',
      title: 'Software Architecture and a big name',
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '2',
      userId: '1',
      title:
          'Software Architecture and and an even bigger name, to test the behavior and font sizes',
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '1',
      userId: '1',
      title: 'Topic 3',
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
];

final List<Chat> chats = [
  Chat(
      id: "1",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "2",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "3",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "4",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
];
final List<Message> mockMessages = [
  Message(
      id: '1',
      chatId: '1',
      content: 'Hello World',
      sentAt: DateTime.now(),
      role: EMessageRole.user,
      isUser: true),
  Message(
      id: '2',
      chatId: '1',
      content: 'Hello Back',
      sentAt: DateTime.now(),
      role: EMessageRole.user,
      isUser: false),
  Message(
      id: '3',
      chatId: '2',
      content: 'Hallo',
      sentAt: DateTime.now(),
      role: EMessageRole.user,
      isUser: true),
];
