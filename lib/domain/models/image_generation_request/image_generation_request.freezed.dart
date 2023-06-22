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
  String? get prompt => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  int? get height => throw _privateConstructorUsedError;
  int? get width => throw _privateConstructorUsedError;
  int? get steps => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;
  double? get imageStrength => throw _privateConstructorUsedError;
  String? get initImageMode => throw _privateConstructorUsedError;
  String? get initImage => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get textPrompts =>
      throw _privateConstructorUsedError;
  int? get cfgScale => throw _privateConstructorUsedError;
  String? get clipGuidancePreset => throw _privateConstructorUsedError;
  String? get sampler => throw _privateConstructorUsedError;
  int? get samples => throw _privateConstructorUsedError;
  String? get stylePreset => throw _privateConstructorUsedError;

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
      {String? prompt,
      double? weight,
      int? height,
      int? width,
      int? steps,
      String chatId,
      double? imageStrength,
      String? initImageMode,
      String? initImage,
      List<Map<String, dynamic>>? textPrompts,
      int? cfgScale,
      String? clipGuidancePreset,
      String? sampler,
      int? samples,
      String? stylePreset});
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
    Object? prompt = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? steps = freezed,
    Object? chatId = null,
    Object? imageStrength = freezed,
    Object? initImageMode = freezed,
    Object? initImage = freezed,
    Object? textPrompts = freezed,
    Object? cfgScale = freezed,
    Object? clipGuidancePreset = freezed,
    Object? sampler = freezed,
    Object? samples = freezed,
    Object? stylePreset = freezed,
  }) {
    return _then(_value.copyWith(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      steps: freezed == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int?,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      imageStrength: freezed == imageStrength
          ? _value.imageStrength
          : imageStrength // ignore: cast_nullable_to_non_nullable
              as double?,
      initImageMode: freezed == initImageMode
          ? _value.initImageMode
          : initImageMode // ignore: cast_nullable_to_non_nullable
              as String?,
      initImage: freezed == initImage
          ? _value.initImage
          : initImage // ignore: cast_nullable_to_non_nullable
              as String?,
      textPrompts: freezed == textPrompts
          ? _value.textPrompts
          : textPrompts // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      cfgScale: freezed == cfgScale
          ? _value.cfgScale
          : cfgScale // ignore: cast_nullable_to_non_nullable
              as int?,
      clipGuidancePreset: freezed == clipGuidancePreset
          ? _value.clipGuidancePreset
          : clipGuidancePreset // ignore: cast_nullable_to_non_nullable
              as String?,
      sampler: freezed == sampler
          ? _value.sampler
          : sampler // ignore: cast_nullable_to_non_nullable
              as String?,
      samples: freezed == samples
          ? _value.samples
          : samples // ignore: cast_nullable_to_non_nullable
              as int?,
      stylePreset: freezed == stylePreset
          ? _value.stylePreset
          : stylePreset // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String? prompt,
      double? weight,
      int? height,
      int? width,
      int? steps,
      String chatId,
      double? imageStrength,
      String? initImageMode,
      String? initImage,
      List<Map<String, dynamic>>? textPrompts,
      int? cfgScale,
      String? clipGuidancePreset,
      String? sampler,
      int? samples,
      String? stylePreset});
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
    Object? prompt = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? width = freezed,
    Object? steps = freezed,
    Object? chatId = null,
    Object? imageStrength = freezed,
    Object? initImageMode = freezed,
    Object? initImage = freezed,
    Object? textPrompts = freezed,
    Object? cfgScale = freezed,
    Object? clipGuidancePreset = freezed,
    Object? sampler = freezed,
    Object? samples = freezed,
    Object? stylePreset = freezed,
  }) {
    return _then(_$_ImageGenerationRequest(
      prompt: freezed == prompt
          ? _value.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      steps: freezed == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as int?,
      chatId: null == chatId
          ? _value.chatId
          : chatId // ignore: cast_nullable_to_non_nullable
              as String,
      imageStrength: freezed == imageStrength
          ? _value.imageStrength
          : imageStrength // ignore: cast_nullable_to_non_nullable
              as double?,
      initImageMode: freezed == initImageMode
          ? _value.initImageMode
          : initImageMode // ignore: cast_nullable_to_non_nullable
              as String?,
      initImage: freezed == initImage
          ? _value.initImage
          : initImage // ignore: cast_nullable_to_non_nullable
              as String?,
      textPrompts: freezed == textPrompts
          ? _value._textPrompts
          : textPrompts // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      cfgScale: freezed == cfgScale
          ? _value.cfgScale
          : cfgScale // ignore: cast_nullable_to_non_nullable
              as int?,
      clipGuidancePreset: freezed == clipGuidancePreset
          ? _value.clipGuidancePreset
          : clipGuidancePreset // ignore: cast_nullable_to_non_nullable
              as String?,
      sampler: freezed == sampler
          ? _value.sampler
          : sampler // ignore: cast_nullable_to_non_nullable
              as String?,
      samples: freezed == samples
          ? _value.samples
          : samples // ignore: cast_nullable_to_non_nullable
              as int?,
      stylePreset: freezed == stylePreset
          ? _value.stylePreset
          : stylePreset // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ImageGenerationRequest implements _ImageGenerationRequest {
  const _$_ImageGenerationRequest(
      {this.prompt,
      this.weight,
      this.height,
      this.width,
      this.steps,
      required this.chatId,
      this.imageStrength,
      this.initImageMode,
      this.initImage,
      final List<Map<String, dynamic>>? textPrompts,
      this.cfgScale,
      this.clipGuidancePreset,
      this.sampler,
      this.samples,
      this.stylePreset})
      : _textPrompts = textPrompts;

  factory _$_ImageGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$$_ImageGenerationRequestFromJson(json);

  @override
  final String? prompt;
  @override
  final double? weight;
  @override
  final int? height;
  @override
  final int? width;
  @override
  final int? steps;
  @override
  final String chatId;
  @override
  final double? imageStrength;
  @override
  final String? initImageMode;
  @override
  final String? initImage;
  final List<Map<String, dynamic>>? _textPrompts;
  @override
  List<Map<String, dynamic>>? get textPrompts {
    final value = _textPrompts;
    if (value == null) return null;
    if (_textPrompts is EqualUnmodifiableListView) return _textPrompts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? cfgScale;
  @override
  final String? clipGuidancePreset;
  @override
  final String? sampler;
  @override
  final int? samples;
  @override
  final String? stylePreset;

  @override
  String toString() {
    return 'ImageGenerationRequest(prompt: $prompt, weight: $weight, height: $height, width: $width, steps: $steps, chatId: $chatId, imageStrength: $imageStrength, initImageMode: $initImageMode, initImage: $initImage, textPrompts: $textPrompts, cfgScale: $cfgScale, clipGuidancePreset: $clipGuidancePreset, sampler: $sampler, samples: $samples, stylePreset: $stylePreset)';
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
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.imageStrength, imageStrength) ||
                other.imageStrength == imageStrength) &&
            (identical(other.initImageMode, initImageMode) ||
                other.initImageMode == initImageMode) &&
            (identical(other.initImage, initImage) ||
                other.initImage == initImage) &&
            const DeepCollectionEquality()
                .equals(other._textPrompts, _textPrompts) &&
            (identical(other.cfgScale, cfgScale) ||
                other.cfgScale == cfgScale) &&
            (identical(other.clipGuidancePreset, clipGuidancePreset) ||
                other.clipGuidancePreset == clipGuidancePreset) &&
            (identical(other.sampler, sampler) || other.sampler == sampler) &&
            (identical(other.samples, samples) || other.samples == samples) &&
            (identical(other.stylePreset, stylePreset) ||
                other.stylePreset == stylePreset));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      prompt,
      weight,
      height,
      width,
      steps,
      chatId,
      imageStrength,
      initImageMode,
      initImage,
      const DeepCollectionEquality().hash(_textPrompts),
      cfgScale,
      clipGuidancePreset,
      sampler,
      samples,
      stylePreset);

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
      {final String? prompt,
      final double? weight,
      final int? height,
      final int? width,
      final int? steps,
      required final String chatId,
      final double? imageStrength,
      final String? initImageMode,
      final String? initImage,
      final List<Map<String, dynamic>>? textPrompts,
      final int? cfgScale,
      final String? clipGuidancePreset,
      final String? sampler,
      final int? samples,
      final String? stylePreset}) = _$_ImageGenerationRequest;

  factory _ImageGenerationRequest.fromJson(Map<String, dynamic> json) =
      _$_ImageGenerationRequest.fromJson;

  @override
  String? get prompt;
  @override
  double? get weight;
  @override
  int? get height;
  @override
  int? get width;
  @override
  int? get steps;
  @override
  String get chatId;
  @override
  double? get imageStrength;
  @override
  String? get initImageMode;
  @override
  String? get initImage;
  @override
  List<Map<String, dynamic>>? get textPrompts;
  @override
  int? get cfgScale;
  @override
  String? get clipGuidancePreset;
  @override
  String? get sampler;
  @override
  int? get samples;
  @override
  String? get stylePreset;
  @override
  @JsonKey(ignore: true)
  _$$_ImageGenerationRequestCopyWith<_$_ImageGenerationRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
