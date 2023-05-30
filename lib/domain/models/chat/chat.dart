// This file is "main.dart"
import 'package:freezed_annotation/freezed_annotation.dart';
part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String userId,
    required String topicId,
    required DateTime createdAt,
    required DateTime lastModified,
    required String summary,
    @Default(0.5) double temperature,
  }) = _Chat;

  factory Chat.fromJson(Map<String, Object?> json) => _$ChatFromJson(json);
}
