// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      userId: json['userId'] as String,
      cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 28,
      periodLength: (json['periodLength'] as num?)?.toInt() ?? 5,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      disguiseMode: json['disguiseMode'] as bool? ?? false,
      reminderTime: json['reminderTime'] as String? ?? '08:00',
      lastSynced: json['lastSynced'] == null
          ? null
          : DateTime.parse(json['lastSynced'] as String),
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'cycleLength': instance.cycleLength,
      'periodLength': instance.periodLength,
      'notificationsEnabled': instance.notificationsEnabled,
      'disguiseMode': instance.disguiseMode,
      'reminderTime': instance.reminderTime,
      'lastSynced': instance.lastSynced?.toIso8601String(),
    };
