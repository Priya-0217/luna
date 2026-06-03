// lib/features/music/widgets/bubble_player.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import '../controller/music_controller.dart';
import '../models/player_mode.dart';

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
  bool _isDragging = false;

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

    if (track == null) {
      debugPrint('[BubblePlayer] build skipped (no track)');
      return const SizedBox.shrink();
    }

    debugPrint(
      '[BubblePlayer] build track=${track.videoId} isPlaying=${state.isPlaying}',
    );

    final size = MediaQuery.of(context).size;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;

    return Positioned(
      left: _x,
      top: _y,
      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            _x += details.delta.dx;
            _y += details.delta.dy;

            // Clamp coordinates to stay completely on screen
            _x = _x.clamp(8.0, size.width - 72.0);
            _y = _y.clamp(8.0, size.height - 72.0);
          });
        },
        onPanEnd: (_) {
          setState(() {
            _isDragging = false;
          });
          debugPrint('[BubblePlayer] drag end x=$_x y=$_y');
          controller.moveBubble(_x, _y);
        },
        onLongPress: () {
          debugPrint('[BubblePlayer] long press -> miniBar');
          controller.setMode(PlayerMode.miniBar);
        },
        onTap: () {
          debugPrint('[BubblePlayer] open fullScreen');
          controller.setMode(PlayerMode.fullScreen);
        },
        child: AnimatedScale(
          scale: _isDragging ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Draggable Shadow Ring
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: themeColor.withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Thumbnail Artwork Circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: track.thumbnail.isNotEmpty
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(track.thumbnail),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: AppColors.charcoal,
                ),
                child: track.thumbnail.isEmpty
                    ? const Icon(Icons.music_note, color: Colors.white)
                    : null,
              ),

              // Play/Pause Overlay Toggle
              GestureDetector(
                onTap: () {
                  debugPrint('[BubblePlayer] toggle play');
                  controller.togglePlay();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.35),
                  ),
                  child: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
