// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cycle_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CycleEntry _$CycleEntryFromJson(Map<String, dynamic> json) {
  return _CycleEntry.fromJson(json);
}

/// @nodoc
mixin _$CycleEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get cycleLength => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CycleEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CycleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CycleEntryCopyWith<CycleEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CycleEntryCopyWith<$Res> {
  factory $CycleEntryCopyWith(
    CycleEntry value,
    $Res Function(CycleEntry) then,
  ) = _$CycleEntryCopyWithImpl<$Res, CycleEntry>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startDate,
    DateTime? endDate,
    int? cycleLength,
    bool synced,
    DateTime createdAt,
  });
}

/// @nodoc
class _$CycleEntryCopyWithImpl<$Res, $Val extends CycleEntry>
    implements $CycleEntryCopyWith<$Res> {
  _$CycleEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CycleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? cycleLength = freezed,
    Object? synced = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cycleLength: freezed == cycleLength
                ? _value.cycleLength
                : cycleLength // ignore: cast_nullable_to_non_nullable
                      as int?,
            synced: null == synced
                ? _value.synced
                : synced // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$CycleEntryImplCopyWith<$Res>
    implements $CycleEntryCopyWith<$Res> {
  factory _$$CycleEntryImplCopyWith(
    _$CycleEntryImpl value,
    $Res Function(_$CycleEntryImpl) then,
  ) = __$$CycleEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime startDate,
    DateTime? endDate,
    int? cycleLength,
    bool synced,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$CycleEntryImplCopyWithImpl<$Res>
    extends _$CycleEntryCopyWithImpl<$Res, _$CycleEntryImpl>
    implements _$$CycleEntryImplCopyWith<$Res> {
  __$$CycleEntryImplCopyWithImpl(
    _$CycleEntryImpl _value,
    $Res Function(_$CycleEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CycleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? cycleLength = freezed,
    Object? synced = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$CycleEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cycleLength: freezed == cycleLength
            ? _value.cycleLength
            : cycleLength // ignore: cast_nullable_to_non_nullable
                  as int?,
        synced: null == synced
            ? _value.synced
            : synced // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$CycleEntryImpl implements _CycleEntry {
  const _$CycleEntryImpl({
    required this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
    this.cycleLength,
    this.synced = false,
    required this.createdAt,
  });

  factory _$CycleEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CycleEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final int? cycleLength;
  @override
  @JsonKey()
  final bool synced;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CycleEntry(id: $id, userId: $userId, startDate: $startDate, endDate: $endDate, cycleLength: $cycleLength, synced: $synced, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CycleEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.cycleLength, cycleLength) ||
                other.cycleLength == cycleLength) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    startDate,
    endDate,
    cycleLength,
    synced,
    createdAt,
  );

  /// Create a copy of CycleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CycleEntryImplCopyWith<_$CycleEntryImpl> get copyWith =>
      __$$CycleEntryImplCopyWithImpl<_$CycleEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CycleEntryImplToJson(this);
  }
}

abstract class _CycleEntry implements CycleEntry {
  const factory _CycleEntry({
    required final String id,
    required final String userId,
    required final DateTime startDate,
    final DateTime? endDate,
    final int? cycleLength,
    final bool synced,
    required final DateTime createdAt,
  }) = _$CycleEntryImpl;

  factory _CycleEntry.fromJson(Map<String, dynamic> json) =
      _$CycleEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  int? get cycleLength;
  @override
  bool get synced;
  @override
  DateTime get createdAt;

  /// Create a copy of CycleEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CycleEntryImplCopyWith<_$CycleEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
