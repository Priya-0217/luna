// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'garden_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GardenState _$GardenStateFromJson(Map<String, dynamic> json) {
  return _GardenState.fromJson(json);
}

/// @nodoc
mixin _$GardenState {
  String get userId => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  int get totalFlowers => throw _privateConstructorUsedError;
  DateTime? get lastLogDate => throw _privateConstructorUsedError;
  String get weather => throw _privateConstructorUsedError;
  Map<String, int> get flowerCounts => throw _privateConstructorUsedError;

  /// Serializes this GardenState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GardenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GardenStateCopyWith<GardenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GardenStateCopyWith<$Res> {
  factory $GardenStateCopyWith(
    GardenState value,
    $Res Function(GardenState) then,
  ) = _$GardenStateCopyWithImpl<$Res, GardenState>;
  @useResult
  $Res call({
    String userId,
    int streak,
    int totalFlowers,
    DateTime? lastLogDate,
    String weather,
    Map<String, int> flowerCounts,
  });
}

/// @nodoc
class _$GardenStateCopyWithImpl<$Res, $Val extends GardenState>
    implements $GardenStateCopyWith<$Res> {
  _$GardenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GardenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? streak = null,
    Object? totalFlowers = null,
    Object? lastLogDate = freezed,
    Object? weather = null,
    Object? flowerCounts = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            streak: null == streak
                ? _value.streak
                : streak // ignore: cast_nullable_to_non_nullable
                      as int,
            totalFlowers: null == totalFlowers
                ? _value.totalFlowers
                : totalFlowers // ignore: cast_nullable_to_non_nullable
                      as int,
            lastLogDate: freezed == lastLogDate
                ? _value.lastLogDate
                : lastLogDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            weather: null == weather
                ? _value.weather
                : weather // ignore: cast_nullable_to_non_nullable
                      as String,
            flowerCounts: null == flowerCounts
                ? _value.flowerCounts
                : flowerCounts // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GardenStateImplCopyWith<$Res>
    implements $GardenStateCopyWith<$Res> {
  factory _$$GardenStateImplCopyWith(
    _$GardenStateImpl value,
    $Res Function(_$GardenStateImpl) then,
  ) = __$$GardenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int streak,
    int totalFlowers,
    DateTime? lastLogDate,
    String weather,
    Map<String, int> flowerCounts,
  });
}

/// @nodoc
class __$$GardenStateImplCopyWithImpl<$Res>
    extends _$GardenStateCopyWithImpl<$Res, _$GardenStateImpl>
    implements _$$GardenStateImplCopyWith<$Res> {
  __$$GardenStateImplCopyWithImpl(
    _$GardenStateImpl _value,
    $Res Function(_$GardenStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GardenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? streak = null,
    Object? totalFlowers = null,
    Object? lastLogDate = freezed,
    Object? weather = null,
    Object? flowerCounts = null,
  }) {
    return _then(
      _$GardenStateImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        streak: null == streak
            ? _value.streak
            : streak // ignore: cast_nullable_to_non_nullable
                  as int,
        totalFlowers: null == totalFlowers
            ? _value.totalFlowers
            : totalFlowers // ignore: cast_nullable_to_non_nullable
                  as int,
        lastLogDate: freezed == lastLogDate
            ? _value.lastLogDate
            : lastLogDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        weather: null == weather
            ? _value.weather
            : weather // ignore: cast_nullable_to_non_nullable
                  as String,
        flowerCounts: null == flowerCounts
            ? _value._flowerCounts
            : flowerCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GardenStateImpl implements _GardenState {
  const _$GardenStateImpl({
    required this.userId,
    this.streak = 0,
    this.totalFlowers = 0,
    this.lastLogDate,
    this.weather = 'sunny',
    final Map<String, int> flowerCounts = const {},
  }) : _flowerCounts = flowerCounts;

  factory _$GardenStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GardenStateImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final int streak;
  @override
  @JsonKey()
  final int totalFlowers;
  @override
  final DateTime? lastLogDate;
  @override
  @JsonKey()
  final String weather;
  final Map<String, int> _flowerCounts;
  @override
  @JsonKey()
  Map<String, int> get flowerCounts {
    if (_flowerCounts is EqualUnmodifiableMapView) return _flowerCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_flowerCounts);
  }

  @override
  String toString() {
    return 'GardenState(userId: $userId, streak: $streak, totalFlowers: $totalFlowers, lastLogDate: $lastLogDate, weather: $weather, flowerCounts: $flowerCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GardenStateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.totalFlowers, totalFlowers) ||
                other.totalFlowers == totalFlowers) &&
            (identical(other.lastLogDate, lastLogDate) ||
                other.lastLogDate == lastLogDate) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            const DeepCollectionEquality().equals(
              other._flowerCounts,
              _flowerCounts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    streak,
    totalFlowers,
    lastLogDate,
    weather,
    const DeepCollectionEquality().hash(_flowerCounts),
  );

  /// Create a copy of GardenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      __$$GardenStateImplCopyWithImpl<_$GardenStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GardenStateImplToJson(this);
  }
}

abstract class _GardenState implements GardenState {
  const factory _GardenState({
    required final String userId,
    final int streak,
    final int totalFlowers,
    final DateTime? lastLogDate,
    final String weather,
    final Map<String, int> flowerCounts,
  }) = _$GardenStateImpl;

  factory _GardenState.fromJson(Map<String, dynamic> json) =
      _$GardenStateImpl.fromJson;

  @override
  String get userId;
  @override
  int get streak;
  @override
  int get totalFlowers;
  @override
  DateTime? get lastLogDate;
  @override
  String get weather;
  @override
  Map<String, int> get flowerCounts;

  /// Create a copy of GardenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GardenStateImplCopyWith<_$GardenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
