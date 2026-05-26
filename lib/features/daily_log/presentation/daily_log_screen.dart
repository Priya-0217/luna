import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_button.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/features/daily_log/presentation/mood_selector.dart';
import 'package:her/features/daily_log/presentation/flow_slider.dart';
import 'package:her/features/daily_log/presentation/symptom_chip_grid.dart';
import 'package:her/features/cycle/domain/daily_log.dart';
import 'package:her/features/cycle/providers/daily_log_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';

class DailyLogScreen extends ConsumerStatefulWidget {
  const DailyLogScreen({super.key});

  @override
  ConsumerState<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends ConsumerState<DailyLogScreen> {
  String _selectedMood = 'happy';
  int _selectedFlow = 0;
  List<String> _selectedSymptoms = [];
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingLog();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingLog() async {
    try {
      final entry = await ref.read(todayLogProvider.future);
      if (entry != null && mounted) {
        setState(() {
          _selectedMood = entry.mood;
          _selectedFlow = entry.flow;
          _selectedSymptoms =
              entry.symptoms.split(', ').where((s) => s.isNotEmpty).toList();
          _notesController.text = entry.notes ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading existing log: $e');
    }
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final body = _notesController.text.trim();
      final now = DateTime.now();
      final log = DailyLog(
        id: const Uuid().v4(),
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        date: DateTime(now.year, now.month, now.day),
        mood: _selectedMood,
        flow: _selectedFlow,
        symptoms: _selectedSymptoms.join(', '),
        notes: body.isEmpty ? null : body,
        energyLevel: 3,
        createdAt: now,
      );

      await ref.read(dailyLogControllerProvider.notifier).saveLog(log);

      // Invalidate dashboard so changes show immediately
      ref.invalidate(dashboardProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Text('🌸  ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    'Logged with love! Take care of yourself today.',
                    style: AppTypography.bodySmall
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.rosePrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save: $e 💕 Your data is secure locally.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.roseLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Warm Character Header ──────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppColors.darkCard, AppColors.darkSurface]
                      : [AppColors.roseSoft, AppColors.roseMid.withAlpha(80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
              child: Row(
                children: [
                  // Back arrow
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? AppColors.darkText : AppColors.roseDark,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Check-in 🌸',
                          style: AppTypography.displayMedium.copyWith(
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.roseDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'How are you feeling today, love?',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark
                                ? AppColors.warmGray400
                                : AppColors.warmGray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Character illustration — peeks from top-right
                  Image.asset(
                    AppIllustrations.journaling,
                    width: 80,
                    height: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox(width: 80),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mood Selector 3×3 grid with character preview
                    LunaCard(
                      borderColor:
                          isDark ? AppColors.darkBorder : AppColors.roseSoft,
                      child: MoodSelector(
                        selectedMood: _selectedMood,
                        onMoodSelected: (mood) =>
                            setState(() => _selectedMood = mood),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Flow teardrop selector
                    LunaCard(
                      borderColor:
                          isDark ? AppColors.darkBorder : AppColors.roseSoft,
                      child: FlowSlider(
                        selectedFlow: _selectedFlow,
                        onFlowSelected: (flow) =>
                            setState(() => _selectedFlow = flow),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Symptom chip grid with character thumbnails
                    LunaCard(
                      borderColor:
                          isDark ? AppColors.darkBorder : AppColors.roseSoft,
                      child: SymptomChipGrid(
                        selectedSymptoms: _selectedSymptoms,
                        onSymptomsChanged: (symptoms) =>
                            setState(() => _selectedSymptoms = symptoms),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Notes text field
                    LunaCard(
                      borderColor:
                          isDark ? AppColors.darkBorder : AppColors.roseSoft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppIllustrations.journaling,
                                width: 32,
                                height: 32,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.edit_note,
                                        color: AppColors.rosePrimary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Secret Thoughts & Notes 📝',
                                style: AppTypography.titleLarge.copyWith(
                                  color: isDark
                                      ? AppColors.darkText
                                      : AppColors.roseDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _notesController,
                            maxLines: 4,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.charcoal,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Any thoughts, cravings, or private notes... 🌸',
                              hintStyle: AppTypography.bodySmall
                                  .copyWith(color: AppColors.warmGray400),
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Save button
                    LunaButton(
                      text: 'Seal Log with Love 💕',
                      isLoading: _isSaving,
                      onPressed: _save,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
