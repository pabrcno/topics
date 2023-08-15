import '../../models/message/message.dart';

abstract class IChatApi {
  Future<Stream<Message>> createChatCompletionStream(
      List<Message> messages, double temperature, String model);
}
