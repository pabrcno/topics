import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/repo/i_user_repository.dart';

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUser(String uid, Map<String, dynamic> userMap) async {
    await _firestore.collection('users').doc(uid).set(userMap);
  }

  @override
  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }
}
