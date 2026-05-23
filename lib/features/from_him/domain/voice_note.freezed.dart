// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voice_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VoiceNote _$VoiceNoteFromJson(Map<String, dynamic> json) {
  return _VoiceNote.fromJson(json);
}

/// @nodoc
mixin _$VoiceNote {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get storageUrl => throw _privateConstructorUsedError;
  String? get localPath => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VoiceNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceNoteCopyWith<VoiceNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceNoteCopyWith<$Res> {
  factory $VoiceNoteCopyWith(VoiceNote value, $Res Function(VoiceNote) then) =
      _$VoiceNoteCopyWithImpl<$Res, VoiceNote>;
  @useResult
  $Res call({
    String id,
    String title,
    String storageUrl,
    String? localPath,
    int durationSeconds,
    DateTime createdAt,
  });
}

/// @nodoc
class _$VoiceNoteCopyWithImpl<$Res, $Val extends VoiceNote>
    implements $VoiceNoteCopyWith<$Res> {
  _$VoiceNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? storageUrl = null,
    Object? localPath = freezed,
    Object? durationSeconds = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            storageUrl: null == storageUrl
                ? _value.storageUrl
                : storageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            localPath: freezed == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoiceNoteImplCopyWith<$Res>
    implements $VoiceNoteCopyWith<$Res> {
  factory _$$VoiceNoteImplCopyWith(
    _$VoiceNoteImpl value,
    $Res Function(_$VoiceNoteImpl) then,
  ) = __$$VoiceNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String storageUrl,
    String? localPath,
    int durationSeconds,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$VoiceNoteImplCopyWithImpl<$Res>
    extends _$VoiceNoteCopyWithImpl<$Res, _$VoiceNoteImpl>
    implements _$$VoiceNoteImplCopyWith<$Res> {
  __$$VoiceNoteImplCopyWithImpl(
    _$VoiceNoteImpl _value,
    $Res Function(_$VoiceNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoiceNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? storageUrl = null,
    Object? localPath = freezed,
    Object? durationSeconds = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$VoiceNoteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        storageUrl: null == storageUrl
            ? _value.storageUrl
            : storageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        localPath: freezed == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceNoteImpl implements _VoiceNote {
  const _$VoiceNoteImpl({
    required this.id,
    required this.title,
    required this.storageUrl,
    this.localPath,
    this.durationSeconds = 0,
    required this.createdAt,
  });

  factory _$VoiceNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String storageUrl;
  @override
  final String? localPath;
  @override
  @JsonKey()
  final int durationSeconds;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'VoiceNote(id: $id, title: $title, storageUrl: $storageUrl, localPath: $localPath, durationSeconds: $durationSeconds, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.storageUrl, storageUrl) ||
                other.storageUrl == storageUrl) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    storageUrl,
    localPath,
    durationSeconds,
    createdAt,
  );

  /// Create a copy of VoiceNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceNoteImplCopyWith<_$VoiceNoteImpl> get copyWith =>
      __$$VoiceNoteImplCopyWithImpl<_$VoiceNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceNoteImplToJson(this);
  }
}

abstract class _VoiceNote implements VoiceNote {
  const factory _VoiceNote({
    required final String id,
    required final String title,
    required final String storageUrl,
    final String? localPath,
    final int durationSeconds,
    required final DateTime createdAt,
  }) = _$VoiceNoteImpl;

  factory _VoiceNote.fromJson(Map<String, dynamic> json) =
      _$VoiceNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get storageUrl;
  @override
  String? get localPath;
  @override
  int get durationSeconds;
  @override
  DateTime get createdAt;

  /// Create a copy of VoiceNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceNoteImplCopyWith<_$VoiceNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
