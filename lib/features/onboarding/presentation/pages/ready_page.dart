import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HerReadyPage extends StatelessWidget {
  final VoidCallback onFinish;

  const HerReadyPage({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppIllustrations.inLove, height: 180),
          const SizedBox(height: AppSpacing.lg),
          LunaCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            color: AppColors.cream,
            child: Column(
              children: [
                Text(
                  "I made this for you. I hope every time you open it,\n"
                  "you feel loved and cared for.",
                  textAlign: TextAlign.center,
                  style: AppTypography.handwrittenLg,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  "Open Luna whenever you want to feel close.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const StadiumBorder(),
              ),
              child: Text(
                "Open Luna",
                style: AppTypography.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HimReadyPage extends StatelessWidget {
  final VoidCallback onFinish;

  const HimReadyPage({super.key, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(AppIllustrations.inLove, height: 180),
          const SizedBox(height: AppSpacing.lg),
          LunaCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            color: AppColors.cream,
            child: Column(
              children: [
                Text(
                  "I made this for you because you always take care of me.\n"
                  "Let this help you take care of us.",
                  textAlign: TextAlign.center,
                  style: AppTypography.handwrittenLg,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  "Open Luna and feel her love every day.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.slateBluePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: const StadiumBorder(),
              ),
              child: Text(
                "Open Luna",
                style: AppTypography.titleMedium.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
