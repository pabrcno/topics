import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user/app_user.dart';

import '../../domain/repo/i_user_repository.dart';

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  @override
  Future<AppUser?> getUser(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    return AppUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> reduceMessages(String uid, int decrement) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'messageCount': FieldValue.increment(-decrement)});
  }
}
