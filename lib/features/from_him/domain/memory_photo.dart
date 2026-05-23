import 'package:freezed_annotation/freezed_annotation.dart';

part 'memory_photo.freezed.dart';
part 'memory_photo.g.dart';

@freezed
class MemoryPhoto with _$MemoryPhoto {
  const factory MemoryPhoto({
    required String id,
    required String caption,
    required String storageUrl,
    String? localPath,
    required DateTime takenAt,
  }) = _MemoryPhoto;

  factory MemoryPhoto.fromJson(Map<String, dynamic> json) =>
      _$MemoryPhotoFromJson(json);
}
