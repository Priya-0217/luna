// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SleepLogImpl _$$SleepLogImplFromJson(Map<String, dynamic> json) =>
    _$SleepLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      hours: (json['hours'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      quality: (json['quality'] as num?)?.toInt() ?? 3,
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$SleepLogImplToJson(_$SleepLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'hours': instance.hours,
      'date': instance.date.toIso8601String(),
      'quality': instance.quality,
      'synced': instance.synced,
    };
