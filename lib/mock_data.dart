import 'package:topics/domain/models/message/message.dart';

import 'domain/models/question/question.dart';
import 'domain/models/topic/topic.dart';

List<Topic> topics = [
  Topic(
      id: '3',
      title: 'Software Architecture and a big name',
      questionIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '2',
      title:
          'Software Architecture and and an even bigger name, to test the behavior and font sizes',
      questionIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
  Topic(
      id: '1',
      title: 'Topic 3',
      questionIds: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      lastModified: DateTime.now(),
      createdAt: DateTime.now()),
];

final List<Question> questions = [
  Question(
      id: "1",
      topicId: "1",
      createdAt: DateTime.now(),
      messages: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the question. Generated from the first message in the question."),
  Question(
      id: "2",
      topicId: "1",
      createdAt: DateTime.now(),
      messages: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the question. Generated from the first message in the question."),
  Question(
      id: "3",
      topicId: "1",
      createdAt: DateTime.now(),
      messages: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the question. Generated from the first message in the question."),
  Question(
      id: "4",
      topicId: "1",
      createdAt: DateTime.now(),
      messages: [],
      lastModified: DateTime.now(),
      summary:
          "This is a summary representing the intent of the question. Generated from the first message in the question."),
];
final List<Message> mockMessages = [
  Message(
      id: '1',
      questionId: '1',
      text: 'Hello World',
      sentAt: DateTime.now(),
      isUser: true),
  Message(
      id: '2',
      questionId: '1',
      text: 'Hello Back',
      sentAt: DateTime.now(),
      isUser: false),
  Message(
      id: '3',
      questionId: '2',
      text: 'Hallo',
      sentAt: DateTime.now(),
      isUser: true),
];
