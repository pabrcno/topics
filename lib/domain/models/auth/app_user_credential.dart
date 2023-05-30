import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user_credential.freezed.dart';
part 'app_user_credential.g.dart';

@freezed
class AppUserCredential with _$AppUserCredential {
  const factory AppUserCredential({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    required bool emailVerified,
  }) = _AppUserCredential;

  factory AppUserCredential.fromJson(Map<String, dynamic> json) =>
      _$AppUserCredentialFromJson(json);
}
