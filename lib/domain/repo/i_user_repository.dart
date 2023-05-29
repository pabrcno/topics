import '../models/user/app_user.dart';

abstract class IUserRepository {
  Future<void> createUser(AppUser user);
  Future<AppUser?> getUser(String uid);
  Future<void> reduceMessages(String uid, int decrement);
}
