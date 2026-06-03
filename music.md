# 🎵 Couple Music Sync Feature — Complete Implementation Guide

> **For AI Agent**: This document contains the complete specification, architecture, tech stack, Firebase schema, and implementation plan for adding a synchronized music listening feature to an existing Flutter couple app. Read this fully before writing any code. Do not skip any section.

---

## 1. Project Context

### What is this app?
A Flutter-based couple app where:
- Two partners (girlfriend + boyfriend) are connected via a **unique couple code**
- They share chats, hugs, messages, care features
- Backend: **Firebase** (Firestore + Realtime Database + Auth)
- State management: **Riverpod**

### What are we building?
A **"Listen Together"** feature where both partners can:
- Search YouTube songs
- Play the same song at the exact same position in real-time
- Control playback from **any screen** in the app
- See a mini player, bubble player, popup, or full screen player — all modes switchable without interrupting playback

---

## 2. Core Requirements

### 2.1 Functional Requirements
| # | Requirement |
|---|---|
| R1 | Both partners hear the same song at the same position (synced) |
| R2 | Either partner can play, pause, seek, skip |
| R3 | Music player must be controllable from ANY screen in the app |
| R4 | Player should support 4 modes: Mini Bar, Bubble, Popup, Full Screen |
| R5 | Switching between modes must NOT interrupt playback |
| R6 | Navigating between screens must NOT interrupt playback |
| R7 | Song shared in chat should have a "Play Together" button |
| R8 | Queue management: add, remove, reorder songs |
| R9 | When one partner opens the app mid-song, they auto-seek to the correct position |

### 2.2 Technical Constraints
| # | Constraint |
|---|---|
| C1 | NO paid third-party services |
| C2 | NO self-hosted backend |
| C3 | Only use official, legally compliant YouTube packages |
| C4 | No `youtube_explode_dart` (violates YouTube ToS) |
| C5 | Firebase free tier must be sufficient |
| C6 | Flutter only (no native platform code unless absolutely necessary) |

---

## 3. Tech Stack

### 3.1 Flutter Packages

```yaml
dependencies:
  # YouTube Playback (Official iframe embed — legally compliant)
  youtube_player_flutter: ^9.0.3

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Firebase
  firebase_core: ^3.1.0
  firebase_database: ^11.1.0      # Realtime DB for sync (low latency)
  cloud_firestore: ^5.1.0         # Firestore for queue/history
  firebase_auth: ^5.1.0

  # HTTP (YouTube Data API v3 calls)
  http: ^1.2.1
  
  # UI
  cached_network_image: ^3.3.1    # thumbnail caching

dev_dependencies:
  riverpod_generator: ^2.4.0
  build_runner: ^2.4.9
```

### 3.2 External APIs
| API | Purpose | Cost |
|---|---|---|
| **YouTube Data API v3** | Search songs, get video metadata | Free (10,000 units/day) |
| **Firebase Realtime Database** | Real-time playback sync | Free tier |
| **Firebase Firestore** | Queue storage, history | Free tier |

