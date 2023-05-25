class Message {
  final String id;
  final String chatId;
  final String text;
  final DateTime sentAt;
  final bool
      isUser; // true if this message is sent by the user, false if by GPT

  Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.sentAt,
    required this.isUser,
  });
}
