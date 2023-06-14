import 'package:topics/domain/models/image_generation_request/image_generation_request.dart';

import '../../models/message/message.dart';

abstract class IImageGenerationApi {
  Future<List<Message>> generateImage(ImageGenerationRequest requestBody);
}
