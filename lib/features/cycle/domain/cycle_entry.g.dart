// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CycleEntryImpl _$$CycleEntryImplFromJson(Map<String, dynamic> json) =>
    _$CycleEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      cycleLength: (json['cycleLength'] as num?)?.toInt(),
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CycleEntryImplToJson(_$CycleEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'cycleLength': instance.cycleLength,
      'synced': instance.synced,
      'createdAt': instance.createdAt.toIso8601String(),
    };
