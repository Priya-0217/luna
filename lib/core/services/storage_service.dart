import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(StorageServiceRef ref) =>
    StorageService(FirebaseStorage.instance);

class StorageService {
  StorageService(this._storage);

  final FirebaseStorage _storage;

  // ── Voice Notes ──────────────────────────────────────────────────────────────
  Future<String> uploadVoiceNote({
    required String userId,
    required String noteId,
    required File file,
    void Function(double progress)? onProgress,
  }) async {
    final ref = _storage.ref('fromHim/$userId/voiceNotes/$noteId.m4a');
    final task = ref.putFile(file);
    task.snapshotEvents.listen((snap) {
      if (snap.totalBytes > 0) {
        onProgress?.call(snap.bytesTransferred / snap.totalBytes);
      }
    });
    await task;
    return await ref.getDownloadURL();
  }

  // ── Photos ───────────────────────────────────────────────────────────────────
  Future<String> uploadMemoryPhoto({
    required String userId,
    required String photoId,
    required File file,
    void Function(double progress)? onProgress,
  }) async {
    final ref = _storage.ref('fromHim/$userId/photos/$photoId.jpg');
    final task = ref.putFile(file);
    task.snapshotEvents.listen((snap) {
      if (snap.totalBytes > 0) {
        onProgress?.call(snap.bytesTransferred / snap.totalBytes);
      }
    });
    await task;
    return await ref.getDownloadURL();
  }

  // ── Delete ───────────────────────────────────────────────────────────────────
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (_) {
      // File may already be deleted; ignore
    }
  }

  // ── Download (cache locally) ─────────────────────────────────────────────────
  Future<void> downloadToFile({
    required String downloadUrl,
    required File destination,
  }) async {
    final ref = _storage.refFromURL(downloadUrl);
    await ref.writeToFile(destination);
  }
}