> **YouTube Data API v3 Setup**: Go to [Google Cloud Console](https://console.cloud.google.com) → Enable YouTube Data API v3 → Create API Key → Restrict to your app's bundle ID.

### 3.3 Why These Choices?

**`youtube_player_flutter` (iframe)**
- Uses YouTube's official iframe embed
- Allowed by YouTube ToS
- Works on Android and iOS
- Audio continues even when video is hidden via `Offstage`

**Firebase Realtime Database (not Firestore) for sync**
- Latency: 50–100ms vs Firestore's 200–500ms
- For music sync, every millisecond matters
- `onValue` stream gives instant updates

**Riverpod**
- `StateNotifier` survives navigation (not tied to widget lifecycle)
- `ref.listen` allows controller to react to state changes without rebuilding the player widget
- Global singleton provider accessible from any screen

---

## 4. Firebase Schema

### 4.1 Realtime Database (for sync — low latency)

```
/musicSessions
  /{coupleCode}
    /currentTrack
      videoId:       "dQw4w9WgXcQ"        // YouTube video ID
      title:         "Never Gonna Give You Up"
      thumbnail:     "https://img.youtube.com/vi/.../hqdefault.jpg"
      channelName:   "Rick Astley"
      durationMs:    213000               // total duration in ms
    /playback
      isPlaying:     true
      startedAtMs:   1716500000000        // epoch ms when play was pressed
      seekPositionMs: 45000              // position when play was pressed
      lastActionBy:  "uid_partner1"
      lastUpdatedMs: 1716500045000
    /queue
      /0
        videoId:    "abc123"
        title:      "Song 2"
        thumbnail:  "https://..."
        addedBy:    "uid_partner2"
      /1
        videoId:    "def456"
        title:      "Song 3"
        thumbnail:  "https://..."
        addedBy:    "uid_partner1"
    /session
      isActive:     true
      startedBy:    "uid_partner1"
      startedAt:    1716500000000
```

### 4.2 Firestore (for history and metadata)

```
/couples
  /{coupleCode}
    /musicHistory           // subcollection
      /{docId}
        videoId:    "dQw4w9WgXcQ"
        title:      "Never Gonna Give You Up"
        thumbnail:  "https://..."
        playedAt:   Timestamp
        playedBy:   "uid_partner1"
        durationMs: 213000
```

### 4.3 Firebase Rules (Realtime Database)

```json
{
  "rules": {
    "musicSessions": {
      "$coupleCode": {
        ".read": "auth != null && (
          root.child('couples').child($coupleCode).child('partner1Uid').val() === auth.uid ||
          root.child('couples').child($coupleCode).child('partner2Uid').val() === auth.uid
        )",
        ".write": "auth != null && (
          root.child('couples').child($coupleCode).child('partner1Uid').val() === auth.uid ||
          root.child('couples').child($coupleCode).child('partner2Uid').val() === auth.uid
        )"
      }
    }
  }
}
```

---

## 5. Architecture

### 5.1 Three-Layer Design

```
┌──────────────────────────────────────────────────────┐
│  LAYER 3 — UI Shell                                  │
│  MiniPlayerBar | BubblePlayer | PopupPlayer |        │
│  FullScreenPlayer                                     │
│  (Mode changes, NO rebuilds of core player)          │
├──────────────────────────────────────────────────────┤
│  LAYER 2 — YouTubeCoreWidget                         │
│  Single YouTubePlayer widget, NEVER disposed         │
│  Lives in MaterialApp builder (above all screens)    │
│  Hidden via Offstage when video not needed           │
├──────────────────────────────────────────────────────┤
│  LAYER 1 — MusicController (Riverpod)                │
│  Global singleton StateNotifier                      │
│  Holds: MusicState, YouTubePlayerController          │
│  Talks to: Firebase sync, YouTube API                │
└──────────────────────────────────────────────────────┘
```

### 5.2 Widget Tree

```
MyApp
└── ProviderScope
    └── MaterialApp
        └── builder: (context, child) => Stack([
                child,                    // Navigator + all screens
                MusicGlobalLayer(),       // ALWAYS alive, above everything
            ])
            └── MusicGlobalLayer
                ├── YouTubeCoreWidget    // Offstage when hidden
                ├── MiniPlayerBar        // visible when mode == miniBar
                ├── BubblePlayer         // visible when mode == bubble
                ├── PopupPlayer          // visible when mode == popup
                └── FullScreenPlayer     // visible when mode == fullScreen
```

### 5.3 Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── features/
│   └── music/
│       ├── controller/
│       │   ├── music_controller.dart        // StateNotifier, main logic
│       │   ├── music_sync_service.dart      // Firebase read/write
│       │   └── youtube_search_service.dart  // YouTube Data API v3
│       │
│       ├── models/
│       │   ├── music_state.dart             // app state model
│       │   ├── music_track.dart             // track data model
│       │   ├── music_session.dart           // Firebase session model
│       │   └── player_mode.dart             // enum
│       │
│       ├── widgets/
│       │   ├── music_global_layer.dart      // Stack above all screens
│       │   ├── youtube_core_widget.dart     // actual YouTubePlayer, never disposed
│       │   ├── mini_player_bar.dart         // bottom strip
│       │   ├── bubble_player.dart           // draggable floating circle
│       │   ├── popup_player.dart            // center card
│       │   ├── full_screen_player.dart      // full screen UI
│       │   ├── music_search_sheet.dart      // bottom sheet search
│       │   ├── queue_bottom_sheet.dart      // queue management
│       │   └── chat_music_card.dart         // song card in chat
│       │
│       └── screens/
│           └── music_search_screen.dart
```

---

## 6. Data Models

### 6.1 PlayerMode Enum

```dart
// lib/features/music/models/player_mode.dart

enum PlayerMode {
  hidden,       // no UI shown
  miniBar,      // bottom strip (like Spotify mini player)
  bubble,       // floating draggable circle
  popup,        // center card popup
  fullScreen,   // full screen
}
```

### 6.2 MusicTrack

```dart
// lib/features/music/models/music_track.dart

class MusicTrack {
  final String videoId;
  final String title;
  final String thumbnail;
  final String channelName;
  final int durationMs;

  const MusicTrack({
    required this.videoId,
    required this.title,
    required this.thumbnail,
    required this.channelName,
    required this.durationMs,
  });

  factory MusicTrack.fromJson(Map<String, dynamic> json) => MusicTrack(
        videoId: json['videoId'] as String,
        title: json['title'] as String,
        thumbnail: json['thumbnail'] as String,
        channelName: json['channelName'] as String,
        durationMs: json['durationMs'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'title': title,
        'thumbnail': thumbnail,
        'channelName': channelName,
        'durationMs': durationMs,
      };
}
```

### 6.3 MusicState

```dart
// lib/features/music/models/music_state.dart

class MusicState {
  final MusicTrack? currentTrack;
  final bool isPlaying;
  final PlayerMode mode;
  final List<MusicTrack> queue;
  final bool isSyncing;           // true while applying remote sync
  final bool isPartnerListening;  // is partner also in session
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
  }) =>
      MusicState(
        currentTrack: currentTrack ?? this.currentTrack,
        isPlaying: isPlaying ?? this.isPlaying,
        mode: mode ?? this.mode,
        queue: queue ?? this.queue,
        isSyncing: isSyncing ?? this.isSyncing,
        isPartnerListening: isPartnerListening ?? this.isPartnerListening,
        bubbleX: bubbleX ?? this.bubbleX,
        bubbleY: bubbleY ?? this.bubbleY,
      );
}
```

---

## 7. Core Implementation

### 7.1 MusicSyncService

```dart
// lib/features/music/controller/music_sync_service.dart

