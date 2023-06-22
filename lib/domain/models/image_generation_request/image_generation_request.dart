import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_generation_request.freezed.dart';
part 'image_generation_request.g.dart';

@freezed
class ImageGenerationRequest with _$ImageGenerationRequest {
  const factory ImageGenerationRequest({
    String? prompt,
    double? weight,
    int? height,
    int? width,
    int? steps,
    required String chatId,
    double? imageStrength,
    String? initImageMode,
    String? initImage,
    List<Map<String, dynamic>>? textPrompts,
    int? cfgScale,
    String? clipGuidancePreset,
    String? sampler,
    int? samples,
    String? stylePreset,
  }) = _ImageGenerationRequest;

  factory ImageGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageGenerationRequestFromJson(json);
}
