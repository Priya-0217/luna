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
      coupleId: json['coupleId'] as String?,
      isLinked: json['isLinked'] as bool? ?? false,
      cycleAverageLength: (json['cycleAverageLength'] as num?)?.toInt() ?? 28,
      periodAverageLength: (json['periodAverageLength'] as num?)?.toInt() ?? 5,
      isOnboarded: json['isOnboarded'] as bool? ?? false,
      role: json['role'] as String?,
      myLoveCode: json['myLoveCode'] as String?,
      partnerRole: json['partnerRole'] as String?,
      partnerDisplayName: json['partnerDisplayName'] as String?,
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'partnerUid': instance.partnerUid,
      'coupleId': instance.coupleId,
      'isLinked': instance.isLinked,
      'cycleAverageLength': instance.cycleAverageLength,
      'periodAverageLength': instance.periodAverageLength,
      'isOnboarded': instance.isOnboarded,
      'role': instance.role,
      'myLoveCode': instance.myLoveCode,
      'partnerRole': instance.partnerRole,
      'partnerDisplayName': instance.partnerDisplayName,
    };
