import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/features/self_care/providers/self_care_provider.dart';

class SelfCareScreen extends ConsumerStatefulWidget {
  const SelfCareScreen({super.key});

  @override
  ConsumerState<SelfCareScreen> createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends ConsumerState<SelfCareScreen> {
  // Local state for instant slider feedback before async save
  double? _localSleepHours;
  double? _localHydration;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selfCareState = ref.watch(selfCareNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      appBar: AppBar(
        title: Text('Self-Care Oasis 🛁', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: selfCareState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.rosePrimary),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                'Error loading self-care data 💕\n$error',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (data) {
            // Use local overrides for instant feedback, fall back to DB values
            final hydration = _localHydration ?? data.hydrationMl;
            final sleep = _localSleepHours ?? data.sleepHours;

            // Sync back from DB when provider refreshes (e.g. first load)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_localHydration == null && data.hydrationMl > 0) {
                setState(() => _localHydration = data.hydrationMl);
              }
              if (_localSleepHours == null && data.sleepHours > 0) {
                setState(() => _localSleepHours = data.sleepHours);
              }
            });

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Nourish Your Body 💕',
                    style: AppTypography.displayMedium.copyWith(
                      color: isDark ? AppColors.darkText : AppColors.roseDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Small acts of care make a big difference.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.warmGray400
                          : AppColors.warmGray600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Hydration Card ────────────────────────────────────────
                  LunaCard(
                    borderColor:
                        isDark ? AppColors.darkBorder : AppColors.roseSoft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hydration 💧',
                                style: AppTypography.titleLarge),
                            Text(
                              '${hydration.toInt()} / 2000 ml',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.rosePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (hydration / 2000).clamp(0.0, 1.0),
                            backgroundColor: isDark
                                ? AppColors.darkCard
                                : AppColors.roseSoft,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.lightBlueAccent),
                            minHeight: 14,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          hydration >= 2000
                              ? '🎉 Daily goal reached! You\'re glowing!'
                              : '${(2000 - hydration).toInt()} ml more to reach your daily goal',
                          style: AppTypography.bodySmall.copyWith(
                            color: hydration >= 2000
                                ? AppColors.rosePrimary
                                : (isDark
                                    ? AppColors.warmGray400
                                    : AppColors.warmGray600),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: _HydrationButton(
                                label: '+250 ml',
                                emoji: '💧',
                                onTap: () => _addHydration(250),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _HydrationButton(
                                label: '+500 ml',
                                emoji: '🥤',
                                onTap: () => _addHydration(500),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _HydrationButton(
                                label: '+1000 ml',
                                emoji: '🍶',
                                onTap: () => _addHydration(1000),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Sleep Card ─────────────────────────────────────────────
                  LunaCard(
                    borderColor:
                        isDark ? AppColors.darkBorder : AppColors.roseSoft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Sleep Tracker 🌙',
                                style: AppTypography.titleLarge),
                            Text(
                              '${sleep.toStringAsFixed(1)} hrs',
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.rosePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Slider(
                          value: sleep.clamp(0.0, 14.0),
                          min: 0,
                          max: 14,
                          divisions: 28,
                          label: '${sleep.toStringAsFixed(1)} hrs',
                          activeColor: AppColors.rosePrimary,
                          inactiveColor:
                              isDark ? AppColors.darkCard : AppColors.roseSoft,
                          onChanged: (val) {
                            // Update local state immediately for responsive UI
                            setState(() => _localSleepHours = val);
                          },
                          onChangeEnd: (val) {
                            // Save to DB when the user lifts their finger
                            HapticFeedback.selectionClick();
                            ref
                                .read(selfCareNotifierProvider.notifier)
                                .setSleep(val);
                          },
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          _getSleepAdvice(sleep),
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.warmGray400
                                : AppColors.warmGray600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Daily Tip ──────────────────────────────────────────────
                  LunaCard(
                    color: isDark
                        ? AppColors.darkCard
                        : AppColors.roseSoft.withOpacity(0.5),
                    borderColor:
                        isDark ? AppColors.darkBorder : AppColors.roseSoft,
                    child: Row(
                      children: [
                        const Text('✨', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gentle Reminder',
                                  style: AppTypography.titleMedium),
                              const SizedBox(height: 4),
                              Text(
                                'Warm baths, gentle yoga, and your favourite comfort foods can ease period cramps. Be kind to yourself today 💕',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.warmGray400
                                      : AppColors.warmGray600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _addHydration(double amount) {
    HapticFeedback.lightImpact();
    final current = _localHydration ?? 0.0;
    setState(() => _localHydration = (current + amount).clamp(0, 9999));
    ref.read(selfCareNotifierProvider.notifier).addHydration(amount);
  }

  String _getSleepAdvice(double hours) {
    if (hours == 0) return 'Track how many hours you slept last night 🌙';
    if (hours < 6) return 'You need more rest 💤 Aim for at least 7-8 hours.';
    if (hours <= 9) return 'Perfect! Your body is well-rested 🌟';
    return 'A little extra rest during your period is completely okay 💕';
  }
}

class _HydrationButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;

  const _HydrationButton({
    required this.label,
    required this.emoji,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.roseSoft.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.rosePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
