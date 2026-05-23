import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_empty_state.dart';

class VoicePlaybackScreen extends StatelessWidget {
  const VoicePlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('His Voice 🎙️', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LunaEmptyState(
          illustration: AppIllustrations.hello,
          title: 'Hear His Voice',
          subtitle: 'He\'s preparing warm audio messages for you. Listen in when you feel low 💕',
        ),
      ),
    );
  }
}
