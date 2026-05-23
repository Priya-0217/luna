import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/core/constants/app_radius.dart';
import 'package:her/core/constants/app_spacing.dart';
import 'package:her/core/constants/app_typography.dart';
import 'package:her/core/widgets/luna_card.dart';
import 'package:her/core/widgets/luna_loading.dart';
import 'package:her/features/cycle/presentation/petal_calendar.dart';
import 'package:her/features/home/domain/cycle_calculator.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';

import 'package:her/features/cycle/domain/daily_log.dart';
import 'package:her/features/cycle/providers/daily_log_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CycleScreen extends ConsumerStatefulWidget {
  const CycleScreen({super.key});

  @override
  ConsumerState<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends ConsumerState<CycleScreen> {
  int _selectedDayOffset = 0; // offset explorer day

  Widget _buildRecentLogsSection(bool isDark) {
    final logsAsync = ref.watch(dailyLogsStreamProvider);

    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) return const SizedBox.shrink();
        final recentLog = logs.first;
        final dateStr = DateFormat('MMM dd').format(recentLog.date);

        return LunaCard(
          borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.roseSoft.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Text(_getMoodEmoji(recentLog.mood), style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last check-in: $dateStr',
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColors.darkText : AppColors.roseDark,
                      ),
                    ),
                    Text(
                      'Flow: ${recentLog.flow > 0 ? 'Logged' : 'None'} · Symptoms: ${recentLog.symptoms.isEmpty ? 'None' : recentLog.symptoms}',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'joyful': return '😊';
      case 'calm': return '😌';
      case 'tired': return '😴';
      case 'anxious': return '😰';
      case 'sad': return '😢';
      case 'irritable': return '😠';
      default: return '🌸';
    }
  }

  void _showDailyCheckIn(BuildContext context, DashboardData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DailyLogBottomSheet(data: data),
    );
  }

  String _getPhaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Your body is shed-cleaning and resetting. Give yourself warm tea, soft blankets, and zero stress. He reminds you to rest 💕';
      case CyclePhase.follicular:
        return 'Energy is rising! A perfect time to plan new projects, stretch, and nourish with fresh veggies. Your garden is blooming 🌱';
      case CyclePhase.ovulation:
        return 'You are glowing! Estrogen is peaking, boosting communication, mood, and social energy. Enjoy the sun ☀️';
      case CyclePhase.luteal:
        return 'Winding down. Progesterone dominates. You might crave chocolate or quiet movie nights. Be extra gentle with yourself 🧸';
    }
  }

  String _getPhaseTitle(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return 'Menstrual (Winter)';
      case CyclePhase.follicular:
        return 'Follicular (Spring)';
      case CyclePhase.ovulation:
        return 'Ovulation (Summer)';
      case CyclePhase.luteal:
        return 'Luteal (Autumn)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardProvider);

    return dashboardState.when(
      loading: () => const Center(child: LunaLoading(width: 200, height: 160)),
      error: (e, s) => Center(child: Text('Reloading predictions... 💕', style: AppTypography.bodyMedium)),
      data: (data) {
        final exploreDay = _selectedDayOffset == 0 ? data.cycleDay : _selectedDayOffset;
        final explorePhase = CycleCalculator.calculatePhase(
          cycleDay: exploreDay,
          cycleLength: data.cycleLength,
          periodDuration: data.periodDuration,
        );

        // Calculate the start date of the CURRENT cycle to predict future ones accurately
        final now = DateTime.now();
        final daysSinceStart = data.cycleDay - 1;
        final currentCycleStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceStart));
        
        final futureDates = CycleCalculator.predictFuturePeriods(
          lastPeriodStart: currentCycleStart,
          cycleLength: data.cycleLength,
          count: 3,
        );

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Rhythms 🌙',
                          style: AppTypography.displayLarge.copyWith(
                            color: isDark ? AppColors.darkText : AppColors.roseDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'A visual mapping of your cycle seasons.',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => _showDailyCheckIn(context, data),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.rosePrimary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.rosePrimary.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Radial floral calendar painter
                PetalCalendar(
                  currentDay: data.cycleDay,
                  cycleLength: data.cycleLength,
                  periodDuration: data.periodDuration,
                  onDaySelected: (day) {
                    setState(() => _selectedDayOffset = day);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Daily Check-in Status
                _buildRecentLogsSection(isDark),
                const SizedBox(height: AppSpacing.lg),

                // Explorer Panel card
                LunaCard(
                  borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cycle Day $exploreDay Explorer',
                            style: AppTypography.titleLarge.copyWith(
                              color: isDark ? AppColors.darkText : AppColors.roseDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.rosePrimary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              _getPhaseTitle(explorePhase),
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.rosePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getPhaseDescription(explorePhase),
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                          height: 1.5,
                        ),
                      ),
                      if (_selectedDayOffset != 0) ...[
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => setState(() => _selectedDayOffset = 0),
                          child: Text(
                            'Reset to Today',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.rosePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Future period starts predictions list
                Text(
                  'Expected Period Starts 📅',
                  style: AppTypography.titleLarge.copyWith(
                    color: isDark ? AppColors.darkText : AppColors.roseDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Column(
                  children: List.generate(futureDates.length, (index) {
                    final date = futureDates[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: LunaCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.circle, color: AppColors.phaseMenstrual, size: 10),
                                const SizedBox(width: 12),
                                Text(
                                  DateFormat('EEEE, MMMM dd').format(date),
                                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              'Cycle ${index + 2}',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DailyLogBottomSheet extends ConsumerStatefulWidget {
  final DashboardData data;
  const _DailyLogBottomSheet({required this.data});

  @override
  ConsumerState<_DailyLogBottomSheet> createState() => _DailyLogBottomSheetState();
}

class _DailyLogBottomSheetState extends ConsumerState<_DailyLogBottomSheet> {
  String _selectedMood = 'calm';
  int _flowLevel = 0;
  List<String> _selectedSymptoms = [];
  final _notesController = TextEditingController();
  bool _isLoading = true;

  final List<String> _moods = ['joyful', 'calm', 'tired', 'anxious', 'sad', 'irritable'];
  final List<String> _symptoms = ['Cramps', 'Headache', 'Bloating', 'Acne', 'Backache', 'Mood Swings'];

  @override
  void initState() {
    super.initState();
    _loadTodayLog();
  }

  Future<void> _loadTodayLog() async {
    final log = await ref.read(todayLogProvider.future);
    if (log != null && mounted) {
      setState(() {
        _selectedMood = log.mood;
        _flowLevel = log.flow;
        _selectedSymptoms = log.symptoms.split(', ').where((s) => s.isNotEmpty).toList();
        _notesController.text = log.notes ?? '';
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  Future<void> _save() async {
    final now = DateTime.now();
    final log = DailyLog(
      id: const Uuid().v4(),
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      date: DateTime(now.year, now.month, now.day),
      mood: _selectedMood,
      flow: _flowLevel,
      symptoms: _selectedSymptoms.join(', '),
      notes: _notesController.text.trim(),
      energyLevel: 3,
      createdAt: now,
    );

    try {
      await ref.read(dailyLogControllerProvider.notifier).saveLog(log);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save log: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.roseLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: const Center(child: CircularProgressIndicator(color: AppColors.rosePrimary)),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.roseLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'How are you today? 💕',
              textAlign: TextAlign.center,
              style: AppTypography.displayMedium.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Moods
            Text('Mood', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.rosePrimary : (isDark ? AppColors.darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.rosePrimary : (isDark ? AppColors.darkBorder : AppColors.roseSoft),
                      ),
                    ),
                    child: Text(
                      mood.toUpperCase(),
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.roseDark),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Flow
            Text('Flow Level', style: AppTypography.titleMedium),
            Slider(
              value: _flowLevel.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              activeColor: AppColors.rosePrimary,
              onChanged: (val) => setState(() => _flowLevel = val.toInt()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['None', 'Spot', 'Light', 'Med', 'Heavy']
                  .map((e) => Text(e, style: AppTypography.bodySmall))
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Symptoms
            Text('Symptoms', style: AppTypography.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _symptoms.map((s) {
                final isSelected = _selectedSymptoms.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: (_) => _toggleSymptom(s),
                  selectedColor: AppColors.rosePrimary.withOpacity(0.2),
                  checkmarkColor: AppColors.rosePrimary,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Save button
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Save Daily Check-in'),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
