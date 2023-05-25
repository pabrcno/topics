// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Topic _$$_TopicFromJson(Map<String, dynamic> json) => _$_Topic(
      id: json['id'] as String,
      title: json['title'] as String,
      lastModified: DateTime.parse(json['lastModified'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$_TopicToJson(_$_Topic instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'lastModified': instance.lastModified.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
