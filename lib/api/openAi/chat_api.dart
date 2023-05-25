import 'package:dart_openai/dart_openai.dart';

import '../../domain/api/chat/IChatApi.dart';
import '../../domain/core/enums.dart';
import '../../domain/models/message/message.dart';
import 'package:uuid/uuid.dart';

class OpenAIChatApi implements IChatApi {
  final String model;

  OpenAIChatApi({this.model = 'gpt-3.5-turbo'});

  @override
  Future<Message> createChatCompletion(List<Message> messages) async {
    if (messages.isEmpty) {
      throw Exception('No messages to convert');
    }

    final openAIMessages = _convertToOpenAIMessages(messages);

    final completionModel = await OpenAI.instance.chat.create(
      model: model,
      messages: openAIMessages,
    );

    final message = _convertToMessage(completionModel.choices.first);

    return message;
  }

  @override
  Stream<Message> createChatCompletionStream(List<Message> messages) {
    final openAIMessages = _convertToOpenAIMessages(messages);

    final stream = OpenAI.instance.chat.createStream(
      model: model,
      messages: openAIMessages,
    );

    return stream.map((event) => _convertStreamMessageToMessage(event));
  }

  Message _convertStreamMessageToMessage(
      OpenAIStreamChatCompletionModel completionModel) {
    return Message(
        id: const Uuid().v4(),
        content: completionModel.choices.first.delta.content ?? '',
        sentAt: DateTime.now(),
        isUser: completionModel.choices.first.delta.role.toString() == 'user',
        role: _openAiRoleToMessageRole(
          OpenAIChatMessageRole.assistant,
        ));
  }

  List<OpenAIChatCompletionChoiceMessageModel> _convertToOpenAIMessages(
      List<Message> messages) {
    return messages.map((message) {
      OpenAIChatCompletionChoiceMessageModel openAiMessage =
          OpenAIChatCompletionChoiceMessageModel(
        role: _messageRoleToOpenAiRole(message.role),
        content: message.content,
      );

      return openAiMessage;
    }).toList();
  }

  Message _convertToMessage(OpenAIChatCompletionChoiceModel openAIChoice) {
    return Message(
        id: const Uuid().v4(),
        content: openAIChoice.message.content,
        sentAt: DateTime.now(),
        isUser: openAIChoice.message.role.toString() == 'user',
        role: _openAiRoleToMessageRole(openAIChoice.message.role));
  }

  OpenAIChatMessageRole _messageRoleToOpenAiRole(EMessageRole role) {
    String roleString = role.toString().split('.').last;
    return OpenAIChatMessageRole.values
        .firstWhere((e) => e.toString().split('.').last == roleString);
  }

  EMessageRole _openAiRoleToMessageRole(OpenAIChatMessageRole role) {
    String roleString = role.toString().split('.').last;
    return EMessageRole.values
        .firstWhere((e) => e.toString().split('.').last == roleString);
  }
}