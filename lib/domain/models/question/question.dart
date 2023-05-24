import '../message/message.dart';

class Question {
  final String id;
  final String topicId;
  final DateTime createdAt;
  final List<Message> messages;
  final DateTime lastModified;
  final String summary;

  Question({
    required this.id,
    required this.topicId,
    required this.createdAt,
    required this.messages,
    required this.lastModified,
    required this.summary,
  });
}
