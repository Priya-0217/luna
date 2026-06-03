// lib/features/music/widgets/chat_music_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import '../controller/music_controller.dart';
import '../models/music_track.dart';

class ChatMusicCard extends ConsumerWidget {
  final MusicTrack track;

  const ChatMusicCard({required this.track, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(musicControllerProvider.notifier);

    debugPrint('[ChatMusicCard] build track=${track.videoId}');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(authProvider).valueOrNull;
    final isHim = user?.role == 'him';
    final themeColor = isHim
        ? AppColors.slateBluePrimary
        : AppColors.rosePrimary;
    final textThemeColor = isHim ? AppColors.slateBlueDark : AppColors.roseDark;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkCard
            : (isHim ? AppColors.slateBlueLight : AppColors.roseLight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : (isHim ? AppColors.slateBlueSoft : AppColors.roseSoft),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header tag
          Row(
            children: [
              Icon(Icons.music_note, size: 14, color: themeColor),
              const SizedBox(width: 4),
              Text(
                'SHARED SONG',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Artwork Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: isDark ? AppColors.darkBackground : Colors.grey[200],
                child: track.thumbnail.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: track.thumbnail,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.music_note,
                        size: 36,
                        color: Colors.grey,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Title
          Text(
            track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          // Artist / Channel Name
          Text(
            track.channelName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 12),

          // Play Together Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: () {
                debugPrint('[ChatMusicCard] play track=${track.videoId}');
                controller.playSong(track);
              },
              icon: const Icon(Icons.play_arrow, size: 16),
              label: Text(
                'Listen Together 💑',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
