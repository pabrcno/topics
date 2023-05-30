// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chat _$$_ChatFromJson(Map<String, dynamic> json) => _$_Chat(
      id: json['id'] as String,
      userId: json['userId'] as String,
      topicId: json['topicId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      summary: json['summary'] as String,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.5,
    );

Map<String, dynamic> _$$_ChatToJson(_$_Chat instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'topicId': instance.topicId,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastModified': instance.lastModified.toIso8601String(),
      'summary': instance.summary,
      'temperature': instance.temperature,
    };
