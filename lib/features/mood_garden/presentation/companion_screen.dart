import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_empty_state.dart';

class CompanionScreen extends StatelessWidget {
  const CompanionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('Luna Companion Chat 🌙', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LunaEmptyState(
          illustration: AppIllustrations.meditating,
          title: 'Your Quiet Companion',
          subtitle: 'A peaceful chat room where you can get immediate, loving suggestions selected by him. Coming soon 💕',
        ),
      ),
    );
  }
}
