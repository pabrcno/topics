// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AppUser _$$_AppUserFromJson(Map<String, dynamic> json) => _$_AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      emailVerified: json['emailVerified'] as bool,
      subscription: $enumDecode(_$ESubscriptionsEnumMap, json['subscription']),
      messageCount: json['messageCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      openAiApiKey: json['openAiApiKey'] as String,
    );

Map<String, dynamic> _$$_AppUserToJson(_$_AppUser instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'emailVerified': instance.emailVerified,
      'subscription': _$ESubscriptionsEnumMap[instance.subscription]!,
      'messageCount': instance.messageCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'openAiApiKey': instance.openAiApiKey,
    };

const _$ESubscriptionsEnumMap = {
  ESubscriptions.basic: 'basic',
  ESubscriptions.premium: 'premium',
  ESubscriptions.vip: 'vip',
};
