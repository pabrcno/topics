// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_generation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ImageGenerationRequest _$ImageGenerationRequestFromJson(
    Map<String, dynamic> json) {
  return _ImageGenerationRequest.fromJson(json);
}

/// @nodoc
mixin _$ImageGenerationRequest {
  String get prompt => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get steps => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImageGenerationRequestCopyWith<ImageGenerationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageGenerationRequestCopyWith<$Res> {
  factory $ImageGenerationRequestCopyWith(ImageGenerationRequest value,
          $Res Function(ImageGenerationRequest) then) =
      _$ImageGenerationRequestCopyWithImpl<$Res, ImageGenerationRequest>;
  @useResult
  $Res call(
      {String prompt,
      double weight,
      int height,
      int width,
      int steps,
      String chatId});
}

/// @nodoc
class _$ImageGenerationRequestCopyWithImpl<$Res,
        $Val extends ImageGenerationRequest>
    implements $ImageGenerationRequestCopyWith<$Res> {
  _$ImageGenerationRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? weight = null,
    Object? height = null,
    Object? width = null,
    Object? steps = null,
    Object? chatId = null,
  }) {
    return _then(_value.copyWith(
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImageGenerationRequestCopyWith<$Res>
    implements $ImageGenerationRequestCopyWith<$Res> {
  factory _$$_ImageGenerationRequestCopyWith(_$_ImageGenerationRequest value,
          $Res Function(_$_ImageGenerationRequest) then) =
      __$$_ImageGenerationRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String prompt,
      double weight,
      int height,
      int width,
      int steps,
      String chatId});
}

/// @nodoc
class __$$_ImageGenerationRequestCopyWithImpl<$Res>
    extends _$ImageGenerationRequestCopyWithImpl<$Res,
        _$_ImageGenerationRequest>
    implements _$$_ImageGenerationRequestCopyWith<$Res> {
  __$$_ImageGenerationRequestCopyWithImpl(_$_ImageGenerationRequest _value,
      $Res Function(_$_ImageGenerationRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? weight = null,
    Object? height = null,
    Object? width = null,
    Object? steps = null,
    Object? chatId = null,
  }) {
    return _then(_$_ImageGenerationRequest(
      prompt: null == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ImageGenerationRequest implements _ImageGenerationRequest {
  const _$_ImageGenerationRequest(
      {required this.prompt,
      required this.weight,
      required this.height,
      required this.width,
      required this.steps,
      required this.chatId});

  factory _$_ImageGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$$_ImageGenerationRequestFromJson(json);

  @override
  final String prompt;
  @override
  final double weight;
  @override
  final int height;
  @override
  final int width;
  @override
  final int steps;
  @override
  final String chatId;

  @override
  String toString() {
    return 'ImageGenerationRequest(prompt: $prompt, weight: $weight, height: $height, width: $width, steps: $steps, chatId: $chatId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImageGenerationRequest &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.chatId, chatId) || other.chatId == chatId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, prompt, weight, height, width, steps, chatId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImageGenerationRequestCopyWith<_$_ImageGenerationRequest> get copyWith =>
      __$$_ImageGenerationRequestCopyWithImpl<_$_ImageGenerationRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImageGenerationRequestToJson(
      this,
    );
  }
}

abstract class _ImageGenerationRequest implements ImageGenerationRequest {
  const factory _ImageGenerationRequest(
      {required final String prompt,
      required final double weight,
      required final int height,
      required final int width,
      required final int steps,
      required final String chatId}) = _$_ImageGenerationRequest;

  factory _ImageGenerationRequest.fromJson(Map<String, dynamic> json) =
      _$_ImageGenerationRequest.fromJson;

  @override
  String get prompt;
  @override
  double get weight;
  @override
  int get height;
  @override
  int get width;
  @override
  int get steps;
  @override
  String get chatId;
  @override
  @JsonKey(ignore: true)
  _$$_ImageGenerationRequestCopyWith<_$_ImageGenerationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
