// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUserCredential _$$_AppUserCredentialFromJson(Map<String, dynamic> json) =>
    _$_AppUserCredential(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['emailVerified'] as bool,
    );

Map<String, dynamic> _$$_AppUserCredentialToJson(
        _$_AppUserCredential instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'emailVerified': instance.emailVerified,
    };
