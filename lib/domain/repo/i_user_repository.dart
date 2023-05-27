import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IUserRepository {
  Future<void> createUser(String uid, Map<String, dynamic> userMap);
  Future<DocumentSnapshot> getUser(String uid);
}
