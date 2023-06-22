// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_generation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ImageGenerationRequest _$$_ImageGenerationRequestFromJson(
        Map<String, dynamic> json) =>
    _$_ImageGenerationRequest(
      prompt: json['prompt'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: json['height'] as int?,
      width: json['width'] as int?,
      steps: json['steps'] as int?,
      chatId: json['chatId'] as String,
      imageStrength: (json['imageStrength'] as num?)?.toDouble(),
      initImageMode: json['initImageMode'] as String?,
      initImage: json['initImage'] as String?,
      textPrompts: (json['textPrompts'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      cfgScale: json['cfgScale'] as int?,
      clipGuidancePreset: json['clipGuidancePreset'] as String?,
      sampler: json['sampler'] as String?,
      samples: json['samples'] as int?,
      stylePreset: json['stylePreset'] as String?,
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
      'imageStrength': instance.imageStrength,
      'initImageMode': instance.initImageMode,
      'initImage': instance.initImage,
      'textPrompts': instance.textPrompts,
      'cfgScale': instance.cfgScale,
      'clipGuidancePreset': instance.clipGuidancePreset,
      'sampler': instance.sampler,
      'samples': instance.samples,
      'stylePreset': instance.stylePreset,
    };
