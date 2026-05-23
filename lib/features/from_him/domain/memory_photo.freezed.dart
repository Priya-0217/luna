// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MemoryPhoto _$MemoryPhotoFromJson(Map<String, dynamic> json) {
  return _MemoryPhoto.fromJson(json);
}

/// @nodoc
mixin _$MemoryPhoto {
  String get id => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  String get storageUrl => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  DateTime get takenAt => throw _privateConstructorUsedError;

  /// Serializes this MemoryPhoto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoryPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoryPhotoCopyWith<MemoryPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoryPhotoCopyWith<$Res> {
  factory $MemoryPhotoCopyWith(
    MemoryPhoto value,
    $Res Function(MemoryPhoto) then,
  ) = _$MemoryPhotoCopyWithImpl<$Res, MemoryPhoto>;
  @useResult
  $Res call({
    String id,
    String caption,
    String storageUrl,
    String? localPath,
    DateTime takenAt,
  });
}

/// @nodoc
class _$MemoryPhotoCopyWithImpl<$Res, $Val extends MemoryPhoto>
    implements $MemoryPhotoCopyWith<$Res> {
  _$MemoryPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoryPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? storageUrl = null,
    Object? localPath = freezed,
    Object? takenAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            storageUrl: null == storageUrl
                ? _value.storageUrl
                : storageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            localPath: freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            takenAt: null == takenAt
                ? _value.takenAt
                : takenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemoryPhotoImplCopyWith<$Res>
    implements $MemoryPhotoCopyWith<$Res> {
  factory _$$MemoryPhotoImplCopyWith(
    _$MemoryPhotoImpl value,
    $Res Function(_$MemoryPhotoImpl) then,
  ) = __$$MemoryPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String caption,
    String storageUrl,
    String? localPath,
    DateTime takenAt,
  });
}

/// @nodoc
class __$$MemoryPhotoImplCopyWithImpl<$Res>
    extends _$MemoryPhotoCopyWithImpl<$Res, _$MemoryPhotoImpl>
    implements _$$MemoryPhotoImplCopyWith<$Res> {
  __$$MemoryPhotoImplCopyWithImpl(
    _$MemoryPhotoImpl _value,
    $Res Function(_$MemoryPhotoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoryPhoto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? storageUrl = null,
    Object? localPath = freezed,
    Object? takenAt = null,
  }) {
    return _then(
      _$MemoryPhotoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        storageUrl: null == storageUrl
            ? _value.storageUrl
            : storageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        localPath: freezed == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        takenAt: null == takenAt
            ? _value.takenAt
            : takenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoryPhotoImpl implements _MemoryPhoto {
  const _$MemoryPhotoImpl({
    required this.id,
    required this.caption,
    required this.storageUrl,
    this.localPath,
    required this.takenAt,
  });

  factory _$MemoryPhotoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoryPhotoImplFromJson(json);

  @override
  final String id;
  @override
  final String caption;
  @override
  final String storageUrl;
  @override
  final String? localPath;
  @override
  final DateTime takenAt;

  @override
  String toString() {
    return 'MemoryPhoto(id: $id, caption: $caption, storageUrl: $storageUrl, localPath: $localPath, takenAt: $takenAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoryPhotoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.storageUrl, storageUrl) ||
                other.storageUrl == storageUrl) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.takenAt, takenAt) || other.takenAt == takenAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, caption, storageUrl, localPath, takenAt);

  /// Create a copy of MemoryPhoto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoryPhotoImplCopyWith<_$MemoryPhotoImpl> get copyWith =>
      __$$MemoryPhotoImplCopyWithImpl<_$MemoryPhotoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoryPhotoImplToJson(this);
  }
}

abstract class _MemoryPhoto implements MemoryPhoto {
  const factory _MemoryPhoto({
    required final String id,
    required final String caption,
    required final String storageUrl,
    final String? localPath,
    required final DateTime takenAt,
  }) = _$MemoryPhotoImpl;

  factory _MemoryPhoto.fromJson(Map<String, dynamic> json) =
      _$MemoryPhotoImpl.fromJson;

  @override
  String get id;
  @override
  String get caption;
  @override
  String get storageUrl;
  @override
  String? get localPath;
  @override
  DateTime get takenAt;

  /// Create a copy of MemoryPhoto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoryPhotoImplCopyWith<_$MemoryPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
