// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyLogImpl _$$DailyLogImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as String,
      flow: (json['flow'] as num).toInt(),
      symptoms: json['symptoms'] as String,
      notes: json['notes'] as String?,
      energyLevel: (json['energyLevel'] as num).toInt(),
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$DailyLogImplToJson(_$DailyLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'mood': instance.mood,
      'flow': instance.flow,
      'symptoms': instance.symptoms,
      'notes': instance.notes,
      'energyLevel': instance.energyLevel,
      'synced': instance.synced,
      'createdAt': instance.createdAt.toIso8601String(),
    };
