// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      id: json['id'] as String,
      content: json['content'] as String,
      chatId: json['chatId'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isUser: json['isUser'] as bool,
      role: $enumDecode(_$EMessageRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'chatId': instance.chatId,
      'sentAt': instance.sentAt.toIso8601String(),
      'isUser': instance.isUser,
      'role': _$EMessageRoleEnumMap[instance.role]!,
    };

const _$EMessageRoleEnumMap = {
  EMessageRole.system: 'system',
  EMessageRole.user: 'user',
  EMessageRole.assistant: 'assistant',
};
