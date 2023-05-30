// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppUserCredential _$AppUserCredentialFromJson(Map<String, dynamic> json) {
  return _AppUserCredential.fromJson(json);
}

/// @nodoc
mixin _$AppUserCredential {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppUserCredentialCopyWith<AppUserCredential> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCredentialCopyWith<$Res> {
  factory $AppUserCredentialCopyWith(
          AppUserCredential value, $Res Function(AppUserCredential) then) =
      _$AppUserCredentialCopyWithImpl<$Res, AppUserCredential>;
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoURL,
      bool emailVerified});
}

/// @nodoc
class _$AppUserCredentialCopyWithImpl<$Res, $Val extends AppUserCredential>
    implements $AppUserCredentialCopyWith<$Res> {
  _$AppUserCredentialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoURL = freezed,
    Object? emailVerified = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AppUserCredentialCopyWith<$Res>
    implements $AppUserCredentialCopyWith<$Res> {
  factory _$$_AppUserCredentialCopyWith(_$_AppUserCredential value,
          $Res Function(_$_AppUserCredential) then) =
      __$$_AppUserCredentialCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      String? displayName,
      String? photoURL,
      bool emailVerified});
}

/// @nodoc
class __$$_AppUserCredentialCopyWithImpl<$Res>
    extends _$AppUserCredentialCopyWithImpl<$Res, _$_AppUserCredential>
    implements _$$_AppUserCredentialCopyWith<$Res> {
  __$$_AppUserCredentialCopyWithImpl(
      _$_AppUserCredential _value, $Res Function(_$_AppUserCredential) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? photoURL = freezed,
    Object? emailVerified = null,
  }) {
    return _then(_$_AppUserCredential(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      photoURL: freezed == photoURL
          ? _value.photoURL
          : photoURL // ignore: cast_nullable_to_non_nullable
              as String?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AppUserCredential implements _AppUserCredential {
  const _$_AppUserCredential(
      {required this.uid,
      required this.email,
      this.displayName,
      this.photoURL,
      required this.emailVerified});

  factory _$_AppUserCredential.fromJson(Map<String, dynamic> json) =>
      _$$_AppUserCredentialFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String? displayName;
  @override
  final String? photoURL;
  @override
  final bool emailVerified;

  @override
  String toString() {
    return 'AppUserCredential(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL, emailVerified: $emailVerified)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppUserCredential &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uid, email, displayName, photoURL, emailVerified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AppUserCredentialCopyWith<_$_AppUserCredential> get copyWith =>
      __$$_AppUserCredentialCopyWithImpl<_$_AppUserCredential>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppUserCredentialToJson(
      this,
    );
  }
}

abstract class _AppUserCredential implements AppUserCredential {
  const factory _AppUserCredential(
      {required final String uid,
      required final String email,
      final String? displayName,
      final String? photoURL,
      required final bool emailVerified}) = _$_AppUserCredential;

  factory _AppUserCredential.fromJson(Map<String, dynamic> json) =
      _$_AppUserCredential.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String? get displayName;
  @override
  String? get photoURL;
  @override
  bool get emailVerified;
  @override
  @JsonKey(ignore: true)
  _$$_AppUserCredentialCopyWith<_$_AppUserCredential> get copyWith =>
      throw _privateConstructorUsedError;
}
