// lib/features/music/controller/music_controller.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/music_track.dart';
import '../models/music_state.dart';
import '../models/player_mode.dart';
import 'music_sync_service.dart';

// Provider definition
final musicControllerProvider =
    StateNotifierProvider<MusicController, MusicState>((ref) {
      return MusicController();
    });

// Global YouTubePlayerController provider (so it survives rebuilds)
final youtubePlayerControllerProvider = Provider<YoutubePlayerController>((
  ref,
) {
  final controller = YoutubePlayerController(
    // Non-empty initial id to ensure the player initializes reliably.
    initialVideoId: 'M7lc1UVf-VE',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      hideControls: true, // We use custom controls
      disableDragSeek: true, // We handle seek ourselves
      enableCaption: false,
      hideThumbnail: true,
      loop: false,
    ),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

class MusicController extends StateNotifier<MusicState> {
  MusicController() : super(const MusicState());

  MusicSyncService? _syncService;
  late YoutubePlayerController _ytController;
  StreamSubscription? _playbackSub;
  StreamSubscription? _trackSub;
  StreamSubscription? _queueSub;
  Timer? _seekDebounce;
  bool _isApplyingRemoteSync = false; // prevents loop feedback
  bool _isPlayerReady = false;
  bool _isInitialized = false;
  String? _coupleId;
  MusicTrack? _pendingTrack;
  double _pendingSeekMs = 0;

  void initialize({
    required String? coupleId,
    required YoutubePlayerController ytController,
  }) {
    if (_isInitialized &&
        identical(_ytController, ytController) &&
        _coupleId == coupleId) {
      debugPrint('[MusicController] initialize skipped (already initialized)');
      return;
    }

    _ytController = ytController;
    _coupleId = coupleId;
    _isInitialized = true;
    _cancelSubscriptions();

    if (coupleId == null || coupleId.isEmpty) {
      // Offline/unlinked mode
      _syncService = null;
      debugPrint('[MusicController] initialize without coupleId');
      return;
    }

    _syncService = MusicSyncService(coupleCode: coupleId);
    debugPrint('[MusicController] initialize with coupleId=$coupleId');
    _listenToFirebase();
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _seekDebounce?.cancel();
    super.dispose();
  }

  void _cancelSubscriptions() {
    _playbackSub?.cancel();
    _trackSub?.cancel();
    _queueSub?.cancel();
    _playbackSub = null;
    _trackSub = null;
    _queueSub = null;
  }

  void onPlayerReady() {
    _isPlayerReady = true;
    debugPrint('[MusicController] player ready');

    if (_pendingTrack != null) {
      final track = _pendingTrack!;
      final seekMs = _pendingSeekMs;
      _pendingTrack = null;
      _pendingSeekMs = 0;
      debugPrint('[MusicController] play pending track=${track.videoId}');
      _startPlayback(track, seekPositionMs: seekMs);
    }
  }

  // ── Firebase Listeners ────────────────────────────────────────

  void _listenToFirebase() {
    if (_syncService == null) return;

    // Listen to track changes
    _trackSub = _syncService!.trackStream.listen((event) {
      if (event.snapshot.value == null) {
        debugPrint('[MusicController] remote track cleared');
        state = state.copyWith(clearTrack: true);
        return;
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final track = MusicTrack.fromJson(data);

      if (track.videoId != state.currentTrack?.videoId) {
        _isApplyingRemoteSync = true;
        debugPrint('[MusicController] remote track=${track.videoId}');
        _ytController.load(track.videoId);
        state = state.copyWith(currentTrack: track);
        _isApplyingRemoteSync = false;
      }
    });

    // Listen to playback state
    _playbackSub = _syncService!.playbackStream.listen((event) {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      final isPlaying = data['isPlaying'] as bool? ?? false;
      final seekPositionMs = (data['seekPositionMs'] as num? ?? 0).toDouble();
      final startedAtMs = data['startedAtMs'] as int? ?? 0;

      debugPrint(
        '[MusicController] remote playback isPlaying=$isPlaying '
        'seekMs=$seekPositionMs startedAtMs=$startedAtMs',
      );

      _isApplyingRemoteSync = true;

      if (isPlaying) {
        final syncPos = _syncService!.calculateSyncPosition(
          seekPositionMs: seekPositionMs,
          startedAtMs: startedAtMs,
        );

        final localPos = _ytController.value.position.inMilliseconds.toDouble();
        // Only seek if we are drifted by more than 1.5 seconds to avoid micro-stuttering
        if ((syncPos - localPos).abs() > 1500) {
          _ytController.seekTo(Duration(milliseconds: syncPos.toInt()));
        }

        _ytController.play();
        state = state.copyWith(isPlaying: true);
      } else {
        _ytController.seekTo(Duration(milliseconds: seekPositionMs.toInt()));
        _ytController.pause();
        state = state.copyWith(isPlaying: false);
      }

      _isApplyingRemoteSync = false;
    });

    // Listen to queue
    _queueSub = _syncService!.queueStream.listen((event) {
      if (event.snapshot.value == null) {
        state = state.copyWith(queue: const []);
        return;
      }
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final queue = <MusicTrack>[];

      // Sort keys (0, 1, 2...) to preserve order
      final sortedKeys = data.keys.toList()
        ..sort(
          (a, b) => int.parse(a.toString()).compareTo(int.parse(b.toString())),
        );
      for (final key in sortedKeys) {
        final val = Map<String, dynamic>.from(data[key] as Map);
        queue.add(MusicTrack.fromJson(val));
      }
      debugPrint('[MusicController] remote queue count=${queue.length}');
      state = state.copyWith(queue: queue);
    });
  }

  // ── Local Actions (writes to Firebase which triggers listeners) ────

  Future<void> playSong(MusicTrack track) async {
    if (track.videoId.isEmpty) {
      debugPrint('[MusicController] playSong ignored (empty videoId)');
      return;
    }

    debugPrint('[MusicController] playSong videoId=${track.videoId}');

    if (!_isPlayerReady && !_ytController.value.isReady) {
      _pendingTrack = track;
      _pendingSeekMs = 0;
      state = state.copyWith(
        currentTrack: track,
        isPlaying: false,
        mode: state.mode == PlayerMode.hidden ? PlayerMode.miniBar : state.mode,
      );
      debugPrint(
        '[MusicController] player not ready, queue play for ${track.videoId}',
      );
      return;
    }

    await _startPlayback(track, seekPositionMs: 0);
  }

  Future<void> _startPlayback(
    MusicTrack track, {
    required double seekPositionMs,
  }) async {
    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      mode: state.mode == PlayerMode.hidden ? PlayerMode.miniBar : state.mode,
    );
    debugPrint('[MusicController] start playback ${track.videoId}');
    _ytController.load(track.videoId);
    if (seekPositionMs > 0) {
      _ytController.seekTo(Duration(milliseconds: seekPositionMs.toInt()));
    }
    _ytController.play();

    if (_syncService != null && !_isApplyingRemoteSync) {
      await _syncService!.writePlayEvent(
        track: track,
        seekPositionMs: seekPositionMs,
      );
    }
  }

  Future<void> togglePlay() async {
    if (state.currentTrack == null) {
      debugPrint('[MusicController] togglePlay ignored (no track)');
      return;
    }
    if (!_isPlayerReady && !_ytController.value.isReady) {
      debugPrint('[MusicController] togglePlay ignored (player not ready)');
      return;
    }

    final currentMs = _ytController.value.position.inMilliseconds.toDouble();
    if (state.isPlaying) {
      _ytController.pause();
      state = state.copyWith(isPlaying: false);
      if (_syncService != null && !_isApplyingRemoteSync) {
        await _syncService!.writePauseEvent(seekPositionMs: currentMs);
      }
    } else {
      _ytController.play();
      state = state.copyWith(isPlaying: true);
      if (_syncService != null && !_isApplyingRemoteSync) {
        await _syncService!.writePlayEvent(
          track: state.currentTrack!,
          seekPositionMs: currentMs,
        );
      }
    }
  }

  void seekTo(double ms) {
    debugPrint('[MusicController] seekTo ms=$ms remote=$_isApplyingRemoteSync');
    _ytController.seekTo(Duration(milliseconds: ms.toInt()));

    if (_isApplyingRemoteSync) return; // prevents feedback loop

    // Debounce database write by 500ms
    _seekDebounce?.cancel();
    _seekDebounce = Timer(const Duration(milliseconds: 500), () {
      if (_syncService != null) {
        _syncService!.writeSeekEvent(seekPositionMs: ms);
      }
    });
  }

  Future<void> skipNext() async {
    if (state.queue.isEmpty) {
      // No songs in queue, just pause or stop
      debugPrint('[MusicController] skipNext ignored (queue empty)');
      return;
    }
    final next = state.queue.first;
    final newQueue = state.queue.sublist(1);

    state = state.copyWith(queue: newQueue);

    if (_syncService != null) {
      await _syncService!.writeQueue(newQueue);
      await playSong(next);
    } else {
      await playSong(next);
    }
  }

  Future<void> addToQueue(MusicTrack track) async {
    final newQueue = [...state.queue, track];
    state = state.copyWith(queue: newQueue);
    debugPrint('[MusicController] addToQueue ${track.videoId}');

    if (_syncService != null) {
      await _syncService!.writeQueue(newQueue);
    }
  }

  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= state.queue.length) return;
    final newQueue = List<MusicTrack>.from(state.queue)..removeAt(index);
    state = state.copyWith(queue: newQueue);
    debugPrint('[MusicController] removeFromQueue index=$index');

    if (_syncService != null) {
      await _syncService!.writeQueue(newQueue);
    }
  }

  Future<void> clearQueue() async {
    state = state.copyWith(queue: const []);
    debugPrint('[MusicController] clearQueue');
    if (_syncService != null) {
      await _syncService!.writeQueue(const []);
    }
  }

  Future<void> endSession() async {
    _ytController.pause();
    state = const MusicState();
    debugPrint('[MusicController] endSession');
    if (_syncService != null) {
      await _syncService!.clearSession();
    }
  }

  // ── Mode Control (UI only, no Firebase sync) ──────────────────

  void setMode(PlayerMode mode) {
    logPlayerMode(
      source: 'MusicController',
      mode: mode,
      note: 'from ${state.mode}',
    );
    state = state.copyWith(mode: mode);
  }

  void moveBubble(double x, double y) {
    debugPrint('[MusicController] moveBubble x=$x y=$y');
    state = state.copyWith(bubbleX: x, bubbleY: y);
  }
}
