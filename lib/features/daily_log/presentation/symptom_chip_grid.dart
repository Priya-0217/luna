import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';

class SymptomChipGrid extends StatelessWidget {
  final List<String> selectedSymptoms;
  final ValueChanged<List<String>> onSymptomsChanged;

  const SymptomChipGrid({
    super.key,
    required this.selectedSymptoms,
    required this.onSymptomsChanged,
  });

  static const List<Map<String, String>> symptoms = [
    {
      'key': 'cramps',
      'label': 'Cramps',
      'asset': AppIllustrations.cramps,
    },
    {
      'key': 'headache',
      'label': 'Headache',
      'asset': AppIllustrations.headache,
    },
    {
      'key': 'fatigue',
      'label': 'Fatigue',
      'asset': AppIllustrations.lowEnergy,
    },
    {
      'key': 'bloating',
      'label': 'Bloating',
      'asset': AppIllustrations.bloating,
    },
    {
      'key': 'mood_swings',
      'label': 'Mood Swings',
      'asset': AppIllustrations.overwhelmed,
    },
    {
      'key': 'backache',
      'label': 'Backache',
      'asset': AppIllustrations.backPain,
    },
    {
      'key': 'nausea',
      'label': 'Nausea',
      'asset': AppIllustrations.nauseous,
    },
    {
      'key': 'dizzy',
      'label': 'Dizzy',
      'asset': AppIllustrations.dizzy,
    },
    {
      'key': 'feverish',
      'label': 'Feverish',
      'asset': AppIllustrations.feverish,
    },
    {
      'key': 'in_pain',
      'label': 'In Pain',
      'asset': AppIllustrations.inPain,
    },
    {
      'key': 'tender_breasts',
      'label': 'Tender',
      'asset': AppIllustrations.stressed,
    },
    {
      'key': 'cravings',
      'label': 'Cravings',
      'asset': AppIllustrations.cozy,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What are you feeling in your body? ⚡',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.roseDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: symptoms.length,
          itemBuilder: (context, index) {
            final symptom = symptoms[index];
            final isSelected =
                selectedSymptoms.contains(symptom['key']);

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                final updated = List<String>.from(selectedSymptoms);
                if (isSelected) {
                  updated.remove(symptom['key']);
                } else {
                  updated.add(symptom['key']!);
                }
                onSymptomsChanged(updated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.rosePrimary.withOpacity(0.12)
                      : (isDark ? AppColors.darkCard : AppColors.white),
                  borderRadius:
                      BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.rosePrimary
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.roseSoft),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.rosePrimary
                                .withOpacity(0.12),
                            blurRadius: 6,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Character image
                    Image.asset(
                      symptom['asset']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.favorite_outline,
                        color: AppColors.rosePrimary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      symptom['label']!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.rosePrimary
                            : (isDark
                                ? AppColors.darkText
                                : AppColors.charcoal),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
