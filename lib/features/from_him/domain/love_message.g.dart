// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'love_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoveMessageImpl _$$LoveMessageImplFromJson(Map<String, dynamic> json) =>
    _$LoveMessageImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      triggerId: json['triggerId'] as String,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] == null
          ? null
          : DateTime.parse(json['unlockedAt'] as String),
      type: json['type'] as String? ?? 'letter',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$LoveMessageImplToJson(_$LoveMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'triggerId': instance.triggerId,
      'isUnlocked': instance.isUnlocked,
      'unlockedAt': instance.unlockedAt?.toIso8601String(),
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
    };
