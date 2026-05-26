// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'love_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoveCodeImpl _$$LoveCodeImplFromJson(Map<String, dynamic> json) =>
    _$LoveCodeImpl(
      code: json['code'] as String,
      ownerUid: json['ownerUid'] as String,
      ownerRole: json['ownerRole'] as String,
      ownerName: json['ownerName'] as String,
      linkedUid: json['linkedUid'] as String?,
      linkedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['linkedAt'],
        const TimestampConverter().fromJson,
      ),
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      expiresAt: const TimestampConverter().fromJson(
        json['expiresAt'] as Timestamp,
      ),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$LoveCodeImplToJson(_$LoveCodeImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'ownerUid': instance.ownerUid,
      'ownerRole': instance.ownerRole,
      'ownerName': instance.ownerName,
      'linkedUid': instance.linkedUid,
      'linkedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.linkedAt,
        const TimestampConverter().toJson,
      ),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
      'isActive': instance.isActive,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
