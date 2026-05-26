import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';

class RoleSelectPage extends StatelessWidget {
  final String? selectedRole;
  final Function(String) onRoleSelected;

  const RoleSelectPage({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          Text(
            "First — who are you?",
            style: AppTypography.h1.copyWith(
              fontFamily: 'Cormorant Garamond',
              fontSize: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            "This shapes your entire Luna experience",
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.warmGray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  title: "I'm her 🌸",
                  subtitle: "Track my cycle, moods & wellbeing",
                  illustration: AppIllustrations.inLove,
                  backgroundColor: AppColors.roseSoft,
                  borderColor: AppColors.roseMid,
                  isSelected: selectedRole == 'her',
                  onTap: () => onRoleSelected('her'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _RoleCard(
                  title: "I'm him 💙",
                  subtitle: "Take care of her & myself",
                  illustration: AppIllustrations.happy,
                  backgroundColor: AppColors.slateBlueSoft,
                  borderColor: AppColors.slateBlueMid,
                  isSelected: selectedRole == 'him',
                  onTap: () => onRoleSelected('him'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String illustration;
  final Color backgroundColor;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.backgroundColor,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isSelected ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          height: 240,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected ? AppColors.goldPrimary : borderColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.goldPrimary.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(illustration, height: 80),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(
                      fontFamily: 'Cormorant Garamond',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.charcoal.withOpacity(0.7),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.goldPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
