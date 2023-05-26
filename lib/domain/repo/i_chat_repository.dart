import '../models/chat/chat.dart';
import '../models/message/message.dart';
import '../models/topic/topic.dart';

abstract class IChatRepository {
  Future<void> createChat(Chat chat);
  Future<void> updateChat(Chat chat);
  Future<void> deleteChat(String chatId);
  Future<Chat?> getChat(String chatId);
  Stream<List<Chat>> getChats(String userId);

  Future<void> createMessage(Message message);
  Future<void> updateMessage(Message message);
  Future<void> deleteMessage(String messageId);
  Future<Message?> getMessage(String messageId);
  Stream<List<Message>> getMessages(String chatId);

  Future<void> createTopic(Topic topic);
  Future<void> updateTopic(Topic topic);
  Future<void> deleteTopic(String topicId);
  Future<Topic?> getTopic(String topicId);
  Stream<List<Topic>> getTopics(String userId);
}
