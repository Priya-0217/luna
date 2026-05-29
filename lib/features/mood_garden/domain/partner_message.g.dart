// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartnerMessageImpl _$$PartnerMessageImplFromJson(Map<String, dynamic> json) =>
    _$PartnerMessageImpl(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      content: json['content'] as String?,
      illustrationKey: json['illustrationKey'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      replyToId: json['replyToId'] as String?,
      replyToText: json['replyToText'] as String?,
      replyToSenderName: json['replyToSenderName'] as String?,
      replyToIllustrationKey: json['replyToIllustrationKey'] as String?,
      reactions: json['reactions'] as Map<String, dynamic>? ?? const {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PartnerMessageImplToJson(
  _$PartnerMessageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'senderId': instance.senderId,
  'senderName': instance.senderName,
  'content': instance.content,
  'illustrationKey': instance.illustrationKey,
  'timestamp': instance.timestamp.toIso8601String(),
  'replyToId': instance.replyToId,
  'replyToText': instance.replyToText,
  'replyToSenderName': instance.replyToSenderName,
  'replyToIllustrationKey': instance.replyToIllustrationKey,
  'reactions': instance.reactions,
  'metadata': instance.metadata,
};
