// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyLogEntryImpl _$$DailyLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$DailyLogEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as String,
      flowLevel: (json['flowLevel'] as num?)?.toInt() ?? 0,
      symptoms:
          (json['symptoms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      energyLevel: (json['energyLevel'] as num?)?.toInt() ?? 3,
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$DailyLogEntryImplToJson(_$DailyLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'mood': instance.mood,
      'flowLevel': instance.flowLevel,
      'symptoms': instance.symptoms,
      'notes': instance.notes,
      'energyLevel': instance.energyLevel,
      'synced': instance.synced,
    };
