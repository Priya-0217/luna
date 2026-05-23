// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HydrationLogImpl _$$HydrationLogImplFromJson(Map<String, dynamic> json) =>
    _$HydrationLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amountMl: (json['amountMl'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      synced: json['synced'] as bool? ?? false,
    );

Map<String, dynamic> _$$HydrationLogImplToJson(_$HydrationLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amountMl': instance.amountMl,
      'timestamp': instance.timestamp.toIso8601String(),
      'synced': instance.synced,
    };
