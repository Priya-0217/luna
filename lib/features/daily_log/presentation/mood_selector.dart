import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<Map<String, String>> moods = [
    {'key': 'happy',     'label': 'Happy',     'asset': AppIllustrations.happy},
    {'key': 'in_love',   'label': 'In Love',   'asset': AppIllustrations.inLove},
    {'key': 'excited',   'label': 'Excited',   'asset': AppIllustrations.excited},
    {'key': 'cheerful',  'label': 'Cheerful',  'asset': AppIllustrations.cheerful},
    {'key': 'grateful',  'label': 'Grateful',  'asset': AppIllustrations.grateful},
    {'key': 'cozy',      'label': 'Cozy',      'asset': AppIllustrations.cozy},
    {'key': 'content',   'label': 'Content',   'asset': AppIllustrations.content},
    {'key': 'relaxed',   'label': 'Relaxed',   'asset': AppIllustrations.relaxed},
    {'key': 'peaceful',  'label': 'Peaceful',  'asset': AppIllustrations.peaceful},
    {'key': 'tired',     'label': 'Tired',     'asset': AppIllustrations.tired},
    {'key': 'anxious',   'label': 'Anxious',   'asset': AppIllustrations.anxious},
    {'key': 'sad',       'label': 'Sad',       'asset': AppIllustrations.sad},
    {'key': 'stressed',  'label': 'Stressed',  'asset': AppIllustrations.stressed},
    {'key': 'crying',    'label': 'Crying',    'asset': AppIllustrations.crying},
    {'key': 'irritable', 'label': 'Irritated', 'asset': AppIllustrations.irritated},
    {'key': 'down',      'label': 'Down',      'asset': AppIllustrations.disappointed},
    {'key': 'overwhelmed','label': 'Overwhelmed','asset': AppIllustrations.overwhelmed},
    {'key': 'angry',     'label': 'Angry',     'asset': AppIllustrations.angry},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How is your heart today? 💕',
          style: AppTypography.titleLarge.copyWith(
            color: isDark ? AppColors.darkText : AppColors.roseDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final isSelected = selectedMood == mood['key'];

              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onMoodSelected(mood['key']!);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 76,
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.sm, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.rosePrimary.withOpacity(0.12)
                          : (isDark ? AppColors.darkCard : AppColors.white),
                      borderRadius: AppRadius.cardRadius,
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
                                color:
                                    AppColors.rosePrimary.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Character illustration image
                        Image.asset(
                          mood['asset']!,
                          width: 52,
                          height: 52,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: 52,
                            height: 52,
                            alignment: Alignment.center,
                            child: Text(
                              _getMoodEmoji(mood['key']!),
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['label']!,
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMoodEmoji(String key) {
    const map = {
      'happy': '🌸',
      'in_love': '💕',
      'excited': '✨',
      'cheerful': '😊',
      'grateful': '🙏',
      'cozy': '🧸',
      'content': '😌',
      'relaxed': '🌿',
      'peaceful': '🕊️',
      'tired': '💤',
      'anxious': '🥺',
      'sad': '🌧️',
      'stressed': '😰',
      'crying': '😢',
      'irritable': '🔥',
      'down': '😔',
      'overwhelmed': '😵',
      'angry': '😠',
    };
    return map[key] ?? '🌸';
  }
}
