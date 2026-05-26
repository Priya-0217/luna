// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppUser _$AppUserFromJson(Map<String, dynamic> json) {
  return _AppUser.fromJson(json);
}

/// @nodoc
mixin _$AppUser {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get partnerUid => throw _privateConstructorUsedError;
  String? get coupleId => throw _privateConstructorUsedError;
  bool get isLinked => throw _privateConstructorUsedError;
  int get cycleAverageLength => throw _privateConstructorUsedError;
  int get periodAverageLength => throw _privateConstructorUsedError;
  bool get isOnboarded => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get myLoveCode => throw _privateConstructorUsedError;
  String? get partnerRole => throw _privateConstructorUsedError;
  String? get partnerDisplayName => throw _privateConstructorUsedError;

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppUserCopyWith<AppUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) then) =
      _$AppUserCopyWithImpl<$Res, AppUser>;
  @useResult
  $Res call({
    String uid,
    String email,
    String displayName,
    String? partnerUid,
    String? coupleId,
    bool isLinked,
    int cycleAverageLength,
    int periodAverageLength,
    bool isOnboarded,
    String? role,
    String? myLoveCode,
    String? partnerRole,
    String? partnerDisplayName,
  });
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res, $Val extends AppUser>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? partnerUid = freezed,
    Object? coupleId = freezed,
    Object? isLinked = null,
    Object? cycleAverageLength = null,
    Object? periodAverageLength = null,
    Object? isOnboarded = null,
    Object? role = freezed,
    Object? myLoveCode = freezed,
    Object? partnerRole = freezed,
    Object? partnerDisplayName = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            partnerUid: freezed == partnerUid
                ? _value.partnerUid
                : partnerUid // ignore: cast_nullable_to_non_nullable
                      as String?,
            coupleId: freezed == coupleId
                ? _value.coupleId
                : coupleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isLinked: null == isLinked
                ? _value.isLinked
                : isLinked // ignore: cast_nullable_to_non_nullable
                      as bool,
            cycleAverageLength: null == cycleAverageLength
                ? _value.cycleAverageLength
                : cycleAverageLength // ignore: cast_nullable_to_non_nullable
                      as int,
            periodAverageLength: null == periodAverageLength
                ? _value.periodAverageLength
                : periodAverageLength // ignore: cast_nullable_to_non_nullable
                      as int,
            isOnboarded: null == isOnboarded
                ? _value.isOnboarded
                : isOnboarded // ignore: cast_nullable_to_non_nullable
                      as bool,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            myLoveCode: freezed == myLoveCode
                ? _value.myLoveCode
                : myLoveCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            partnerRole: freezed == partnerRole
                ? _value.partnerRole
                : partnerRole // ignore: cast_nullable_to_non_nullable
                      as String?,
            partnerDisplayName: freezed == partnerDisplayName
                ? _value.partnerDisplayName
                : partnerDisplayName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppUserImplCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$$AppUserImplCopyWith(
    _$AppUserImpl value,
    $Res Function(_$AppUserImpl) then,
  ) = __$$AppUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String email,
    String displayName,
    String? partnerUid,
    String? coupleId,
    bool isLinked,
    int cycleAverageLength,
    int periodAverageLength,
    bool isOnboarded,
    String? role,
    String? myLoveCode,
    String? partnerRole,
    String? partnerDisplayName,
  });
}

