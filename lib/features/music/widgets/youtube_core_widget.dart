// lib/features/music/widgets/youtube_core_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import '../controller/music_controller.dart';

class YouTubeCoreWidget extends ConsumerStatefulWidget {
  const YouTubeCoreWidget({super.key});

  @override
  ConsumerState<YouTubeCoreWidget> createState() => _YouTubeCoreWidgetState();
}

class _YouTubeCoreWidgetState extends ConsumerState<YouTubeCoreWidget> {
  late final YoutubePlayerController _ytController;
  bool _listenerAttached = false;

  @override
  void initState() {
    super.initState();

    _ytController = ref.read(youtubePlayerControllerProvider);
    debugPrint('[YouTubeCoreWidget] initState');

    // Initialize MusicController with YouTube player controller and coupleCode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = ref.read(authProvider).valueOrNull;
      final coupleId = user?.coupleId;

      ref
          .read(musicControllerProvider.notifier)
          .initialize(coupleId: coupleId, ytController: _ytController);

      // Hook end of video to skip next
      if (!_listenerAttached) {
        _ytController.addListener(_onPlayerStateChange);
        _listenerAttached = true;
      }
    });
  }

  @override
  void dispose() {
    if (_listenerAttached) {
      _ytController.removeListener(_onPlayerStateChange);
    }
    debugPrint('[YouTubeCoreWidget] dispose');
    super.dispose();
  }

  void _onPlayerStateChange() {
    if (!mounted) return;
    final value = _ytController.value;
    final isEnded = value.playerState == PlayerState.ended;

    if (value.hasError) {
      debugPrint('[YouTubeCoreWidget] player error code=${value.errorCode}');
    }

    if (isEnded) {
      debugPrint('[YouTubeCoreWidget] player ended, skipping next');
      ref.read(musicControllerProvider.notifier).skipNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _ytController.value;
    debugPrint(
      '[YouTubeCoreWidget] build ready=${value.isReady} state=${value.playerState} '
      'videoId=${value.metaData.videoId}',
    );
    return YoutubePlayer(
      controller: _ytController,
      showVideoProgressIndicator: false,
      onReady: () {
        debugPrint('[YouTubeCoreWidget] player ready');
        ref.read(musicControllerProvider.notifier).onPlayerReady();
      },
    );
  }
}
