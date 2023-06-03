// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageRequest _$$_MessageRequestFromJson(Map<String, dynamic> json) =>
    _$_MessageRequest(
      userToken: json['userToken'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      temperature: (json['temperature'] as num).toDouble(),
    );

Map<String, dynamic> _$$_MessageRequestToJson(_$_MessageRequest instance) =>
    <String, dynamic>{
      'userToken': instance.userToken,
      'messages': instance.messages,
      'temperature': instance.temperature,
    };