/// @nodoc
class __$$AppUserImplCopyWithImpl<$Res>
    extends _$AppUserCopyWithImpl<$Res, _$AppUserImpl>
    implements _$$AppUserImplCopyWith<$Res> {
  __$$AppUserImplCopyWithImpl(
    _$AppUserImpl _value,
    $Res Function(_$AppUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? displayName = null,
    Object? partnerUid = freezed,
    Object? coupleId = freezed,
    Object? isLinked = null,
    Object? cycleAverageLength = null,
    Object? periodAverageLength = null,
    Object? isOnboarded = null,
    Object? role = freezed,
    Object? myLoveCode = freezed,
    Object? partnerRole = freezed,
    Object? partnerDisplayName = freezed,
  }) {
    return _then(
      _$AppUserImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        partnerUid: freezed == partnerUid
            ? _value.partnerUid
            : partnerUid // ignore: cast_nullable_to_non_nullable
                  as String?,
        coupleId: freezed == coupleId
            ? _value.coupleId
            : coupleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isLinked: null == isLinked
            ? _value.isLinked
            : isLinked // ignore: cast_nullable_to_non_nullable
                  as bool,
        cycleAverageLength: null == cycleAverageLength
            ? _value.cycleAverageLength
            : cycleAverageLength // ignore: cast_nullable_to_non_nullable
                  as int,
        periodAverageLength: null == periodAverageLength
            ? _value.periodAverageLength
            : periodAverageLength // ignore: cast_nullable_to_non_nullable
                  as int,
        isOnboarded: null == isOnboarded
            ? _value.isOnboarded
            : isOnboarded // ignore: cast_nullable_to_non_nullable
                  as bool,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        myLoveCode: freezed == myLoveCode
            ? _value.myLoveCode
            : myLoveCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        partnerRole: freezed == partnerRole
            ? _value.partnerRole
            : partnerRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        partnerDisplayName: freezed == partnerDisplayName
            ? _value.partnerDisplayName
            : partnerDisplayName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppUserImpl implements _AppUser {
  const _$AppUserImpl({
    required this.uid,
    required this.email,
    required this.displayName,
    this.partnerUid,
    this.coupleId,
    this.isLinked = false,
    this.cycleAverageLength = 28,
    this.periodAverageLength = 5,
    this.isOnboarded = false,
    this.role,
    this.myLoveCode,
    this.partnerRole,
    this.partnerDisplayName,
  });

  factory _$AppUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppUserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? partnerUid;
  @override
  final String? coupleId;
  @override
  @JsonKey()
  final bool isLinked;
  @override
  @JsonKey()
  final int cycleAverageLength;
  @override
  @JsonKey()
  final int periodAverageLength;
  @override
  @JsonKey()
  final bool isOnboarded;
  @override
  final String? role;
  @override
  final String? myLoveCode;
  @override
  final String? partnerRole;
  @override
  final String? partnerDisplayName;

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, displayName: $displayName, partnerUid: $partnerUid, coupleId: $coupleId, isLinked: $isLinked, cycleAverageLength: $cycleAverageLength, periodAverageLength: $periodAverageLength, isOnboarded: $isOnboarded, role: $role, myLoveCode: $myLoveCode, partnerRole: $partnerRole, partnerDisplayName: $partnerDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppUserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.partnerUid, partnerUid) ||
                other.partnerUid == partnerUid) &&
            (identical(other.coupleId, coupleId) ||
                other.coupleId == coupleId) &&
            (identical(other.isLinked, isLinked) ||
                other.isLinked == isLinked) &&
            (identical(other.cycleAverageLength, cycleAverageLength) ||
                other.cycleAverageLength == cycleAverageLength) &&
            (identical(other.periodAverageLength, periodAverageLength) ||
                other.periodAverageLength == periodAverageLength) &&
            (identical(other.isOnboarded, isOnboarded) ||
                other.isOnboarded == isOnboarded) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.myLoveCode, myLoveCode) ||
                other.myLoveCode == myLoveCode) &&
            (identical(other.partnerRole, partnerRole) ||
                other.partnerRole == partnerRole) &&
            (identical(other.partnerDisplayName, partnerDisplayName) ||
                other.partnerDisplayName == partnerDisplayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    email,
    displayName,
    partnerUid,
    coupleId,
    isLinked,
    cycleAverageLength,
    periodAverageLength,
    isOnboarded,
    role,
    myLoveCode,
    partnerRole,
    partnerDisplayName,
  );

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      __$$AppUserImplCopyWithImpl<_$AppUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppUserImplToJson(this);
  }
}

abstract class _AppUser implements AppUser {
  const factory _AppUser({
    required final String uid,
    required final String email,
    required final String displayName,
    final String? partnerUid,
    final String? coupleId,
    final bool isLinked,
    final int cycleAverageLength,
    final int periodAverageLength,
    final bool isOnboarded,
    final String? role,
    final String? myLoveCode,
    final String? partnerRole,
    final String? partnerDisplayName,
  }) = _$AppUserImpl;

  factory _AppUser.fromJson(Map<String, dynamic> json) = _$AppUserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get partnerUid;
  @override
  String? get coupleId;
  @override
  bool get isLinked;
  @override
  int get cycleAverageLength;
  @override
  int get periodAverageLength;
  @override
  bool get isOnboarded;
  @override
  String? get role;
  @override
  String? get myLoveCode;
  @override
  String? get partnerRole;
  @override
  String? get partnerDisplayName;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppUserImplCopyWith<_$AppUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
