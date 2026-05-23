import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/core/router/app_routes.dart';
import 'package:her/core/services/suggestion_service.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';
import 'package:her/features/mood_garden/presentation/garden_canvas.dart';

class MoodGardenScreen extends ConsumerWidget {
  const MoodGardenScreen({super.key});

  String _getMoodLabel(String mood) {
    switch (mood) {
      case 'happy':
        return 'Sunny & Happy ☀️';
      case 'cozy':
        return 'Warm & Cozy 🧸';
      case 'down':
        return 'Gentle Rain 🌧️';
      case 'anxious':
        return 'Soft Breezes 🌀';
      case 'irritable':
        return 'Crimson Twilight 🔥';
      default:
        return 'Sunny & Happy ☀️';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardProvider);

    return dashboardState.when(
      loading: () => const Center(child: LunaLoading(width: 200, height: 160)),
      error: (e, s) => const Center(child: Text('Letting the flowers grow... 💕')),
      data: (data) {
        // Map active cycle phase to garden weather and blooms
        // Mock mood to 'happy' if no daily check-in is loaded yet, otherwise retrieve
        final String activeMood = 'happy'; // Default peaceful
        final int flowersBloom = (data.cycleDay % 6) + 1; // dynamically bloom 1 to 6 flowers

        final chatTips = SuggestionService.forPhase(data.phase);

        return Scaffold(
          body: Stack(
            children: [
              // 1. Full Bleed Animated Custom Painter Garden Canvas
              Positioned.fill(
                child: GardenCanvas(
                  mood: activeMood,
                  flowersCount: flowersBloom,
                ),
              ),

              // 2. Glassmorphism Top Header & HUD
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Garden 🌿',
                              style: AppTypography.displayLarge.copyWith(
                                color: isDark ? AppColors.darkText : AppColors.roseDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard.withOpacity(0.8) : AppColors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                                border: Border.all(
                                  color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                                ),
                              ),
                              child: Text(
                                _getMoodLabel(activeMood),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.rosePrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Blooming in response to your daily checks.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Companion Chat Bubbles Overlay at the bottom
              Positioned(
                bottom: AppSpacing.xl,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Luna Empathic advice bubbles
                    LunaCard(
                      color: isDark ? AppColors.darkCard.withOpacity(0.9) : AppColors.white.withOpacity(0.9),
                      borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: AppColors.roseSoft,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('🌙', style: TextStyle(fontSize: 22)),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Luna Companion',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.rosePrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chatTips.isNotEmpty
                                      ? chatTips[0]
                                      : 'Taking deep breaths and keeping warm works wonders for cramps today 💕',
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isDark ? AppColors.darkText : AppColors.charcoal,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Companion button
                    ElevatedButton.icon(
                      onPressed: () => context.pushNamed(AppRoutes.companion),
                      icon: const Icon(Icons.forum_outlined, color: AppColors.white),
                      label: Text('Open Companion Chat', style: AppTypography.bodyMedium.copyWith(color: AppColors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rosePrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
