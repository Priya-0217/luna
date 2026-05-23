import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_note.freezed.dart';
part 'voice_note.g.dart';

@freezed
class VoiceNote with _$VoiceNote {
  const factory VoiceNote({
    required String id,
    required String title,
    required String storageUrl,
    String? localPath,
    @Default(0) int durationSeconds,
    required DateTime createdAt,
  }) = _VoiceNote;

  factory VoiceNote.fromJson(Map<String, dynamic> json) =>
      _$VoiceNoteFromJson(json);
}
