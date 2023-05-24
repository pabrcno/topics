import '../message/message.dart';

class Question {
  final String text;
  final DateTime createdAt;
  final List<Message> messages;
  final DateTime lastModified;

  Question({
    required this.text,
    required this.createdAt,
    required this.messages,
    required this.lastModified,
  });
}
