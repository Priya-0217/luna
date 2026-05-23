// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      partnerUid: json['partnerUid'] as String?,
      cycleAverageLength: (json['cycleAverageLength'] as num?)?.toInt() ?? 28,
      periodAverageLength: (json['periodAverageLength'] as num?)?.toInt() ?? 5,
      isOnboarded: json['isOnboarded'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'partnerUid': instance.partnerUid,
      'cycleAverageLength': instance.cycleAverageLength,
      'periodAverageLength': instance.periodAverageLength,
      'isOnboarded': instance.isOnboarded,
    };
