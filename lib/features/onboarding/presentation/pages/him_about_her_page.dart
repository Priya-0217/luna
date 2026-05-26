import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HimAboutHerPage extends StatelessWidget {
  final Map<String, bool> preferences;
  final Function(String, bool) onPreferenceChanged;
  final TextEditingController secretNoteController;

  const HimAboutHerPage({
    super.key,
    required this.preferences,
    required this.onPreferenceChanged,
    required this.secretNoteController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          LunaCard(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(AppIllustrations.content, height: 80),
                ),
                Text(
                  "About Her",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                  ),
                ),
                Text(
                  "A few things to help Luna care for her better",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ToggleTile(
                  title: "She's shared her cycle with me",
                  subtitle: "Enables care dashboard",
                  value: preferences['shareCycle'] ?? false,
                  onChanged: (val) => onPreferenceChanged('shareCycle', val),
                  activeColor: AppColors.slateBluePrimary,
                ),
                _ToggleTile(
                  title: "I want notifications about her",
                  subtitle: "Enables care notifications",
                  value: preferences['herNotifications'] ?? false,
                  onChanged: (val) =>
                      onPreferenceChanged('herNotifications', val),
                  activeColor: AppColors.slateBluePrimary,
                ),
                _ToggleTile(
                  title: "Keep my care reminders private",
                  subtitle: "Local-only reminders (default ON)",
                  value: preferences['privateReminders'] ?? true,
                  onChanged: (val) =>
                      onPreferenceChanged('privateReminders', val),
                  activeColor: AppColors.goldPrimary,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  "One thing you love about her (secret — just for you)",
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextField(
                  controller: secretNoteController,
                  maxLines: 3,
                  style: const TextStyle(fontFamily: 'Caveat', fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Write anything...",
                    filled: true,
                    fillColor: AppColors.warmGray100.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  "Saved encrypted locally, never shared.",
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.warmGray400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelMedium),
                Text(
                  subtitle,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}
