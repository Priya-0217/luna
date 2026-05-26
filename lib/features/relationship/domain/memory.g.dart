// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemoryImpl _$$MemoryImplFromJson(Map<String, dynamic> json) => _$MemoryImpl(
  id: json['id'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String,
  addedBy: json['addedBy'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  reactions:
      (json['reactions'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$$MemoryImplToJson(_$MemoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'addedBy': instance.addedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'reactions': instance.reactions,
    };
