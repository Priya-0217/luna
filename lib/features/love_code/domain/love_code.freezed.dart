// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'love_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoveCode _$LoveCodeFromJson(Map<String, dynamic> json) {
  return _LoveCode.fromJson(json);
}

/// @nodoc
mixin _$LoveCode {
  String get code => throw _privateConstructorUsedError;
  String get ownerUid => throw _privateConstructorUsedError;
  String get ownerRole => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String? get linkedUid => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get linkedAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get expiresAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this LoveCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoveCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoveCodeCopyWith<LoveCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoveCodeCopyWith<$Res> {
  factory $LoveCodeCopyWith(LoveCode value, $Res Function(LoveCode) then) =
      _$LoveCodeCopyWithImpl<$Res, LoveCode>;
  @useResult
  $Res call({
    String code,
    String ownerUid,
    String ownerRole,
    String ownerName,
    String? linkedUid,
    @TimestampConverter() DateTime? linkedAt,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    bool isActive,
  });
}

/// @nodoc
class _$LoveCodeCopyWithImpl<$Res, $Val extends LoveCode>
    implements $LoveCodeCopyWith<$Res> {
  _$LoveCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoveCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? ownerUid = null,
    Object? ownerRole = null,
    Object? ownerName = null,
    Object? linkedUid = freezed,
    Object? linkedAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerUid: null == ownerUid
                ? _value.ownerUid
                : ownerUid // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerRole: null == ownerRole
                ? _value.ownerRole
                : ownerRole // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerName: null == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String,
            linkedUid: freezed == linkedUid
                ? _value.linkedUid
                : linkedUid // ignore: cast_nullable_to_non_nullable
                      as String?,
            linkedAt: freezed == linkedAt
                ? _value.linkedAt
                : linkedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoveCodeImplCopyWith<$Res>
    implements $LoveCodeCopyWith<$Res> {
  factory _$$LoveCodeImplCopyWith(
    _$LoveCodeImpl value,
    $Res Function(_$LoveCodeImpl) then,
  ) = __$$LoveCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String code,
    String ownerUid,
    String ownerRole,
    String ownerName,
    String? linkedUid,
    @TimestampConverter() DateTime? linkedAt,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime expiresAt,
    bool isActive,
  });
}

/// @nodoc
class __$$LoveCodeImplCopyWithImpl<$Res>
    extends _$LoveCodeCopyWithImpl<$Res, _$LoveCodeImpl>
    implements _$$LoveCodeImplCopyWith<$Res> {
  __$$LoveCodeImplCopyWithImpl(
    _$LoveCodeImpl _value,
    $Res Function(_$LoveCodeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoveCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? ownerUid = null,
    Object? ownerRole = null,
    Object? ownerName = null,
    Object? linkedUid = freezed,
    Object? linkedAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
  }) {
    return _then(
      _$LoveCodeImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerUid: null == ownerUid
            ? _value.ownerUid
            : ownerUid // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerRole: null == ownerRole
            ? _value.ownerRole
            : ownerRole // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        linkedUid: freezed == linkedUid
            ? _value.linkedUid
            : linkedUid // ignore: cast_nullable_to_non_nullable
                  as String?,
        linkedAt: freezed == linkedAt
            ? _value.linkedAt
            : linkedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoveCodeImpl implements _LoveCode {
  const _$LoveCodeImpl({
    required this.code,
    required this.ownerUid,
    required this.ownerRole,
    required this.ownerName,
    this.linkedUid,
    @TimestampConverter() this.linkedAt,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.expiresAt,
    this.isActive = true,
  });

  factory _$LoveCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoveCodeImplFromJson(json);

  @override
  final String code;
  @override
  final String ownerUid;
  @override
  final String ownerRole;
  @override
  final String ownerName;
  @override
  final String? linkedUid;
  @override
  @TimestampConverter()
  final DateTime? linkedAt;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime expiresAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'LoveCode(code: $code, ownerUid: $ownerUid, ownerRole: $ownerRole, ownerName: $ownerName, linkedUid: $linkedUid, linkedAt: $linkedAt, createdAt: $createdAt, expiresAt: $expiresAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoveCodeImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.ownerUid, ownerUid) ||
                other.ownerUid == ownerUid) &&
            (identical(other.ownerRole, ownerRole) ||
                other.ownerRole == ownerRole) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.linkedUid, linkedUid) ||
                other.linkedUid == linkedUid) &&
            (identical(other.linkedAt, linkedAt) ||
                other.linkedAt == linkedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    code,
    ownerUid,
    ownerRole,
    ownerName,
    linkedUid,
    linkedAt,
    createdAt,
    expiresAt,
    isActive,
  );

  /// Create a copy of LoveCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoveCodeImplCopyWith<_$LoveCodeImpl> get copyWith =>
      __$$LoveCodeImplCopyWithImpl<_$LoveCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoveCodeImplToJson(this);
  }
}

abstract class _LoveCode implements LoveCode {
  const factory _LoveCode({
    required final String code,
    required final String ownerUid,
    required final String ownerRole,
    required final String ownerName,
    final String? linkedUid,
    @TimestampConverter() final DateTime? linkedAt,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime expiresAt,
    final bool isActive,
  }) = _$LoveCodeImpl;

  factory _LoveCode.fromJson(Map<String, dynamic> json) =
      _$LoveCodeImpl.fromJson;

  @override
  String get code;
  @override
  String get ownerUid;
  @override
  String get ownerRole;
  @override
  String get ownerName;
  @override
  String? get linkedUid;
  @override
  @TimestampConverter()
  DateTime? get linkedAt;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get expiresAt;
  @override
  bool get isActive;

  /// Create a copy of LoveCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoveCodeImplCopyWith<_$LoveCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
