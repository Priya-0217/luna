import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HerNamePage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onNext;

  const HerNamePage({
    super.key,
    required this.controller,
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
                  "What should we call you?",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: AppTypography.h3.copyWith(
                    fontSize: 24,
                    color: AppColors.charcoal,
                  ),
                  cursorColor: AppColors.rosePrimary,
                  decoration: InputDecoration(
                    hintText: "Your name...",
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.warmGray400,
                    ),
                    filled: true,
                    fillColor: AppColors.warmGray100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) {
                    if (controller.text.trim().length >= 2) {
                      onNext();
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return Text(
                      "Hello, ${value.text} 🌸",
                      style: AppTypography.h3.copyWith(
                        fontFamily: 'Cormorant Garamond',
                        fontStyle: FontStyle.italic,
                        color: AppColors.rosePrimary,
                        fontSize: 24,
                      ),
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
