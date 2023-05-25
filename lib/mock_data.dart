import 'domain/models/chat/chat.dart';
import 'domain/models/topic/topic.dart';

List<Topic> topics = [
  Topic(
      id: '3',
      title: 'Software Architecture and a big name',
      chatIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '2',
      title:
          'Software Architecture and and an even bigger name, to test the behavior and font sizes',
      chatIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '1',
      title: 'Topic 3',
      chatIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
];

final List<Chat> chats = [
  Chat(
      id: "1",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      messageIds: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "2",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      messageIds: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "3",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      messageIds: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
  Chat(
      id: "4",
      userId: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      messageIds: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the Chat. Generated from the first message in the Chat."),
];
