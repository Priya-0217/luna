// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garden_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GardenStateImpl _$$GardenStateImplFromJson(Map<String, dynamic> json) =>
    _$GardenStateImpl(
      userId: json['userId'] as String,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      totalFlowers: (json['totalFlowers'] as num?)?.toInt() ?? 0,
      lastLogDate: json['lastLogDate'] == null
          ? null
          : DateTime.parse(json['lastLogDate'] as String),
      weather: json['weather'] as String? ?? 'sunny',
      flowerCounts:
          (json['flowerCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$GardenStateImplToJson(_$GardenStateImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'streak': instance.streak,
      'totalFlowers': instance.totalFlowers,
      'lastLogDate': instance.lastLogDate?.toIso8601String(),
      'weather': instance.weather,
      'flowerCounts': instance.flowerCounts,
    };
