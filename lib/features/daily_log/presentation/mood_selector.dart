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

  // 9-mood grid as specified in the dgd (3×3)
  static const List<Map<String, String>> moods = [
    {'key': 'happy',     'label': 'Joyful',      'asset': AppIllustrations.happy},
    {'key': 'peaceful',  'label': 'Calm',        'asset': AppIllustrations.peaceful},
    {'key': 'tired',     'label': 'Tired',       'asset': AppIllustrations.tired},
    {'key': 'anxious',   'label': 'Anxious',     'asset': AppIllustrations.anxious},
    {'key': 'sad',       'label': 'Sad',         'asset': AppIllustrations.sad},
    {'key': 'irritable', 'label': 'Irritable',   'asset': AppIllustrations.irritated},
    {'key': 'excited',   'label': 'Excited',     'asset': AppIllustrations.excited},
    {'key': 'grateful',  'label': 'Grateful',    'asset': AppIllustrations.grateful},
    {'key': 'content',   'label': 'Content',     'asset': AppIllustrations.content},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedData = selectedMood != null
        ? moods.where((m) => m['key'] == selectedMood).firstOrNull
        : null;

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
        const SizedBox(height: AppSpacing.md),

        // Large character preview slides in when mood is selected
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: selectedData != null
              ? Container(
                  key: ValueKey(selectedData['key']),
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.roseSoft.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.rosePrimary.withOpacity(0.25),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Big character image (180px as per dgd)
                      Image.asset(
                        selectedData['asset']!,
                        width: 90,
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.roseSoft,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _getMoodEmoji(selectedData['key']!),
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Feeling ${selectedData['label']}",
                              style: AppTypography.titleLarge.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.roseDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getMoodMessage(selectedData['key']!),
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),

        // 3×3 Mood Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: moods.length,
          itemBuilder: (context, index) {
            final mood = moods[index];
            final isSelected = selectedMood == mood['key'];

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onMoodSelected(mood['key']!);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                            color: AppColors.rosePrimary.withOpacity(0.15),
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
            );
          },
        ),
      ],
    );
  }

  String _getMoodMessage(String key) {
    const messages = <String, String>{
      'happy':     "You're radiating warmth today! 🌸",
      'peaceful':  "A gentle, quiet day. That's beautiful 🕊️",
      'tired':     "It's okay to rest, love. Be soft with yourself 💤",
      'anxious':   "Take slow breaths. Everything will settle 🌿",
      'sad':       "It's okay to feel this. You're not alone 🌧️",
      'irritable': "Some days are prickly. That's human too 🔥",
      'excited':   "That spark in you is wonderful ✨",
      'grateful':  "Gratitude is such a beautiful energy 🙏",
      'content':   "Quiet contentment is its own kind of joy 😌",
    };
    return messages[key] ?? "You are heard and cared for 💕";
  }

  String _getMoodEmoji(String key) {
    const map = {
      'happy':     '🌸',
      'peaceful':  '🕊️',
      'tired':     '💤',
      'anxious':   '🥺',
      'sad':       '🌧️',
      'irritable': '🔥',
      'excited':   '✨',
      'grateful':  '🙏',
      'content':   '😌',
    };
    return map[key] ?? '🌸';
  }
}
