import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HimNotificationsPage extends StatelessWidget {
  final Map<String, bool> selections;
  final void Function(String, bool) onChanged;

  const HimNotificationsPage({
    super.key,
    required this.selections,
    required this.onChanged,
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
                  child: Image.asset(AppIllustrations.warm, height: 90),
                ),
                Text(
                  "May I help you take care of her?",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                  ),
                ),
                Text(
                  "These are written as gentle nudges, not alarms.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _NotificationToggle(
                  title: "Period predictions",
                  subtitle: "Before her cycle starts",
                  value: selections['periodPrediction'] ?? true,
                  onChanged: (val) => onChanged('periodPrediction', val),
                ),
                _NotificationToggle(
                  title: "Her mood updates",
                  subtitle: "Know how she is doing",
                  value: selections['mood'] ?? true,
                  onChanged: (val) => onChanged('mood', val),
                ),
                _NotificationToggle(
                  title: "From her",
                  subtitle: "New notes and surprises",
                  value: selections['fromHer'] ?? true,
                  onChanged: (val) => onChanged('fromHer', val),
                ),
                _NotificationToggle(
                  title: "Care reminders",
                  subtitle: "Small prompts to show up",
                  value: selections['careReminders'] ?? true,
                  onChanged: (val) => onChanged('careReminders', val),
                ),
                _NotificationToggle(
                  title: "Couple streaks",
                  subtitle: "Celebrate together",
                  value: selections['streak'] ?? true,
                  onChanged: (val) => onChanged('streak', val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
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
            activeColor: AppColors.slateBluePrimary,
          ),
        ],
      ),
    );
  }
}
