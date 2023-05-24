class Topic {
  final String id;
  final String title;
  final DateTime lastModified;
  final List<String> questionIds;
  final DateTime createdAt;

  Topic({
    required this.id,
    required this.title,
    required this.lastModified,
    required this.questionIds,
    required this.createdAt,
  });
}
