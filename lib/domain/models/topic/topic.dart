import 'package:freezed_annotation/freezed_annotation.dart';
part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    required String id,
    required String userId,
    required String title,
    required DateTime lastModified,
    required DateTime createdAt,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
