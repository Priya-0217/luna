// lib/features/music/widgets/popup_player.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import '../controller/music_controller.dart';
import '../models/player_mode.dart';

class PopupPlayer extends ConsumerWidget {
  const PopupPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final track = state.currentTrack;

    if (track == null) {
      debugPrint('[PopupPlayer] build skipped (no track)');
      return const SizedBox.shrink();
    }

    debugPrint(
      '[PopupPlayer] build track=${track.videoId} isPlaying=${state.isPlaying}',
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;

    return Stack(
      children: [
        // Dark backdrop dismiss trigger
        GestureDetector(
          onTap: () {
            debugPrint('[PopupPlayer] dismiss to miniBar');
            controller.setMode(PlayerMode.miniBar);
          },
          child: Container(color: Colors.black.withOpacity(0.55)),
        ),

        // Pop Card
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Listen Together 💑',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        debugPrint('[PopupPlayer] close');
                        controller.setMode(PlayerMode.miniBar);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: isDark
                          ? AppColors.darkBackground
                          : AppColors.roseSoft,
                      child: track.thumbnail.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: track.thumbnail,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.music_note,
                              size: 64,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title and Artist
                Text(
                  track.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  track.channelName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.warmGray400
                        : AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: 16),

                // Controls row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        state.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: themeColor,
                        size: 48,
                      ),
                      onPressed: () {
                        debugPrint('[PopupPlayer] toggle play');
                        controller.togglePlay();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      onPressed: () {
                        debugPrint('[PopupPlayer] skip next');
                        controller.skipNext();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
