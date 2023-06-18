import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:topics/domain/models/chat/chat.dart';
import 'package:topics/domain/models/message/message.dart';
import 'package:topics/domain/models/topic/topic.dart';

import '../../domain/repo/i_chat_repository.dart';

class FirestoreChatRepository implements IChatRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  FirestoreChatRepository();

  @override
  Future<void> createChat(Chat chat) async {
    await _firebaseFirestore
        .collection('chats')
        .doc(chat.id)
        .set(chat.toJson());
  }

  @override
  Future<void> createMessage(Message message) async {
    await _firebaseFirestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());
  }

  @override
  Future<Chat?> getChat(String id) async {
    final doc = await _firebaseFirestore.collection('chats').doc(id).get();
    if (!doc.exists) return null;
    return Chat.fromJson(doc.data() as Map<String, Object?>);
  }

  @override
  Future<void> createTopic(Topic topic) async {
    await _firebaseFirestore
        .collection('topics')
        .doc(topic.id)
        .set(topic.toJson());
  }

  @override
  Future<Topic> getTopic(String id) async {
    final doc = await _firebaseFirestore.collection('topics').doc(id).get();
    return Topic.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _firebaseFirestore.collection('chats').doc(chatId).delete();
  }

  @override
  Future<void> deleteTopic(String topicId) async {
    await _firebaseFirestore.collection('topics').doc(topicId).delete();
  }

  @override
  Future<List<Chat>> getChats(String topicId) {
    return _firebaseFirestore
        .collection('chats')
        .where('topicId', isEqualTo: topicId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Chat.fromJson(doc.data()))
          .toList();
    }).first;
  }

  @override
  Future<void> updateChat(Chat chat) async {
    await _firebaseFirestore
        .collection('chats')
        .doc(chat.id)
        .update(chat.toJson());
  }

  @override
  Future<void> updateMessage(Message message) async {
    await _firebaseFirestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc(message.id)
        .update(message.toJson());
  }

  @override
  Future<void> updateTopic(Topic topic) async {
    await _firebaseFirestore
        .collection('topics')
        .doc(topic.id)
        .update(topic.toJson());
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    await _firebaseFirestore.collection('messages').doc(messageId).delete();
  }

  @override
  Future<Message?> getMessage(String messageId) async {
    final doc =
        await _firebaseFirestore.collection('messages').doc(messageId).get();
    if (doc.exists) {
      return Message.fromJson(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Future<List<Message>> getMessages(String chatId) {
    return _firebaseFirestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList();
    }).first;
  }

  @override
  Future<List<Topic>> getTopics(String userId) {
    return _firebaseFirestore
        .collection('topics')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Topic.fromJson(doc.data()))
          .toList();
    }).first;
  }

  @override
  Future<List<Chat>> getUserChats(String userId) {
    return _firebaseFirestore
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Chat.fromJson(doc.data()))
          .toList();
    }).first;
  }
}
