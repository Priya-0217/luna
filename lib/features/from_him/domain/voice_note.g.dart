// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VoiceNoteImpl _$$VoiceNoteImplFromJson(Map<String, dynamic> json) =>
    _$VoiceNoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      storageUrl: json['storageUrl'] as String,
      localPath: json['localPath'] as String?,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$VoiceNoteImplToJson(_$VoiceNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'storageUrl': instance.storageUrl,
      'localPath': instance.localPath,
      'durationSeconds': instance.durationSeconds,
      'createdAt': instance.createdAt.toIso8601String(),
    };
