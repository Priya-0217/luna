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
import 'package:her/features/home/domain/cycle_phase.dart' as home_phase;
import 'package:her/features/cycle/domain/cycle_phase.dart' as cycle_phase;
import 'package:her/features/home/providers/dashboard_provider.dart';
import 'package:her/features/mood_garden/presentation/garden_canvas.dart';
import 'package:her/core/role/app_role.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/him/providers/partner_data_provider.dart';
import 'package:her/features/cycle/utils/cycle_calculator.dart' as cycle_calc;

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

  home_phase.CyclePhase _mapCyclePhase(cycle_phase.CyclePhase phase) {
    switch (phase) {
      case cycle_phase.CyclePhase.menstrual:
        return home_phase.CyclePhase.menstrual;
      case cycle_phase.CyclePhase.follicular:
        return home_phase.CyclePhase.follicular;
      case cycle_phase.CyclePhase.ovulation:
        return home_phase.CyclePhase.ovulation;
      case cycle_phase.CyclePhase.luteal:
        return home_phase.CyclePhase.luteal;
    }
  }

  Widget _buildGardenView({
    required BuildContext context,
    required bool isDark,
    required AppRole role,
    required home_phase.CyclePhase phase,
    required int cycleDay,
    required String activeMood,
    required int flowersBloom,
    required List<String> chatTips,
    String? partnerName,
  }) {
    final isHim = role == AppRole.him;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : (isHim ? AppColors.slateBlueLight : AppColors.roseLight),
      body: Stack(
        children: [
          // 1. Full Bleed Animated Custom Painter Garden Canvas
          Positioned.fill(
            child: GardenCanvas(mood: activeMood, flowersCount: flowersBloom),
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
                          isHim ? 'Her Garden 🌿' : 'Your Garden 🌿',
                          style: AppTypography.displayLarge.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : (isHim
                                      ? AppColors.slateBlueDark
                                      : AppColors.roseDark),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard.withOpacity(0.8)
                                : AppColors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : (isHim
                                        ? AppColors.slateBlueSoft
                                        : AppColors.roseSoft),
                            ),
                          ),
                          child: Text(
                            _getMoodLabel(activeMood),
                            style: AppTypography.bodySmall.copyWith(
                              color: isHim
                                  ? AppColors.slateBluePrimary
                                  : AppColors.rosePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      isHim
                          ? 'Blooming in response to her daily checks.'
                          : 'Blooming in response to your daily checks.',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.warmGray400
                            : AppColors.warmGray600,
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
                  color: isDark
                      ? AppColors.darkCard.withOpacity(0.9)
                      : AppColors.white.withOpacity(0.9),
                  borderColor: isDark
                      ? AppColors.darkBorder
                      : (isHim ? AppColors.slateBlueSoft : AppColors.roseSoft),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isHim
                              ? AppColors.slateBlueSoft
                              : AppColors.roseSoft,
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
                                color: isHim
                                    ? AppColors.slateBluePrimary
                                    : AppColors.rosePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isHim
                                  ? 'A peaceful chat room where you can get immediate, loving suggestions on how to care for her today.'
                                  : (chatTips.isNotEmpty
                                        ? chatTips[0]
                                        : 'Taking deep breaths and keeping warm works wonders for cramps today 💕'),
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark
                                    ? AppColors.darkText
                                    : AppColors.charcoal,
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
                  icon: const Icon(
                    Icons.forum_outlined,
                    color: AppColors.white,
                  ),
                  label: Text(
                    'Open Companion Chat',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isHim
                        ? AppColors.slateBluePrimary
                        : AppColors.rosePrimary,
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🌿 MoodGarden: Building Screen...');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final role = ref.watch(authProvider).valueOrNull?.role == 'him'
        ? AppRole.him
        : AppRole.her;

    if (role == AppRole.him) {
      debugPrint('🌿 MoodGarden: Loading view for role: HIM');
      final partnerProfileAsync = ref.watch(partnerProfileProvider);
      final partnerEntriesAsync = ref.watch(partnerCycleEntriesProvider);

      return partnerProfileAsync.when(
        loading: () =>
            const Center(child: LunaLoading(width: 200, height: 160)),
        error: (e, s) {
          debugPrint('❌ MoodGarden: Partner profile error: $e');
          return const Center(child: Text('Letting the flowers grow... 💕'));
        },
        data: (partner) {
          if (partner == null) {
            debugPrint('🌿 MoodGarden: No partner linked yet');
            return const Scaffold(
              body: Center(child: Text('No partner linked yet.')),
            );
          }
          return partnerEntriesAsync.when(
            loading: () =>
                const Center(child: LunaLoading(width: 200, height: 160)),
            error: (e, s) {
              debugPrint(
                '⚠️ MoodGarden: Partner entries restricted or error: $e',
              );
              // Fallback to a peaceful default garden if cycle data is private
              return _buildGardenView(
                context: context,
                isDark: isDark,
                role: role,
                phase: home_phase.CyclePhase.follicular,
                cycleDay: 1,
                activeMood: 'happy',
                flowersBloom: 5,
                chatTips: SuggestionService.forPhase(
                  home_phase.CyclePhase.follicular,
                ),
                partnerName: partner.displayName,
              );
            },
            data: (entries) {
              final stats = cycle_calc.CycleCalculator.calculate(entries);
              final homePhase = _mapCyclePhase(stats.phase);
              final int flowersBloom = (stats.dayOfCycle % 6) + 1;
              final chatTips = SuggestionService.forPhase(homePhase);

              debugPrint(
                '🌿 MoodGarden: HIM View - Phase: ${homePhase.name}, Day: ${stats.dayOfCycle}, Flowers: $flowersBloom',
              );

              return _buildGardenView(
                context: context,
                isDark: isDark,
                role: role,
                phase: homePhase,
                cycleDay: stats.dayOfCycle,
                activeMood: 'happy', // Default peaceful
                flowersBloom: flowersBloom,
                chatTips: chatTips,
                partnerName: partner.displayName,
              );
            },
          );
        },
      );
    } else {
      debugPrint('🌿 MoodGarden: Loading view for role: HER');
      final dashboardState = ref.watch(dashboardProvider);
      return dashboardState.when(
        loading: () =>
            const Center(child: LunaLoading(width: 200, height: 160)),
        error: (e, s) {
          debugPrint('❌ MoodGarden: Dashboard state error: $e');
          return const Center(child: Text('Letting the flowers grow... 💕'));
        },
        data: (data) {
          final int flowersBloom = (data.cycleDay % 6) + 1;
          final chatTips = SuggestionService.forPhase(data.phase);

          debugPrint(
            '🌿 MoodGarden: HER View - Phase: ${data.phase.name}, Day: ${data.cycleDay}, Flowers: $flowersBloom',
          );

          return _buildGardenView(
            context: context,
            isDark: isDark,
            role: role,
            phase: data.phase,
            cycleDay: data.cycleDay,
            activeMood: 'happy', // Default peaceful
            flowersBloom: flowersBloom,
            chatTips: chatTips,
          );
        },
      );
    }
  }
}
