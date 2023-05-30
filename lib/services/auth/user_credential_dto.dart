import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/auth/app_user_credential.dart';

class UserCredentialDTO {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;

  UserCredentialDTO({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
  });

  AppUserCredential toDomain() {
    return AppUserCredential(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
    );
  }

  factory UserCredentialDTO.fromDomain(AppUserCredential model) {
    return UserCredentialDTO(
      uid: model.uid,
      email: model.email,
      displayName: model.displayName,
      photoURL: model.photoURL,
      emailVerified: model.emailVerified,
    );
  }

  factory UserCredentialDTO.fromFirebaseUser(User user) {
    return UserCredentialDTO(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }
}
