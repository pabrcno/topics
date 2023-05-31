import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum ESubscriptions {
  basic,
  premium,
  vip
} // replace with your actual subscriptions enum

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required String displayName,
    required String photoURL,
    required bool emailVerified,
    required ESubscriptions subscription,
    required int messageCount,
    required DateTime createdAt,
    // TODO: THIS IS A TEMPORARY PARAMETER FOR BETA TESTERS IT SHOULD BE REMOVED IN THE FUTURE
    required String openAiApiKey,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
