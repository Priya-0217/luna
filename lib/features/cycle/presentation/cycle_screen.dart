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

import 'package:her/core/constants/app_illustrations.dart';
import 'package:her/core/widgets/particle_background.dart';

class CycleScreen extends ConsumerStatefulWidget {
  const CycleScreen({super.key});

  @override
  ConsumerState<CycleScreen> createState() => _CycleScreenState();
}

class _CycleScreenState extends ConsumerState<CycleScreen> {
  int _selectedDayOffset = 0; // offset explorer day
  bool _isAnimationPaused = false;
  String _logFilter = 'all'; // all, period, mood, symptoms

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

  void _showFullCalendar(BuildContext context, DashboardData data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FullCycleCalendarPopup(data: data),
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

  Widget _buildLogsSection(bool isDark, List<DailyLog> logs) {
    final filteredLogs = logs.where((log) {
      if (_logFilter == 'all') return true;
      if (_logFilter == 'mood') return log.mood.isNotEmpty;
      if (_logFilter == 'flow') return log.flow > 0;
      if (_logFilter == 'symptoms') return log.symptoms.isNotEmpty;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cycle History 📜',
              style: AppTypography.titleLarge.copyWith(
                color: isDark ? AppColors.darkText : AppColors.roseDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              initialValue: _logFilter,
              onSelected: (val) => setState(() => _logFilter = val),
              icon: Icon(Icons.filter_list, color: isDark ? AppColors.warmGray400 : AppColors.warmGray600),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'all', child: Text('All Entries')),
                const PopupMenuItem(value: 'flow', child: Text('Flow Only')),
                const PopupMenuItem(value: 'mood', child: Text('Mood Only')),
                const PopupMenuItem(value: 'symptoms', child: Text('Symptoms Only')),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (filteredLogs.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No entries found for this filter 💕',
                style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredLogs.length,
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: LunaCard(
                  padding: const EdgeInsets.all(16),
                  borderColor: isDark ? AppColors.darkBorder : AppColors.roseSoft,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.roseSoft.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Text(_getMoodEmoji(log.mood), style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, MMMM dd').format(log.date),
                              style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${log.flow > 0 ? 'Flow: ${log.flow} · ' : ''}${log.symptoms.isEmpty ? '' : 'Symptoms: ${log.symptoms}'}',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
                            ),
                            if (log.notes?.isNotEmpty == true) ...[
                              const SizedBox(height: 4),
                              Text(
                                '"${log.notes}"',
                                style: AppTypography.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.rosePrimary.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ],
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dashboardState = ref.watch(dashboardProvider);

    return dashboardState.when(
      loading: () => const Center(child: LunaLoading(width: 200, height: 160)),
      error: (e, s) => Center(child: Text('Reloading predictions... 💕', style: AppTypography.bodyMedium)),
      data: (data) {
        final logsAsync = ref.watch(currentCycleLogsProvider);
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
        
        final futurePredictions = CycleCalculator.predictFuturePeriods(
          lastPeriodStart: currentCycleStart,
          stats: CycleStats(
            averageCycleLength: data.cycleLength.toDouble(),
            averagePeriodDuration: data.periodDuration.toDouble(),
            cycleStdDev: data.cycleStdDev,
            isIrregular: data.isIrregular,
          ),
          count: 3,
        );

        return Scaffold(
          body: Stack(
            children: [
              // 1. High-performance background particle animation
              Positioned.fill(
                child: ParticleBackground(isPaused: _isAnimationPaused),
              ),
              
              SafeArea(
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
                                data.phase == CyclePhase.menstrual
                                    ? 'Period Day ${data.cycleDay} 💕'
                                    : 'Next period in ${data.daysUntilPeriod.abs()} days ✨',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark ? AppColors.warmGray400 : AppColors.rosePrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Optional pause/stop control for the animation
                              IconButton(
                                onPressed: () => setState(() => _isAnimationPaused = !_isAnimationPaused),
                                icon: Icon(
                                  _isAnimationPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                                  color: isDark ? AppColors.warmGray400 : AppColors.warmGray600,
                                ),
                                tooltip: _isAnimationPaused ? 'Play Animation' : 'Pause Animation',
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
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Radial floral calendar painter
                      PetalCalendar(
                        currentDay: data.cycleDay,
                        selectedDay: exploreDay,
                        cycleLength: data.cycleLength,
                        periodDuration: data.periodDuration,
                        size: 280,
                        onDaySelected: (day) {
                          setState(() => _selectedDayOffset = day);
                        },
                        onCenterTap: () => _showFullCalendar(context, data),
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
                                  explorePhase == CyclePhase.menstrual
                                      ? 'Period Day $exploreDay Explorer'
                                      : 'Cycle Day $exploreDay Explorer',
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

                      // 3. Real-time logs and entries section
                      logsAsync.when(
                        data: (logs) => _buildLogsSection(isDark, logs),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox.shrink(),
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
                        children: List.generate(futurePredictions.length, (index) {
                          final prediction = futurePredictions[index];
                          final isRange = prediction.isRange;
                          
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
                                        isRange 
                                          ? '${DateFormat('MMM d').format(prediction.start)} – ${DateFormat('MMM d').format(prediction.end)}'
                                          : DateFormat('EEEE, MMMM d').format(prediction.start),
                                        style: AppTypography.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? AppColors.darkText : AppColors.charcoal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isRange)
                                    Text(
                                      'Estimated',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.rosePrimary,
                                        fontStyle: FontStyle.italic,
                                      ),
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
              ),
            ],
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

class _FullCycleCalendarPopup extends StatelessWidget {
  final DashboardData data;
  const _FullCycleCalendarPopup({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final daysSinceStart = data.cycleDay - 1;
    final cycleStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceStart));
    
    // Generate dates for 3 cycles (previous, current, next)
    final startDate = cycleStart.subtract(Duration(days: data.cycleLength));
    final endDate = cycleStart.add(Duration(days: data.cycleLength * 2));

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.roseLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
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
          const SizedBox(height: 20),
          Text(
            'Your Cycle Journey 🌸',
            style: AppTypography.displayMedium.copyWith(
              color: isDark ? AppColors.darkText : AppColors.roseDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A beautiful view of your rhythms',
            style: AppTypography.bodySmall.copyWith(color: AppColors.warmGray600),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: 90, // Roughly 3 months
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                
                // Calculate cycle day for this date
                final diff = date.difference(cycleStart).inDays;
                var cycleDayForDate = (diff % data.cycleLength) + 1;
                if (cycleDayForDate <= 0) cycleDayForDate += data.cycleLength;

                final phase = CycleCalculator.calculatePhase(
                  cycleDay: cycleDayForDate,
                  cycleLength: data.cycleLength,
                  periodDuration: data.periodDuration,
                );

                final isPeriod = phase == CyclePhase.menstrual;
                final isFertile = CycleCalculator.isFertile(cycleDay: cycleDayForDate, cycleLength: data.cycleLength);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: LunaCard(
                    padding: const EdgeInsets.all(16),
                    borderColor: isToday 
                        ? AppColors.rosePrimary 
                        : (isDark ? AppColors.darkBorder : AppColors.roseSoft),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('MMM').format(date).toUpperCase(),
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.rosePrimary,
                              ),
                            ),
                            Text(
                              date.day.toString(),
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkText : AppColors.roseDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    isPeriod ? 'Period Day $cycleDayForDate' : 'Cycle Day $cycleDayForDate',
                                    style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  if (isToday) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.rosePrimary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'TODAY',
                                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getPhaseTitlePopup(phase),
                                style: AppTypography.bodySmall.copyWith(
                                  color: isPeriod ? AppColors.phaseMenstrual : (isFertile ? AppColors.phaseFollicular : AppColors.warmGray600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPeriod) const Icon(Icons.water_drop, color: AppColors.phaseMenstrual, size: 20),
                        if (isFertile && !isPeriod) const Icon(Icons.eco, color: AppColors.phaseFollicular, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rosePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Back to Rhythms'),
            ),
          ),
        ],
      ),
    );
  }

  String _getPhaseTitlePopup(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual: return 'Menstrual Phase ❄️';
      case CyclePhase.follicular: return 'Follicular Phase 🌱';
      case CyclePhase.ovulation: return 'Ovulation Phase ☀️';
      case CyclePhase.luteal: return 'Luteal Phase 🍂';
    }
  }
}
