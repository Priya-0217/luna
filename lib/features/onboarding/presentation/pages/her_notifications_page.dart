import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';

class HerNotificationsPage extends StatelessWidget {
  final Map<String, bool> selections;
  final void Function(String, bool) onChanged;

  const HerNotificationsPage({
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
                  "May I check in on you?",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                  ),
                ),
                Text(
                  "These are written like messages from him, not alerts.",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _NotificationToggle(
                  title: "Period reminders",
                  subtitle: "2 days before, day 1",
                  value: selections['period'] ?? true,
                  onChanged: (val) => onChanged('period', val),
                ),
                _NotificationToggle(
                  title: "Hydration check-ins",
                  subtitle: "Gentle nudges to drink water",
                  value: selections['hydration'] ?? true,
                  onChanged: (val) => onChanged('hydration', val),
                ),
                _NotificationToggle(
                  title: "Sleep care",
                  subtitle: "Soft reminders to rest",
                  value: selections['sleep'] ?? false,
                  onChanged: (val) => onChanged('sleep', val),
                ),
                _NotificationToggle(
                  title: "From him",
                  subtitle: "New notes and surprises",
                  value: selections['fromHim'] ?? true,
                  onChanged: (val) => onChanged('fromHim', val),
                ),
                _NotificationToggle(
                  title: "Daily log",
                  subtitle: "Your time to check in",
                  value: selections['dailyLog'] ?? true,
                  onChanged: (val) => onChanged('dailyLog', val),
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
            activeColor: AppColors.rosePrimary,
          ),
        ],
      ),
    );
  }
}
