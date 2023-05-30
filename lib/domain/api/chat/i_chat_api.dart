import '../../models/message/message.dart';

abstract class IChatApi {
  Future<Message> createChatCompletion(List<Message> messages, String chatId);
  Stream<Message> createChatCompletionStream(
      List<Message> messages, double? temperature);
}
