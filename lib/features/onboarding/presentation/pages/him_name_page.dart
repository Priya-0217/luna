import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HimNamePage extends StatelessWidget {
  final TextEditingController hisNameController;
  final TextEditingController herNameController;
  final VoidCallback onNext;

  const HimNamePage({
    super.key,
    required this.hisNameController,
    required this.herNameController,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          LunaCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(AppIllustrations.happy, height: 80),
                ),
                Text(
                  "Tell us your names",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: hisNameController,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.charcoal,
                  ),
                  cursorColor: AppColors.slateBluePrimary,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "What's your name?",
                    hintText: "Your name...",
                    filled: true,
                    fillColor: AppColors.warmGray100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ValueListenableBuilder(
                  valueListenable: hisNameController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return Text(
                      "Hey, ${value.text} 💙",
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.slateBluePrimary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: herNameController,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.charcoal,
                  ),
                  cursorColor: AppColors.slateBluePrimary,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (hisNameController.text.trim().length >= 2 &&
                        herNameController.text.trim().length >= 2) {
                      onNext();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "What's her name?",
                    hintText: "Her name...",
                    filled: true,
                    fillColor: AppColors.warmGray100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ValueListenableBuilder(
                  valueListenable: herNameController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return Column(
                      children: [
                        Text(
                          "You're setting this up for ${value.text} 🌸",
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.slateBluePrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Image.asset(AppIllustrations.inLove, height: 80),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
