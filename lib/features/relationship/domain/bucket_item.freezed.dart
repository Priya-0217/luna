// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bucket_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BucketItem _$BucketItemFromJson(Map<String, dynamic> json) {
  return _BucketItem.fromJson(json);
}

/// @nodoc
mixin _$BucketItem {
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  String get addedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this BucketItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BucketItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BucketItemCopyWith<BucketItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BucketItemCopyWith<$Res> {
  factory $BucketItemCopyWith(
    BucketItem value,
    $Res Function(BucketItem) then,
  ) = _$BucketItemCopyWithImpl<$Res, BucketItem>;
  @useResult
  $Res call({
    String? id,
    String title,
    bool isCompleted,
    String addedBy,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$BucketItemCopyWithImpl<$Res, $Val extends BucketItem>
    implements $BucketItemCopyWith<$Res> {
  _$BucketItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BucketItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? isCompleted = null,
    Object? addedBy = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
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
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            addedBy: null == addedBy
                ? _value.addedBy
                : addedBy // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BucketItemImplCopyWith<$Res>
    implements $BucketItemCopyWith<$Res> {
  factory _$$BucketItemImplCopyWith(
    _$BucketItemImpl value,
    $Res Function(_$BucketItemImpl) then,
  ) = __$$BucketItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? id,
    String title,
    bool isCompleted,
    String addedBy,
    DateTime createdAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$BucketItemImplCopyWithImpl<$Res>
    extends _$BucketItemCopyWithImpl<$Res, _$BucketItemImpl>
    implements _$$BucketItemImplCopyWith<$Res> {
  __$$BucketItemImplCopyWithImpl(
    _$BucketItemImpl _value,
    $Res Function(_$BucketItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BucketItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? isCompleted = null,
    Object? addedBy = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$BucketItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        addedBy: null == addedBy
            ? _value.addedBy
            : addedBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BucketItemImpl implements _BucketItem {
  const _$BucketItemImpl({
    this.id,
    required this.title,
    this.isCompleted = false,
    required this.addedBy,
    required this.createdAt,
    this.completedAt,
  });

  factory _$BucketItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BucketItemImplFromJson(json);

  @override
  final String? id;
  @override
  final String title;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final String addedBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'BucketItem(id: $id, title: $title, isCompleted: $isCompleted, addedBy: $addedBy, createdAt: $createdAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BucketItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    isCompleted,
    addedBy,
    createdAt,
    completedAt,
  );

  /// Create a copy of BucketItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BucketItemImplCopyWith<_$BucketItemImpl> get copyWith =>
      __$$BucketItemImplCopyWithImpl<_$BucketItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BucketItemImplToJson(this);
  }
}

abstract class _BucketItem implements BucketItem {
  const factory _BucketItem({
    final String? id,
    required final String title,
    final bool isCompleted,
    required final String addedBy,
    required final DateTime createdAt,
    final DateTime? completedAt,
  }) = _$BucketItemImpl;

  factory _BucketItem.fromJson(Map<String, dynamic> json) =
      _$BucketItemImpl.fromJson;

  @override
  String? get id;
  @override
  String get title;
  @override
  bool get isCompleted;
  @override
  String get addedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of BucketItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BucketItemImplCopyWith<_$BucketItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
