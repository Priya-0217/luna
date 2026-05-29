// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PartnerMessage _$PartnerMessageFromJson(Map<String, dynamic> json) {
  return _PartnerMessage.fromJson(json);
}

/// @nodoc
mixin _$PartnerMessage {
  String get id => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get senderName => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get illustrationKey => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get replyToId => throw _privateConstructorUsedError;
  String? get replyToText => throw _privateConstructorUsedError;
  String? get replyToSenderName => throw _privateConstructorUsedError;
  String? get replyToIllustrationKey => throw _privateConstructorUsedError;
  Map<String, dynamic> get reactions => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  /// Serializes this PartnerMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartnerMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartnerMessageCopyWith<PartnerMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerMessageCopyWith<$Res> {
  factory $PartnerMessageCopyWith(
    PartnerMessage value,
    $Res Function(PartnerMessage) then,
  ) = _$PartnerMessageCopyWithImpl<$Res, PartnerMessage>;
  @useResult
  $Res call({
    String id,
    String senderId,
    String senderName,
    String? content,
    String? illustrationKey,
    DateTime timestamp,
    String? replyToId,
    String? replyToText,
    String? replyToSenderName,
    String? replyToIllustrationKey,
    Map<String, dynamic> reactions,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class _$PartnerMessageCopyWithImpl<$Res, $Val extends PartnerMessage>
    implements $PartnerMessageCopyWith<$Res> {
  _$PartnerMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartnerMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? content = freezed,
    Object? illustrationKey = freezed,
    Object? timestamp = null,
    Object? replyToId = freezed,
    Object? replyToText = freezed,
    Object? replyToSenderName = freezed,
    Object? replyToIllustrationKey = freezed,
    Object? reactions = null,
    Object? metadata = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderName: null == senderName
                ? _value.senderName
                : senderName // ignore: cast_nullable_to_non_nullable
                      as String,
            content: freezed == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String?,
            illustrationKey: freezed == illustrationKey
                ? _value.illustrationKey
                : illustrationKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            replyToId: freezed == replyToId
                ? _value.replyToId
                : replyToId // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToText: freezed == replyToText
                ? _value.replyToText
                : replyToText // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToSenderName: freezed == replyToSenderName
                ? _value.replyToSenderName
                : replyToSenderName // ignore: cast_nullable_to_non_nullable
                      as String?,
            replyToIllustrationKey: freezed == replyToIllustrationKey
                ? _value.replyToIllustrationKey
                : replyToIllustrationKey // ignore: cast_nullable_to_non_nullable
                      as String?,
            reactions: null == reactions
                ? _value.reactions
                : reactions // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            metadata: null == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PartnerMessageImplCopyWith<$Res>
    implements $PartnerMessageCopyWith<$Res> {
  factory _$$PartnerMessageImplCopyWith(
    _$PartnerMessageImpl value,
    $Res Function(_$PartnerMessageImpl) then,
  ) = __$$PartnerMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String senderId,
    String senderName,
    String? content,
    String? illustrationKey,
    DateTime timestamp,
    String? replyToId,
    String? replyToText,
    String? replyToSenderName,
    String? replyToIllustrationKey,
    Map<String, dynamic> reactions,
    Map<String, dynamic> metadata,
  });
}

/// @nodoc
class __$$PartnerMessageImplCopyWithImpl<$Res>
    extends _$PartnerMessageCopyWithImpl<$Res, _$PartnerMessageImpl>
    implements _$$PartnerMessageImplCopyWith<$Res> {
  __$$PartnerMessageImplCopyWithImpl(
    _$PartnerMessageImpl _value,
    $Res Function(_$PartnerMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PartnerMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? content = freezed,
    Object? illustrationKey = freezed,
    Object? timestamp = null,
    Object? replyToId = freezed,
    Object? replyToText = freezed,
    Object? replyToSenderName = freezed,
    Object? replyToIllustrationKey = freezed,
    Object? reactions = null,
    Object? metadata = null,
  }) {
    return _then(
      _$PartnerMessageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderName: null == senderName
            ? _value.senderName
            : senderName // ignore: cast_nullable_to_non_nullable
                  as String,
        content: freezed == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String?,
        illustrationKey: freezed == illustrationKey
            ? _value.illustrationKey
            : illustrationKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        replyToId: freezed == replyToId
            ? _value.replyToId
            : replyToId // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToText: freezed == replyToText
            ? _value.replyToText
            : replyToText // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToSenderName: freezed == replyToSenderName
            ? _value.replyToSenderName
            : replyToSenderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyToIllustrationKey: freezed == replyToIllustrationKey
            ? _value.replyToIllustrationKey
            : replyToIllustrationKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        reactions: null == reactions
            ? _value._reactions
            : reactions // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        metadata: null == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartnerMessageImpl extends _PartnerMessage {
  const _$PartnerMessageImpl({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.content,
    this.illustrationKey,
    required this.timestamp,
    this.replyToId,
    this.replyToText,
    this.replyToSenderName,
    this.replyToIllustrationKey,
    final Map<String, dynamic> reactions = const {},
    final Map<String, dynamic> metadata = const {},
  }) : _reactions = reactions,
       _metadata = metadata,
       super._();

  factory _$PartnerMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartnerMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String? content;
  @override
  final String? illustrationKey;
  @override
  final DateTime timestamp;
  @override
  final String? replyToId;
  @override
  final String? replyToText;
  @override
  final String? replyToSenderName;
  @override
  final String? replyToIllustrationKey;
  final Map<String, dynamic> _reactions;
  @override
  @JsonKey()
  Map<String, dynamic> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'PartnerMessage(id: $id, senderId: $senderId, senderName: $senderName, content: $content, illustrationKey: $illustrationKey, timestamp: $timestamp, replyToId: $replyToId, replyToText: $replyToText, replyToSenderName: $replyToSenderName, replyToIllustrationKey: $replyToIllustrationKey, reactions: $reactions, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnerMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.illustrationKey, illustrationKey) ||
                other.illustrationKey == illustrationKey) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.replyToId, replyToId) ||
                other.replyToId == replyToId) &&
            (identical(other.replyToText, replyToText) ||
                other.replyToText == replyToText) &&
            (identical(other.replyToSenderName, replyToSenderName) ||
                other.replyToSenderName == replyToSenderName) &&
            (identical(other.replyToIllustrationKey, replyToIllustrationKey) ||
                other.replyToIllustrationKey == replyToIllustrationKey) &&
            const DeepCollectionEquality().equals(
              other._reactions,
              _reactions,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    senderId,
    senderName,
    content,
    illustrationKey,
    timestamp,
    replyToId,
    replyToText,
    replyToSenderName,
    replyToIllustrationKey,
    const DeepCollectionEquality().hash(_reactions),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PartnerMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnerMessageImplCopyWith<_$PartnerMessageImpl> get copyWith =>
      __$$PartnerMessageImplCopyWithImpl<_$PartnerMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PartnerMessageImplToJson(this);
  }
}

abstract class _PartnerMessage extends PartnerMessage {
  const factory _PartnerMessage({
    required final String id,
    required final String senderId,
    required final String senderName,
    final String? content,
    final String? illustrationKey,
    required final DateTime timestamp,
    final String? replyToId,
    final String? replyToText,
    final String? replyToSenderName,
    final String? replyToIllustrationKey,
    final Map<String, dynamic> reactions,
    final Map<String, dynamic> metadata,
  }) = _$PartnerMessageImpl;
  const _PartnerMessage._() : super._();

  factory _PartnerMessage.fromJson(Map<String, dynamic> json) =
      _$PartnerMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get senderId;
  @override
  String get senderName;
  @override
  String? get content;
  @override
  String? get illustrationKey;
  @override
  DateTime get timestamp;
  @override
  String? get replyToId;
  @override
  String? get replyToText;
  @override
  String? get replyToSenderName;
  @override
  String? get replyToIllustrationKey;
  @override
  Map<String, dynamic> get reactions;
  @override
  Map<String, dynamic> get metadata;

  /// Create a copy of PartnerMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartnerMessageImplCopyWith<_$PartnerMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
