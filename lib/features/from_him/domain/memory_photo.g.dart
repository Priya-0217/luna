// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemoryPhotoImpl _$$MemoryPhotoImplFromJson(Map<String, dynamic> json) =>
    _$MemoryPhotoImpl(
      id: json['id'] as String,
      caption: json['caption'] as String,
      storageUrl: json['storageUrl'] as String,
      localPath: json['localPath'] as String?,
      takenAt: DateTime.parse(json['takenAt'] as String),
    );

Map<String, dynamic> _$$MemoryPhotoImplToJson(_$MemoryPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'storageUrl': instance.storageUrl,
      'localPath': instance.localPath,
      'takenAt': instance.takenAt.toIso8601String(),
    };
