// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BucketItemImpl _$$BucketItemImplFromJson(Map<String, dynamic> json) =>
    _$BucketItemImpl(
      id: json['id'] as String?,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      addedBy: json['addedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$BucketItemImplToJson(_$BucketItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
      'addedBy': instance.addedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