import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class MusicSyncService {
  final String coupleCode;
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  MusicSyncService({required this.coupleCode});

  DatabaseReference get _sessionRef =>
      _db.ref('musicSessions/$coupleCode');

  // ── Write: when local user acts ──────────────────────────────
  
  Future<void> writePlayEvent({
    required MusicTrack track,
    required double seekPositionMs,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _sessionRef.update({
      'currentTrack': track.toJson(),
      'playback/isPlaying': true,
      'playback/startedAtMs': now,
      'playback/seekPositionMs': seekPositionMs,
      'playback/lastUpdatedMs': now,
    });
  }

  Future<void> writePauseEvent({required double seekPositionMs}) async {
    await _sessionRef.update({
      'playback/isPlaying': false,
      'playback/seekPositionMs': seekPositionMs,
      'playback/lastUpdatedMs': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> writeSeekEvent({required double seekPositionMs}) async {
    // Debounce this — call only after 500ms of no seek activity
    final now = DateTime.now().millisecondsSinceEpoch;
    await _sessionRef.update({
      'playback/seekPositionMs': seekPositionMs,
      'playback/startedAtMs': now,
      'playback/lastUpdatedMs': now,
    });
  }

  Future<void> writeQueue(List<MusicTrack> queue) async {
    await _sessionRef.child('queue').set(
      queue.asMap().map((i, t) => MapEntry(i.toString(), t.toJson())),
    );
  }

  // ── Read: listen for partner's actions ───────────────────────

  Stream<DatabaseEvent> get playbackStream =>
      _sessionRef.child('playback').onValue;

  Stream<DatabaseEvent> get trackStream =>
      _sessionRef.child('currentTrack').onValue;

  Stream<DatabaseEvent> get queueStream =>
      _sessionRef.child('queue').onValue;

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
    return seekPositionMs + drift;
  }
}
```

### 7.2 YouTubeSearchService

```dart
// lib/features/music/controller/youtube_search_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

class YouTubeSearchService {
  // Store your API key in flutter_dotenv or --dart-define
  static const String _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  Future<List<MusicTrack>> search(String query) async {
    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
      'part': 'snippet',
      'q': query,
      'type': 'video',
      'videoCategoryId': '10', // Music category
      'maxResults': '20',
      'key': _apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) throw Exception('YouTube search failed');

    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;

    return items.map((item) {
      final snippet = item['snippet'] as Map<String, dynamic>;
      final videoId = item['id']['videoId'] as String;
      return MusicTrack(
        videoId: videoId,
        title: snippet['title'] as String,
        thumbnail: snippet['thumbnails']['high']['url'] as String,
        channelName: snippet['channelTitle'] as String,
        durationMs: 0, // fetch separately via /videos endpoint if needed
      );
    }).toList();
  }

  Future<int> getVideoDurationMs(String videoId) async {
    final uri = Uri.parse('$_baseUrl/videos').replace(queryParameters: {
      'part': 'contentDetails',
      'id': videoId,
      'key': _apiKey,
    });
    final response = await http.get(uri);
    final data = json.decode(response.body);
    final duration = data['items'][0]['contentDetails']['duration'] as String;
    return _iso8601DurationToMs(duration);
  }

  int _iso8601DurationToMs(String iso) {
    // Parse PT3M30S → 210000 ms
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final match = regex.firstMatch(iso)!;
    final h = int.tryParse(match.group(1) ?? '0') ?? 0;
    final m = int.tryParse(match.group(2) ?? '0') ?? 0;
    final s = int.tryParse(match.group(3) ?? '0') ?? 0;
    return ((h * 3600) + (m * 60) + s) * 1000;
  }
}
```

### 7.3 MusicController

```dart
// lib/features/music/controller/music_controller.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Provider
final musicControllerProvider =
    StateNotifierProvider<MusicController, MusicState>((ref) {
  return MusicController();
});

// Global YouTubePlayerController provider
// Separate from MusicController so it NEVER gets recreated
final youtubePlayerControllerProvider = Provider<YoutubePlayerController>((ref) {
  final controller = YoutubePlayerController(
    initialVideoId: '',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
      hideControls: true,      // We use custom controls
      disableDragSeek: true,   // We handle seek ourselves
      enableCaption: false,
    ),
  );
  ref.onDispose(controller.dispose);
  return controller;
});

class MusicController extends StateNotifier<MusicState> {
  MusicController() : super(const MusicState());

  late MusicSyncService _syncService;
  late YoutubePlayerController _ytController;
  StreamSubscription? _playbackSub;
  StreamSubscription? _trackSub;
  StreamSubscription? _queueSub;
  Timer? _seekDebounce;
  bool _isApplyingRemoteSync = false; // prevent feedback loop

  void initialize({
    required String coupleCode,
    required YoutubePlayerController ytController,
  }) {
    _ytController = ytController;
    _syncService = MusicSyncService(coupleCode: coupleCode);
    _listenToFirebase();
  }

  void dispose() {
    _playbackSub?.cancel();
    _trackSub?.cancel();
    _queueSub?.cancel();
    _seekDebounce?.cancel();
    super.dispose();
  }

  // ── Firebase Listeners ────────────────────────────────────────

  void _listenToFirebase() {
    // Listen to track changes
    _trackSub = _syncService.trackStream.listen((event) {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final track = MusicTrack.fromJson(data);

      // Load new video only if different from current
      if (track.videoId != state.currentTrack?.videoId) {
        _isApplyingRemoteSync = true;
        _ytController.load(track.videoId);
        state = state.copyWith(currentTrack: track);
        _isApplyingRemoteSync = false;
      }
    });

    // Listen to playback state
    _playbackSub = _syncService.playbackStream.listen((event) {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      final isPlaying = data['isPlaying'] as bool;
      final seekPositionMs = (data['seekPositionMs'] as num).toDouble();
      final startedAtMs = data['startedAtMs'] as int;

      _isApplyingRemoteSync = true;

      if (isPlaying) {
        final syncPos = _syncService.calculateSyncPosition(
          seekPositionMs: seekPositionMs,
          startedAtMs: startedAtMs,
        );
        _ytController.seekTo(Duration(milliseconds: syncPos.toInt()));
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
    _queueSub = _syncService.queueStream.listen((event) {
      if (event.snapshot.value == null) return;
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final queue = data.values
          .map((v) => MusicTrack.fromJson(Map<String, dynamic>.from(v as Map)))
          .toList();
      state = state.copyWith(queue: queue);
    });
  }

  // ── Local Actions (write to Firebase → triggers listener) ────

  Future<void> playSong(MusicTrack track) async {
    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      mode: state.mode == PlayerMode.hidden ? PlayerMode.miniBar : state.mode,
    );
    _ytController.load(track.videoId);
    await _syncService.writePlayEvent(track: track, seekPositionMs: 0);
  }

  Future<void> togglePlay() async {
    final currentMs = _ytController.value.position.inMilliseconds.toDouble();
    if (state.isPlaying) {
      _ytController.pause();
      state = state.copyWith(isPlaying: false);
      await _syncService.writePauseEvent(seekPositionMs: currentMs);
    } else {
      _ytController.play();
      state = state.copyWith(isPlaying: true);
      await _syncService.writePlayEvent(
        track: state.currentTrack!,
        seekPositionMs: currentMs,
      );
    }
  }

  void seekTo(double ms) {
    _ytController.seekTo(Duration(milliseconds: ms.toInt()));
    // Debounce Firebase write (don't spam on scrubbing)
    _seekDebounce?.cancel();
    _seekDebounce = Timer(const Duration(milliseconds: 500), () {
      _syncService.writeSeekEvent(seekPositionMs: ms);
    });
  }

  Future<void> skipNext() async {
    if (state.queue.isEmpty) return;
    final next = state.queue.first;
    final newQueue = state.queue.sublist(1);
    state = state.copyWith(queue: newQueue);
    await _syncService.writeQueue(newQueue);
    await playSong(next);
  }

  Future<void> addToQueue(MusicTrack track) async {
    final newQueue = [...state.queue, track];
    state = state.copyWith(queue: newQueue);
    await _syncService.writeQueue(newQueue);
  }

  // ── Mode Control (UI only, no Firebase) ──────────────────────

  void setMode(PlayerMode mode) {
    state = state.copyWith(mode: mode);
  }

  void moveBubble(double x, double y) {
    state = state.copyWith(bubbleX: x, bubbleY: y);
  }
}
```

### 7.4 main.dart

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}
```

### 7.5 app.dart

```dart
// lib/app.dart

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Couple App',
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const MusicGlobalLayer(), // ← Always alive, always on top
          ],
        );
      },
      home: const HomeScreen(),
    );
  }
}
```

### 7.6 MusicGlobalLayer

```dart
// lib/features/music/widgets/music_global_layer.dart

class MusicGlobalLayer extends ConsumerWidget {
  const MusicGlobalLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);

    return Stack(
      children: [
        // ── Core YouTube Player (ALWAYS in tree) ──────────────
        _YouTubeCorePositioned(state: state),

        // ── UI Shell (mode-based) ─────────────────────────────
        if (state.mode == PlayerMode.miniBar)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MiniPlayerBar(),
          ),

        if (state.mode == PlayerMode.bubble)
          BubblePlayer(x: state.bubbleX, y: state.bubbleY),

        if (state.mode == PlayerMode.popup)
          const Center(child: PopupPlayer()),

        if (state.mode == PlayerMode.fullScreen)
          const Positioned.fill(child: FullScreenPlayer()),
      ],
    );
  }
}

class _YouTubeCorePositioned extends StatelessWidget {
  final MusicState state;
  const _YouTubeCorePositioned({required this.state});

  @override
  Widget build(BuildContext context) {
    // Video visible: fullScreen or popup
    final showVideo = state.mode == PlayerMode.fullScreen ||
                      state.mode == PlayerMode.popup;

    if (showVideo) {
      return const Positioned.fill(child: YouTubeCoreWidget());
    }

    // Hidden but ALIVE — audio continues
    return Positioned(
      left: -9999,
      top: 0,
      child: SizedBox(
        width: 1,
        height: 1,
        child: Offstage(
          offstage: true,
          child: YouTubeCoreWidget(),
        ),
      ),
    );
  }
}
```

### 7.7 YouTubeCoreWidget

```dart
// lib/features/music/widgets/youtube_core_widget.dart

// IMPORTANT: This widget NEVER disposes (it lives in MaterialApp builder).
// It only reacts to controller commands via ref.listen.

class YouTubeCoreWidget extends ConsumerStatefulWidget {
  const YouTubeCoreWidget({super.key});

  @override
  ConsumerState<YouTubeCoreWidget> createState() => _YouTubeCoreWidgetState();
}

class _YouTubeCoreWidgetState extends ConsumerState<YouTubeCoreWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize MusicController with YouTube controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ytController = ref.read(youtubePlayerControllerProvider);
      final coupleCode = ref.read(couplePodProvider).coupleCode; // your existing couple provider
      ref.read(musicControllerProvider.notifier).initialize(
        coupleCode: coupleCode,
        ytController: ytController,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ytController = ref.watch(youtubePlayerControllerProvider);

    return YoutubePlayer(
      controller: ytController,
      showVideoProgressIndicator: false,
      onReady: () {
        // Player is ready
      },
    );
  }
}
```

### 7.8 MiniPlayerBar

```dart
// lib/features/music/widgets/mini_player_bar.dart

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final track = state.currentTrack;

    if (track == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => controller.setMode(PlayerMode.fullScreen),
      child: Container(
        height: 64,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: track.thumbnail,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Title
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    track.channelName,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Play/Pause
            IconButton(
              icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: controller.togglePlay,
            ),

            // Next
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: controller.skipNext,
            ),

            // Bubble mode toggle
            IconButton(
              icon: const Icon(Icons.picture_in_picture_alt),
              onPressed: () => controller.setMode(PlayerMode.bubble),
            ),

            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
```

### 7.9 BubblePlayer

```dart
// lib/features/music/widgets/bubble_player.dart

class BubblePlayer extends ConsumerStatefulWidget {
  final double x;
  final double y;

  const BubblePlayer({required this.x, required this.y, super.key});

  @override
  ConsumerState<BubblePlayer> createState() => _BubblePlayerState();
}

class _BubblePlayerState extends ConsumerState<BubblePlayer> {
  late double _x;
  late double _y;

  @override
  void initState() {
    super.initState();
    _x = widget.x;
    _y = widget.y;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final track = state.currentTrack;

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;
          });
        },
        onPanEnd: (_) {
          controller.moveBubble(_x, _y);
        },
        onTap: () => controller.setMode(PlayerMode.fullScreen),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Album art circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: track != null
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(track.thumbnail),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.grey[800],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),

            // Play/pause overlay
            GestureDetector(
              onTap: controller.togglePlay,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,
                ),
                child: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7.10 FullScreenPlayer

```dart
// lib/features/music/widgets/full_screen_player.dart

class FullScreenPlayer extends ConsumerWidget {
  const FullScreenPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final ytController = ref.watch(youtubePlayerControllerProvider);
    final track = state.currentTrack;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ─────────────────────────────────────────
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () => controller.setMode(PlayerMode.miniBar),
                ),
                const Spacer(),
                Text(
                  'Listening Together 💑',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () => _showOptions(context, ref),
                ),
              ],
            ),

            // ── Video Player ─────────────────────────────────────
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayerBuilder(
                // Note: YouTubePlayer widget is already rendered in 
                // YouTubeCoreWidget (Offstage). Here we show it visually.
                // The controller is shared — same instance.
                player: YoutubePlayer(controller: ytController),
                builder: (context, player) => player,
              ),
            ),

            const SizedBox(height: 24),

            // ── Track Info ───────────────────────────────────────
            if (track != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.channelName,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // ── Seek Bar ─────────────────────────────────────────
            ValueListenableBuilder<YoutubePlayerValue>(
              valueListenable: ytController,
              builder: (context, value, _) {
                final pos = value.position.inMilliseconds.toDouble();
                final total = value.metaData.duration.inMilliseconds.toDouble();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Slider(
                        value: total > 0 ? pos.clamp(0, total) : 0,
                        min: 0,
                        max: total > 0 ? total : 1,
                        onChanged: (v) => controller.seekTo(v),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white24,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatMs(pos.toInt()),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            Text(
                              _formatMs(total.toInt()),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // ── Controls ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.queue_music, color: Colors.white),
                  onPressed: () => _showQueue(context, ref),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                  onPressed: () {}, // implement previous
                ),
                GestureDetector(
                  onTap: controller.togglePlay,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      state.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                  onPressed: controller.skipNext,
                ),
                IconButton(
                  icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                  onPressed: () => controller.setMode(PlayerMode.bubble),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatMs(int ms) {
    final duration = Duration(milliseconds: ms);
    final m = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showQueue(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const QueueBottomSheet(),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search Songs'),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const MusicSearchSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

### 7.11 ChatMusicCard (for chat integration)

```dart
// lib/features/music/widgets/chat_music_card.dart

// This is displayed in the chat when a song is shared

class ChatMusicCard extends ConsumerWidget {
  final MusicTrack track;

  const ChatMusicCard({required this.track, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(musicControllerProvider.notifier);

    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.music_note, size: 14),
              const SizedBox(width: 4),
              const Text('Song', style: TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: track.thumbnail,
              width: double.infinity,
              height: 130,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            track.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            track.channelName,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.playSong(track),
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Play Together 💑'),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 8. Sync Logic — Edge Cases

### 8.1 All Scenarios Handled

| Scenario | How it's handled |
|---|---|
| Partner A presses Play | Writes `startedAtMs + seekPositionMs` to Firebase |
| Partner B receives play event | Calculates `drift = now - startedAtMs`, seeks to `seekPos + drift` |
| Partner B opens app mid-song | Same drift calculation — seeks to current position automatically |
| Partner A seeks | Debounced write after 500ms, B auto-seeks on receive |
| Partner A pauses | Writes `isPlaying: false + currentPosition`, B pauses at same pos |
| Both try to control simultaneously | Last write wins (`lastUpdatedMs` comparison optional) |
| No internet briefly | Local playback continues; on reconnect Firebase sync resumes |
| Song ends | `youtubePlayerController.onEnded` → trigger `skipNext()` |

### 8.2 Anti-Feedback Loop

When partner B receives a Firebase event and seeks to sync position, we must NOT write that seek back to Firebase (infinite loop).

```dart
bool _isApplyingRemoteSync = false;

// In Firebase listener:
_isApplyingRemoteSync = true;
_ytController.seekTo(...);
_isApplyingRemoteSync = false;

// In seekTo() method:
Future<void> seekTo(double ms) async {
  _ytController.seekTo(Duration(milliseconds: ms.toInt()));
  
  if (_isApplyingRemoteSync) return; // ← prevents loop
  
  _seekDebounce?.cancel();
  _seekDebounce = Timer(const Duration(milliseconds: 500), () {
    _syncService.writeSeekEvent(seekPositionMs: ms);
  });
}
```

---

## 9. Mode Transition Flow

```
Any screen → controller.setMode(PlayerMode.X)
                │
                ▼
        MusicState.mode changes
                │
                ▼
        MusicGlobalLayer rebuilds (lightweight)
                │
                ├── YouTubeCoreWidget? → NO REBUILD (Offstage just repositions)
                ├── MiniPlayerBar? → shows/hides
                ├── BubblePlayer? → shows/hides
                ├── PopupPlayer? → shows/hides
                └── FullScreenPlayer? → shows/hides

Audio: NEVER interrupted ✅
Position: NEVER reset ✅
Controller: NEVER recreated ✅
```

---

## 10. How to Call from Any Screen

```dart
// From HomeScreen, ChatScreen, ProfileScreen — anywhere:

class AnyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicControllerProvider);
    final music = ref.read(musicControllerProvider.notifier);

    return Column(children: [
      // Play a song
      ElevatedButton(
        onPressed: () => music.playSong(MusicTrack(...)),
        child: Text('Play'),
      ),
      
      // Switch to bubble from current screen
      ElevatedButton(
        onPressed: () => music.setMode(PlayerMode.bubble),
        child: Text('Go Bubble'),
      ),
      
      // Show full screen
      ElevatedButton(
        onPressed: () => music.setMode(PlayerMode.fullScreen),
        child: Text('Full Screen'),
      ),
      
      // Read current state
      if (musicState.isPlaying)
        Text('Now playing: ${musicState.currentTrack?.title}'),
    ]);
  }
}
```

---

## 11. Implementation Order (for AI Agent)

Follow this exact order. Do not skip steps.

```
Step 1:  Create all model files (PlayerMode, MusicTrack, MusicState)
Step 2:  Create MusicSyncService (Firebase read/write only, no UI)
Step 3:  Create YouTubeSearchService (YouTube Data API v3)
Step 4:  Create youtubePlayerControllerProvider (global singleton)
Step 5:  Create MusicController (StateNotifier) with all methods
Step 6:  Update main.dart — ProviderScope wrapping
Step 7:  Update app.dart — MaterialApp builder with MusicGlobalLayer
Step 8:  Create YouTubeCoreWidget (never disposes)
Step 9:  Create MusicGlobalLayer (Stack with mode-based children)
Step 10: Create MiniPlayerBar widget
Step 11: Create BubblePlayer widget (draggable)
Step 12: Create PopupPlayer widget
Step 13: Create FullScreenPlayer widget
Step 14: Create MusicSearchSheet (bottom sheet with search + results)
Step 15: Create QueueBottomSheet
Step 16: Create ChatMusicCard
Step 17: Firebase Realtime Database rules setup
Step 18: YouTube Data API v3 key setup (--dart-define)
Step 19: Test sync between two devices/simulators
Step 20: Test all mode transitions without audio interruption
```

---

## 12. Critical Rules for AI Agent

> ⚠️ Read these before writing any code.

1. **YouTubePlayerController must be created ONCE** — use `youtubePlayerControllerProvider` (a `Provider`, not `StateProvider`). Never create it inside a widget's `build()` method.

2. **YouTubeCoreWidget must never be conditionally included** — it must always be in the widget tree. Use `Offstage` or off-screen `Positioned` to hide it, never `if()`.

3. **MusicController's initialize() must be called once** — in `YouTubeCoreWidget`'s `initState()` via `addPostFrameCallback`.

4. **Do not use `ref.watch(youtubePlayerControllerProvider)` in `YouTubeCoreWidget`** — it causes rebuild. Use `ref.read` after init.

5. **All Firebase writes go through MusicSyncService** — never write directly from UI widgets.

6. **`_isApplyingRemoteSync` flag must be checked** before every Firebase write inside `MusicController` to prevent feedback loops.

7. **Debounce seek writes** — use a 500ms `Timer` before writing seek position to Firebase.

8. **PlayerMode changes are local only** — do NOT sync `PlayerMode` to Firebase. Each partner controls their own UI mode independently.

9. **Queue changes ARE synced** — any add/remove/reorder must write to Firebase.

10. **YouTube iframe rules**: Never try to extract stream URLs. Only use `YoutubePlayerController.load(videoId)` and `YoutubePlayerController.play/pause/seekTo`.

---

## 13. File Checklist

- [ ] `lib/features/music/models/player_mode.dart`
- [ ] `lib/features/music/models/music_track.dart`
- [ ] `lib/features/music/models/music_state.dart`
- [ ] `lib/features/music/controller/music_sync_service.dart`
- [ ] `lib/features/music/controller/youtube_search_service.dart`
- [ ] `lib/features/music/controller/music_controller.dart`
- [ ] `lib/features/music/widgets/youtube_core_widget.dart`
- [ ] `lib/features/music/widgets/music_global_layer.dart`
- [ ] `lib/features/music/widgets/mini_player_bar.dart`
- [ ] `lib/features/music/widgets/bubble_player.dart`
- [ ] `lib/features/music/widgets/popup_player.dart`
- [ ] `lib/features/music/widgets/full_screen_player.dart`
- [ ] `lib/features/music/widgets/music_search_sheet.dart`
- [ ] `lib/features/music/widgets/queue_bottom_sheet.dart`
- [ ] `lib/features/music/widgets/chat_music_card.dart`
- [ ] `lib/app.dart` (updated with builder)
- [ ] `lib/main.dart` (updated with ProviderScope)
- [ ] Firebase Realtime Database rules applied
- [ ] `pubspec.yaml` updated with all packages
- [ ] YouTube Data API key set via `--dart-define=YOUTUBE_API_KEY=YOUR_KEY`