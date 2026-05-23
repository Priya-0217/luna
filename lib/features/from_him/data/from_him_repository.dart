import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/from_him/domain/love_message.dart';
import 'package:her/features/from_him/domain/voice_note.dart';
import 'package:her/features/from_him/domain/memory_photo.dart';

part 'from_him_repository.g.dart';

@riverpod
FromHimRepository fromHimRepository(FromHimRepositoryRef ref) =>
    FromHimRepository(ref.watch(firestoreServiceProvider));

class FromHimRepository {
  FromHimRepository(this._firestore);

  final FirestoreService _firestore;

  static const _msgCacheKey = 'from_him_messages';
  static const _voiceCacheKey = 'from_him_voice_notes';
  static const _photoCacheKey = 'from_him_photos';

  // ── Messages ────────────────────────────────────────────────────────────────

  Future<List<LoveMessage>> getMessages({bool forceRemote = false}) async {
    final box = Hive.box('settings');
    if (!forceRemote) {
      final cached = box.get(_msgCacheKey);
      if (cached != null) {
        final list = (cached as List).cast<Map>();
        return list.map(_messageFromMap).toList();
      }
    }

    try {
      final raw = await _firestore.getFromHimMessages();
      await box.put(_msgCacheKey, raw);
      return raw.map(_messageFromMap).toList();
    } catch (_) {
      final cached = box.get(_msgCacheKey);
      if (cached != null) {
        return (cached as List).cast<Map>().map(_messageFromMap).toList();
      }
      return [];
    }
  }

  Future<void> unlockMessage(String messageId) async {
    await _firestore.markMessageUnlocked(messageId);
    // Invalidate cache so next load gets updated state
    Hive.box('settings').delete(_msgCacheKey);
  }

  // ── Voice Notes ─────────────────────────────────────────────────────────────

  Future<List<VoiceNote>> getVoiceNotes({bool forceRemote = false}) async {
    final box = Hive.box('settings');
    if (!forceRemote) {
      final cached = box.get(_voiceCacheKey);
      if (cached != null) {
        return (cached as List).cast<Map>().map(_voiceFromMap).toList();
      }
    }
    try {
      final raw = await _firestore.getVoiceNotes();
      await box.put(_voiceCacheKey, raw);
      return raw.map(_voiceFromMap).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Photos ──────────────────────────────────────────────────────────────────

  Future<List<MemoryPhoto>> getPhotos({bool forceRemote = false}) async {
    final box = Hive.box('settings');
    if (!forceRemote) {
      final cached = box.get(_photoCacheKey);
      if (cached != null) {
        return (cached as List).cast<Map>().map(_photoFromMap).toList();
      }
    }
    try {
      final raw = await _firestore.getMemoryPhotos();
      await box.put(_photoCacheKey, raw);
      return raw.map(_photoFromMap).toList();
    } catch (_) {
      return [];
    }
  }

  /// Force a full refresh from Firestore.
  Future<void> refreshAll() async {
    final box = Hive.box('settings');
    box.deleteAll([_msgCacheKey, _voiceCacheKey, _photoCacheKey]);
    await Future.wait([
      getMessages(forceRemote: true),
      getVoiceNotes(forceRemote: true),
      getPhotos(forceRemote: true),
    ]);
  }

  // ── Converters ──────────────────────────────────────────────────────────────

  LoveMessage _messageFromMap(Map m) => LoveMessage(
        id: m['id'] as String? ?? '',
        title: m['title'] as String? ?? '',
        body: m['body'] as String? ?? '',
        triggerId: m['triggerId'] as String? ?? 'general',
        isUnlocked: m['isUnlocked'] as bool? ?? false,
        unlockedAt: m['unlockedAt'] != null
            ? FirestoreService.tsToDate(m['unlockedAt'])
            : null,
        type: m['type'] as String? ?? 'letter',
        createdAt: m['createdAt'] != null
            ? FirestoreService.tsToDate(m['createdAt'])
            : DateTime.now(),
      );

  VoiceNote _voiceFromMap(Map m) => VoiceNote(
        id: m['id'] as String? ?? '',
        title: m['title'] as String? ?? 'Voice Note',
        storageUrl: m['storageUrl'] as String? ?? '',
        durationSeconds: m['durationSeconds'] as int? ?? 0,
        createdAt: m['createdAt'] != null
            ? FirestoreService.tsToDate(m['createdAt'])
            : DateTime.now(),
      );

  MemoryPhoto _photoFromMap(Map m) => MemoryPhoto(
        id: m['id'] as String? ?? '',
        caption: m['caption'] as String? ?? '',
        storageUrl: m['storageUrl'] as String? ?? '',
        takenAt: m['takenAt'] != null
            ? FirestoreService.tsToDate(m['takenAt'])
            : DateTime.now(),
      );
}
