// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Memory _$MemoryFromJson(Map<String, dynamic> json) {
  return _Memory.fromJson(json);
}

/// @nodoc
mixin _$Memory {
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get addedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get reactions => throw _privateConstructorUsedError;

  /// Serializes this Memory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoryCopyWith<Memory> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoryCopyWith<$Res> {
  factory $MemoryCopyWith(Memory value, $Res Function(Memory) then) =
      _$MemoryCopyWithImpl<$Res, Memory>;
  @useResult
  $Res call({
    String? id,
    String title,
    String? description,
    String imageUrl,
    String addedBy,
    DateTime createdAt,
    List<String> reactions,
  });
}

/// @nodoc
class _$MemoryCopyWithImpl<$Res, $Val extends Memory>
    implements $MemoryCopyWith<$Res> {
  _$MemoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = null,
    Object? addedBy = null,
    Object? createdAt = null,
    Object? reactions = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            addedBy: null == addedBy
                ? _value.addedBy
                : addedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            reactions: null == reactions
                ? _value.reactions
                : reactions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemoryImplCopyWith<$Res> implements $MemoryCopyWith<$Res> {
  factory _$$MemoryImplCopyWith(
    _$MemoryImpl value,
    $Res Function(_$MemoryImpl) then,
  ) = __$$MemoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String title,
    String? description,
    String imageUrl,
    String addedBy,
    DateTime createdAt,
    List<String> reactions,
  });
}

/// @nodoc
class __$$MemoryImplCopyWithImpl<$Res>
    extends _$MemoryCopyWithImpl<$Res, _$MemoryImpl>
    implements _$$MemoryImplCopyWith<$Res> {
  __$$MemoryImplCopyWithImpl(
    _$MemoryImpl _value,
    $Res Function(_$MemoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? imageUrl = null,
    Object? addedBy = null,
    Object? createdAt = null,
    Object? reactions = null,
  }) {
    return _then(
      _$MemoryImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        addedBy: null == addedBy
            ? _value.addedBy
            : addedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reactions: null == reactions
            ? _value._reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoryImpl implements _Memory {
  const _$MemoryImpl({
    this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.addedBy,
    required this.createdAt,
    final List<String> reactions = const [],
  }) : _reactions = reactions;

  factory _$MemoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoryImplFromJson(json);

  @override
  final String? id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String imageUrl;
  @override
  final String addedBy;
  @override
  final DateTime createdAt;
  final List<String> _reactions;
  @override
  @JsonKey()
  List<String> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  String toString() {
    return 'Memory(id: $id, title: $title, description: $description, imageUrl: $imageUrl, addedBy: $addedBy, createdAt: $createdAt, reactions: $reactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._reactions,
              _reactions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    imageUrl,
    addedBy,
    createdAt,
    const DeepCollectionEquality().hash(_reactions),
  );

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoryImplCopyWith<_$MemoryImpl> get copyWith =>
      __$$MemoryImplCopyWithImpl<_$MemoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoryImplToJson(this);
  }
}

abstract class _Memory implements Memory {
  const factory _Memory({
    final String? id,
    required final String title,
    final String? description,
    required final String imageUrl,
    required final String addedBy,
    required final DateTime createdAt,
    final List<String> reactions,
  }) = _$MemoryImpl;

  factory _Memory.fromJson(Map<String, dynamic> json) = _$MemoryImpl.fromJson;

  @override
  String? get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get imageUrl;
  @override
  String get addedBy;
  @override
  DateTime get createdAt;
  @override
  List<String> get reactions;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoryImplCopyWith<_$MemoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
