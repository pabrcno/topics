import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/models/user/app_user.dart';

part 'user_dto.freezed.dart';

@freezed
class UserDTO with _$UserDTO {
  const UserDTO._();

  const factory UserDTO({
    required String uid,
    required String email,
    required String displayName,
    required String photoURL,
    required bool emailVerified,
    required String subscription,
    required int messageCount,
    required DateTime createdAt,
    required String openAiApiKey,
  }) = _UserDTO;

  factory UserDTO.fromDomain(AppUser user) {
    return UserDTO(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
      subscription: user.subscription.toString().split('.').last,
      messageCount: user.messageCount,
      createdAt: user.createdAt,
      openAiApiKey: user.openAiApiKey,
    );
  }

  AppUser toDomain() {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
      subscription: ESubscriptions.values
          .firstWhere((e) => e.toString().split('.').last == subscription),
      messageCount: messageCount,
      createdAt: createdAt,
      openAiApiKey: openAiApiKey,
    );
  }
}
