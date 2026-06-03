// lib/features/music/widgets/mini_player_bar.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import '../controller/music_controller.dart';
import '../models/player_mode.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(musicControllerProvider);
    final controller = ref.read(musicControllerProvider.notifier);
    final ytController = ref.watch(youtubePlayerControllerProvider);
    final track = state.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim ? AppColors.slateBluePrimary : AppColors.rosePrimary;

    return GestureDetector(
      onTap: () => controller.setMode(PlayerMode.fullScreen),
      child: Container(
        height: 72,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05), width: 0.5),
        ),
        child: Column(
          children: [
            // Progress line at TOP of bar
            ValueListenableBuilder<YoutubePlayerValue>(
              valueListenable: ytController,
              builder: (context, value, _) {
                final pos = value.position.inMilliseconds.toDouble();
                final total = value.metaData.duration.inMilliseconds.toDouble();
                final displayTotal = total > 0 ? total : track.durationMs.toDouble();
                final progress = (pos / displayTotal).clamp(0.0, 1.0);

                return Container(
                  height: 2,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Row: thumbnail | title+artist | play/pause
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: track.thumbnail,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            track.channelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      onPressed: () => controller.togglePlay(),
                    ),
                    IconButton(
                        icon: Icon(Icons.close_rounded, color: isDark ? Colors.white38 : Colors.black38, size: 20),
                        onPressed: () => controller.endSession(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

