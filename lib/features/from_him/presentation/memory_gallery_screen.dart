import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_empty_state.dart';
import 'package:her/core/constants/app_illustrations.dart';

class MemoryGalleryScreen extends StatelessWidget {
  const MemoryGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('Our Memories 📸', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LunaEmptyState(
          illustration: AppIllustrations.natureLove,
          title: 'Preserved Forever',
          subtitle: 'He hasn\'t added any memories yet — they\'re on their way 💌',
        ),
      ),
    );
  }
}
