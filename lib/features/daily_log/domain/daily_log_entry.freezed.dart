// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DailyLogEntry _$DailyLogEntryFromJson(Map<String, dynamic> json) {
  return _DailyLogEntry.fromJson(json);
}

/// @nodoc
mixin _$DailyLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get mood => throw _privateConstructorUsedError;
  int get flowLevel => throw _privateConstructorUsedError;
  List<String> get symptoms => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int get energyLevel => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;

  /// Serializes this DailyLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyLogEntryCopyWith<DailyLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLogEntryCopyWith<$Res> {
  factory $DailyLogEntryCopyWith(
    DailyLogEntry value,
    $Res Function(DailyLogEntry) then,
  ) = _$DailyLogEntryCopyWithImpl<$Res, DailyLogEntry>;
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime date,
    String mood,
    int flowLevel,
    List<String> symptoms,
    String? notes,
    int energyLevel,
    bool synced,
  });
}

/// @nodoc
class _$DailyLogEntryCopyWithImpl<$Res, $Val extends DailyLogEntry>
    implements $DailyLogEntryCopyWith<$Res> {
  _$DailyLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mood = null,
    Object? flowLevel = null,
    Object? symptoms = null,
    Object? notes = freezed,
    Object? energyLevel = null,
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
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            mood: null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as String,
            flowLevel: null == flowLevel
                ? _value.flowLevel
                : flowLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            symptoms: null == symptoms
                ? _value.symptoms
                : symptoms // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            energyLevel: null == energyLevel
                ? _value.energyLevel
                : energyLevel // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$DailyLogEntryImplCopyWith<$Res>
    implements $DailyLogEntryCopyWith<$Res> {
  factory _$$DailyLogEntryImplCopyWith(
    _$DailyLogEntryImpl value,
    $Res Function(_$DailyLogEntryImpl) then,
  ) = __$$DailyLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    DateTime date,
    String mood,
    int flowLevel,
    List<String> symptoms,
    String? notes,
    int energyLevel,
    bool synced,
  });
}

/// @nodoc
class __$$DailyLogEntryImplCopyWithImpl<$Res>
    extends _$DailyLogEntryCopyWithImpl<$Res, _$DailyLogEntryImpl>
    implements _$$DailyLogEntryImplCopyWith<$Res> {
  __$$DailyLogEntryImplCopyWithImpl(
    _$DailyLogEntryImpl _value,
    $Res Function(_$DailyLogEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mood = null,
    Object? flowLevel = null,
    Object? symptoms = null,
    Object? notes = freezed,
    Object? energyLevel = null,
    Object? synced = null,
  }) {
    return _then(
      _$DailyLogEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        mood: null == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as String,
        flowLevel: null == flowLevel
            ? _value.flowLevel
            : flowLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        symptoms: null == symptoms
            ? _value._symptoms
            : symptoms // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        energyLevel: null == energyLevel
            ? _value.energyLevel
            : energyLevel // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$DailyLogEntryImpl implements _DailyLogEntry {
  const _$DailyLogEntryImpl({
    required this.id,
    required this.userId,
    required this.date,
    required this.mood,
    this.flowLevel = 0,
    final List<String> symptoms = const [],
    this.notes,
    this.energyLevel = 3,
    this.synced = false,
  }) : _symptoms = symptoms;

  factory _$DailyLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime date;
  @override
  final String mood;
  @override
  @JsonKey()
  final int flowLevel;
  final List<String> _symptoms;
  @override
  @JsonKey()
  List<String> get symptoms {
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_symptoms);
  }

  @override
  final String? notes;
  @override
  @JsonKey()
  final int energyLevel;
  @override
  @JsonKey()
  final bool synced;

  @override
  String toString() {
    return 'DailyLogEntry(id: $id, userId: $userId, date: $date, mood: $mood, flowLevel: $flowLevel, symptoms: $symptoms, notes: $notes, energyLevel: $energyLevel, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.flowLevel, flowLevel) ||
                other.flowLevel == flowLevel) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.energyLevel, energyLevel) ||
                other.energyLevel == energyLevel) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    date,
    mood,
    flowLevel,
    const DeepCollectionEquality().hash(_symptoms),
    notes,
    energyLevel,
    synced,
  );

  /// Create a copy of DailyLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyLogEntryImplCopyWith<_$DailyLogEntryImpl> get copyWith =>
      __$$DailyLogEntryImplCopyWithImpl<_$DailyLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyLogEntryImplToJson(this);
  }
}

abstract class _DailyLogEntry implements DailyLogEntry {
  const factory _DailyLogEntry({
    required final String id,
    required final String userId,
    required final DateTime date,
    required final String mood,
    final int flowLevel,
    final List<String> symptoms,
    final String? notes,
    final int energyLevel,
    final bool synced,
  }) = _$DailyLogEntryImpl;

  factory _DailyLogEntry.fromJson(Map<String, dynamic> json) =
      _$DailyLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  DateTime get date;
  @override
  String get mood;
  @override
  int get flowLevel;
  @override
  List<String> get symptoms;
  @override
  String? get notes;
  @override
  int get energyLevel;
  @override
  bool get synced;

  /// Create a copy of DailyLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyLogEntryImplCopyWith<_$DailyLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
