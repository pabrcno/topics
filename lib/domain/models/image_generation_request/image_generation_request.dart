import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_generation_request.freezed.dart';
part 'image_generation_request.g.dart';

@freezed
class ImageGenerationRequest with _$ImageGenerationRequest {
  const factory ImageGenerationRequest({
    required String prompt,
    required double weight,
    required int height,
    required int width,
    required int steps,
    required String chatId,
  }) = _ImageGenerationRequest;

  factory ImageGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageGenerationRequestFromJson(json);
}
