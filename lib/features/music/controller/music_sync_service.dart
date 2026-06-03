// lib/features/music/controller/music_sync_service.dart

import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/music_track.dart';

class MusicSyncService {
  final String coupleCode;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  MusicSyncService({required this.coupleCode}) {
    debugPrint('[MusicSyncService] init coupleCode=$coupleCode');
  }

  DatabaseReference get _sessionRef => _db.ref('musicSessions/$coupleCode');

  // ── Write: when local user acts ──────────────────────────────

  Future<void> writePlayEvent({
    required MusicTrack track,
    required double seekPositionMs,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      debugPrint(
        '[MusicSyncService] writePlayEvent track=${track.videoId} seek=$seekPositionMs',
      );
      await _sessionRef.update({
        'currentTrack': track.toJson(),
        'playback/isPlaying': true,
        'playback/startedAtMs': now,
        'playback/seekPositionMs': seekPositionMs,
        'playback/lastUpdatedMs': now,
      });
    } catch (e) {
      debugPrint('[MusicSyncService] writePlayEvent error: $e');
      rethrow;
    }
  }

  Future<void> writePauseEvent({required double seekPositionMs}) async {
    try {
      debugPrint('[MusicSyncService] writePauseEvent seek=$seekPositionMs');
      await _sessionRef.update({
        'playback/isPlaying': false,
        'playback/seekPositionMs': seekPositionMs,
        'playback/lastUpdatedMs': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      debugPrint('[MusicSyncService] writePauseEvent error: $e');
      rethrow;
    }
  }

  Future<void> writeSeekEvent({required double seekPositionMs}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    try {
      debugPrint('[MusicSyncService] writeSeekEvent seek=$seekPositionMs');
      await _sessionRef.update({
        'playback/seekPositionMs': seekPositionMs,
        'playback/startedAtMs': now,
        'playback/lastUpdatedMs': now,
      });
    } catch (e) {
      debugPrint('[MusicSyncService] writeSeekEvent error: $e');
      rethrow;
    }
  }

  Future<void> writeQueue(List<MusicTrack> queue) async {
    // Map list to index keyed map to store nicely in Realtime DB
    final queueMap = <String, dynamic>{};
    for (int i = 0; i < queue.length; i++) {
      queueMap[i.toString()] = queue[i].toJson();
    }
    // Overwrite the entire queue to match local queue state
    try {
      debugPrint('[MusicSyncService] writeQueue count=${queue.length}');
      await _sessionRef.child('queue').set(queueMap);
    } catch (e) {
      debugPrint('[MusicSyncService] writeQueue error: $e');
      rethrow;
    }
  }

  Future<void> clearSession() async {
    try {
      debugPrint('[MusicSyncService] clearSession');
      await _sessionRef.remove();
    } catch (e) {
      debugPrint('[MusicSyncService] clearSession error: $e');
      rethrow;
    }
  }

  // ── Read: listen for partner's actions ───────────────────────

  Stream<DatabaseEvent> get playbackStream =>
      _sessionRef.child('playback').onValue;

  Stream<DatabaseEvent> get trackStream =>
      _sessionRef.child('currentTrack').onValue;

  Stream<DatabaseEvent> get queueStream => _sessionRef.child('queue').onValue;

  // ── Sync calculation ─────────────────────────────────────────

  /// Call this when you receive a play event from Firebase.
  /// Returns the position (in ms) you should seek to RIGHT NOW
  /// to be in sync with the partner who started playback.
  double calculateSyncPosition({
    required double seekPositionMs,
    required int startedAtMs,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final drift = now - startedAtMs;
    if (kDebugMode) {
      debugPrint(
        '[MusicSyncService] calculateSyncPosition seek=$seekPositionMs startedAt=$startedAtMs drift=$drift',
      );
    }
    // If drift is positive, add it to seekPosition. If negative (clock mismatch), fallback to seekPosition.
    if (drift > 0 && drift < 300000) {
      // Limit drift compensation to 5 mins maximum to avoid weird seek errors
      return seekPositionMs + drift;
    }
    return seekPositionMs;
  }
}
