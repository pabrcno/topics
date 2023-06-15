import 'package:cloud_functions/cloud_functions.dart';

import 'package:topics/domain/models/message/message.dart';

import '../../domain/api/image_generation/i_image_generation_api.dart';

class ImageGenerationApi implements IImageGenerationApi {
  // Set the Cloud Functions emulator to use localhost
  FirebaseFunctions functions = FirebaseFunctions.instance;

  @override
  Future<List<Message>> generateImage(requestBody) async {
    final HttpsCallable callable = functions.httpsCallable(
      'generateImage',
    );

    final HttpsCallableResult result = await callable.call(
      requestBody.toJson(),
    );

    return (result.data['messages'] as List)
        .map((e) => Message.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
