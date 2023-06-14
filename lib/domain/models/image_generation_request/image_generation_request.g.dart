// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageGenerationRequest _$$_ImageGenerationRequestFromJson(
        Map<String, dynamic> json) =>
    _$_ImageGenerationRequest(
      prompt: json['prompt'] as String,
      weight: (json['weight'] as num).toDouble(),
      height: json['height'] as int,
      width: json['width'] as int,
      steps: json['steps'] as int,
      chatId: json['chatId'] as String,
    );

Map<String, dynamic> _$$_ImageGenerationRequestToJson(
        _$_ImageGenerationRequest instance) =>
    <String, dynamic>{
      'prompt': instance.prompt,
      'weight': instance.weight,
      'height': instance.height,
      'width': instance.width,
      'steps': instance.steps,
      'chatId': instance.chatId,
    };
