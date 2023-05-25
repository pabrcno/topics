import '../../models/message/message.dart';

abstract class IChatApi {
  Future<Message> createChatCompletion(List<Message> messages);
  Stream<Message> createChatCompletionStream(List<Message> messages);
}
