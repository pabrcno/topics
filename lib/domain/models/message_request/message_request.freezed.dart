// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageRequest _$MessageRequestFromJson(Map<String, dynamic> json) {
  return _MessageRequest.fromJson(json);
}

/// @nodoc
mixin _$MessageRequest {
  String get userToken => throw _privateConstructorUsedError;
  List<Message> get messages => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  String get model => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageRequestCopyWith<MessageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageRequestCopyWith<$Res> {
  factory $MessageRequestCopyWith(
          MessageRequest value, $Res Function(MessageRequest) then) =
      _$MessageRequestCopyWithImpl<$Res, MessageRequest>;
  @useResult
  $Res call(
      {String userToken,
      List<Message> messages,
      double temperature,
      String model});
}

/// @nodoc
class _$MessageRequestCopyWithImpl<$Res, $Val extends MessageRequest>
    implements $MessageRequestCopyWith<$Res> {
  _$MessageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userToken = null,
    Object? messages = null,
    Object? temperature = null,
    Object? model = null,
  }) {
    return _then(_value.copyWith(
      userToken: null == userToken
          ? _value.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageRequestCopyWith<$Res>
    implements $MessageRequestCopyWith<$Res> {
  factory _$$_MessageRequestCopyWith(
          _$_MessageRequest value, $Res Function(_$_MessageRequest) then) =
      __$$_MessageRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userToken,
      List<Message> messages,
      double temperature,
      String model});
}

/// @nodoc
class __$$_MessageRequestCopyWithImpl<$Res>
    extends _$MessageRequestCopyWithImpl<$Res, _$_MessageRequest>
    implements _$$_MessageRequestCopyWith<$Res> {
  __$$_MessageRequestCopyWithImpl(
      _$_MessageRequest _value, $Res Function(_$_MessageRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userToken = null,
    Object? messages = null,
    Object? temperature = null,
    Object? model = null,
  }) {
    return _then(_$_MessageRequest(
      userToken: null == userToken
          ? _value.userToken
          : userToken // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<Message>,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      model: null == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessageRequest implements _MessageRequest {
  const _$_MessageRequest(
      {required this.userToken,
      required final List<Message> messages,
      required this.temperature,
      required this.model})
      : _messages = messages;

  factory _$_MessageRequest.fromJson(Map<String, dynamic> json) =>
      _$$_MessageRequestFromJson(json);

  @override
  final String userToken;
  final List<Message> _messages;
  @override
  List<Message> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final double temperature;
  @override
  final String model;

  @override
  String toString() {
    return 'MessageRequest(userToken: $userToken, messages: $messages, temperature: $temperature, model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageRequest &&
            (identical(other.userToken, userToken) ||
                other.userToken == userToken) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.model, model) || other.model == model));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userToken,
      const DeepCollectionEquality().hash(_messages), temperature, model);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageRequestCopyWith<_$_MessageRequest> get copyWith =>
      __$$_MessageRequestCopyWithImpl<_$_MessageRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageRequestToJson(
      this,
    );
  }
}

abstract class _MessageRequest implements MessageRequest {
  const factory _MessageRequest(
      {required final String userToken,
      required final List<Message> messages,
      required final double temperature,
      required final String model}) = _$_MessageRequest;

  factory _MessageRequest.fromJson(Map<String, dynamic> json) =
      _$_MessageRequest.fromJson;

  @override
  String get userToken;
  @override
  List<Message> get messages;
  @override
  double get temperature;
  @override
  String get model;
  @override
  @JsonKey(ignore: true)
  _$$_MessageRequestCopyWith<_$_MessageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
