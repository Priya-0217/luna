import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:intl/intl.dart';

class CycleSetupPage extends StatelessWidget {
  final DateTime lastPeriodDate;
  final double cycleLength;
  final double periodDuration;
  final Function(DateTime) onDateSelected;
  final Function(double) onCycleLengthChanged;
  final Function(double) onPeriodDurationChanged;

  const CycleSetupPage({
    super.key,
    required this.lastPeriodDate,
    required this.cycleLength,
    required this.periodDuration,
    required this.onDateSelected,
    required this.onCycleLengthChanged,
    required this.onPeriodDurationChanged,
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
                  child: Image.asset(
                    lastPeriodDate.isBefore(DateTime.now())
                        ? AppIllustrations.cozy
                        : AppIllustrations.planning,
                    height: 80,
                  ),
                ),
                Text(
                  "Let's set up your cycle",
                  style: AppTypography.h2.copyWith(
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 28,
                  ),
                ),
                Text(
                  "This helps Luna understand and care for you",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warmGray600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text(
                  "When did your last period start?",
                  style: AppTypography.labelMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: lastPeriodDate,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 90),
                      ),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) onDateSelected(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.roseMid),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('MMMM d, y').format(lastPeriodDate)),
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppColors.rosePrimary,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "How long is your cycle?",
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      "${cycleLength.toInt()} days",
                      style: AppTypography.h3.copyWith(
                        fontFamily: 'Cormorant Garamond',
                        fontStyle: FontStyle.italic,
                        color: AppColors.rosePrimary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: cycleLength,
                  min: 21,
                  max: 45,
                  activeColor: AppColors.rosePrimary,
                  onChanged: onCycleLengthChanged,
                ),

                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "How long does your period last?",
                      style: AppTypography.labelMedium,
                    ),
                    Text(
                      "${periodDuration.toInt()} days",
                      style: AppTypography.h3.copyWith(
                        fontFamily: 'Cormorant Garamond',
                        fontStyle: FontStyle.italic,
                        color: AppColors.rosePrimary,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: periodDuration,
                  min: 2,
                  max: 10,
                  activeColor: AppColors.rosePrimary,
                  onChanged: onPeriodDurationChanged,
                ),

                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Text(
                    "You can always change this later 🌸",
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.warmGray400,
                    ),
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
