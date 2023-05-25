class Chat {
  final String id;
  final String userId;
  final String topicId;
  final DateTime createdAt;

  final DateTime lastModified;
  final String summary;
  final List<String> messageIds;

  Chat({
    required this.id,
    required this.userId,
    required this.topicId,
    required this.createdAt,
    required this.lastModified,
    required this.summary,
    required this.messageIds,
  });
}
