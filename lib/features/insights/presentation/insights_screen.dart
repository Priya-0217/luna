import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_empty_state.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('My Insights 📊', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: LunaEmptyState(
          illustration: AppIllustrations.productive,
          title: 'Insights & Trends',
          subtitle: 'Detailed charts tracking your cycle averages, symptoms, and sleep patterns over time will appear here. 💕',
        ),
      ),
    );
  }
}
