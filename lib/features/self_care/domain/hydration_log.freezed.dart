// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hydration_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HydrationLog _$HydrationLogFromJson(Map<String, dynamic> json) {
  return _HydrationLog.fromJson(json);
}

/// @nodoc
mixin _$HydrationLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  double get amountMl => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;

  /// Serializes this HydrationLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HydrationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HydrationLogCopyWith<HydrationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HydrationLogCopyWith<$Res> {
  factory $HydrationLogCopyWith(
    HydrationLog value,
    $Res Function(HydrationLog) then,
  ) = _$HydrationLogCopyWithImpl<$Res, HydrationLog>;
  @useResult
  $Res call({
    String id,
    String userId,
    double amountMl,
    DateTime timestamp,
    bool synced,
  });
}

/// @nodoc
class _$HydrationLogCopyWithImpl<$Res, $Val extends HydrationLog>
    implements $HydrationLogCopyWith<$Res> {
  _$HydrationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HydrationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? timestamp = null,
    Object? synced = null,
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
            amountMl: null == amountMl
                ? _value.amountMl
                : amountMl // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            synced: null == synced
                ? _value.synced
                : synced // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HydrationLogImplCopyWith<$Res>
    implements $HydrationLogCopyWith<$Res> {
  factory _$$HydrationLogImplCopyWith(
    _$HydrationLogImpl value,
    $Res Function(_$HydrationLogImpl) then,
  ) = __$$HydrationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    double amountMl,
    DateTime timestamp,
    bool synced,
  });
}

/// @nodoc
class __$$HydrationLogImplCopyWithImpl<$Res>
    extends _$HydrationLogCopyWithImpl<$Res, _$HydrationLogImpl>
    implements _$$HydrationLogImplCopyWith<$Res> {
  __$$HydrationLogImplCopyWithImpl(
    _$HydrationLogImpl _value,
    $Res Function(_$HydrationLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HydrationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? amountMl = null,
    Object? timestamp = null,
    Object? synced = null,
  }) {
    return _then(
      _$HydrationLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountMl: null == amountMl
            ? _value.amountMl
            : amountMl // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        synced: null == synced
            ? _value.synced
            : synced // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HydrationLogImpl implements _HydrationLog {
  const _$HydrationLogImpl({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    this.synced = false,
  });

  factory _$HydrationLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$HydrationLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final double amountMl;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'HydrationLog(id: $id, userId: $userId, amountMl: $amountMl, timestamp: $timestamp, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HydrationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amountMl, amountMl) ||
                other.amountMl == amountMl) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, amountMl, timestamp, synced);

  /// Create a copy of HydrationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HydrationLogImplCopyWith<_$HydrationLogImpl> get copyWith =>
      __$$HydrationLogImplCopyWithImpl<_$HydrationLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HydrationLogImplToJson(this);
  }
}

abstract class _HydrationLog implements HydrationLog {
  const factory _HydrationLog({
    required final String id,
    required final String userId,
    required final double amountMl,
    required final DateTime timestamp,
    final bool synced,
  }) = _$HydrationLogImpl;

  factory _HydrationLog.fromJson(Map<String, dynamic> json) =
      _$HydrationLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  double get amountMl;
  @override
  DateTime get timestamp;
  @override
  bool get synced;

  /// Create a copy of HydrationLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HydrationLogImplCopyWith<_$HydrationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
