import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_empty_state.dart';
import 'package:her/core/constants/app_illustrations.dart';

class ComfortPlaylistScreen extends StatelessWidget {
  const ComfortPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('Comfort Playlist 🎵', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LunaEmptyState(
          illustration: AppIllustrations.musicTime,
          title: 'Melodies for You',
          subtitle: 'A custom collection of songs he handpicked for your softest days. Coming soon 💕',
        ),
      ),
    );
  }
}
