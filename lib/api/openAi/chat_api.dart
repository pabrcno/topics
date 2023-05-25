import 'package:dart_openai/dart_openai.dart';

class OpenAIChatApi {
  final String model;

  OpenAIChatApi({this.model = 'gpt-3.5-turbo'});

  Future<OpenAIChatCompletionModel> createChatCompletion(
      List<OpenAIChatCompletionChoiceMessageModel> messages) async {
    return await OpenAI.instance.chat.create(
      model: model,
      messages: messages,
    );
  }

  Stream<OpenAIStreamChatCompletionModel> createChatCompletionStream(
      List<OpenAIChatCompletionChoiceMessageModel> messages) {
    return OpenAI.instance.chat.createStream(
      model: model,
      messages: messages,
    );
  }
}
