// lib/features/music/models/music_state.dart

import 'package:flutter/foundation.dart';
import 'player_mode.dart';
import 'music_track.dart';

class MusicState {
  final MusicTrack? currentTrack;
  final bool isPlaying;
  final PlayerMode mode;
  final List<MusicTrack> queue;
  final bool isSyncing; // true while applying remote sync
  final bool isPartnerListening; // is partner also in session
  final double bubbleX;
  final double bubbleY;

  const MusicState({
    this.currentTrack,
    this.isPlaying = false,
    this.mode = PlayerMode.hidden,
    this.queue = const [],
    this.isSyncing = false,
    this.isPartnerListening = false,
    this.bubbleX = 20,
    this.bubbleY = 200,
  });

  MusicState copyWith({
    MusicTrack? currentTrack,
    bool? isPlaying,
    PlayerMode? mode,
    List<MusicTrack>? queue,
    bool? isSyncing,
    bool? isPartnerListening,
    double? bubbleX,
    double? bubbleY,
    bool clearTrack = false,
  }) {
    final nextTrack = clearTrack ? null : (currentTrack ?? this.currentTrack);
    final nextIsPlaying = isPlaying ?? this.isPlaying;
    final nextMode = mode ?? this.mode;
    final nextQueue = queue ?? this.queue;
    final nextIsSyncing = isSyncing ?? this.isSyncing;
    final nextIsPartnerListening =
        isPartnerListening ?? this.isPartnerListening;
    final nextBubbleX = bubbleX ?? this.bubbleX;
    final nextBubbleY = bubbleY ?? this.bubbleY;

    if (kDebugMode) {
      debugPrint(
        '[MusicState] copyWith track=${nextTrack?.videoId ?? "none"} '
        'isPlaying=$nextIsPlaying mode=$nextMode queue=${nextQueue.length} '
        'sync=$nextIsSyncing partner=$nextIsPartnerListening '
        'bubble=($nextBubbleX,$nextBubbleY)',
      );
    }

    return MusicState(
      currentTrack: nextTrack,
      isPlaying: nextIsPlaying,
      mode: nextMode,
      queue: nextQueue,
      isSyncing: nextIsSyncing,
      isPartnerListening: nextIsPartnerListening,
      bubbleX: nextBubbleX,
      bubbleY: nextBubbleY,
    );
  }

  @override
  String toString() {
    return 'MusicState(track=${currentTrack?.videoId ?? "none"}, '
        'isPlaying=$isPlaying, mode=$mode, queue=${queue.length}, '
        'sync=$isSyncing, partner=$isPartnerListening, '
        'bubble=($bubbleX,$bubbleY))';
  }
}
