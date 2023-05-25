class Topic {
  final String id;
  final String title;
  final DateTime lastModified;
  final List<String> chatIds;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.title,
    required this.lastModified,
    required this.chatIds,
    required this.createdAt,
  });
}
