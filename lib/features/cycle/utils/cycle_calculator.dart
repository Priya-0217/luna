import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:her/core/constants/app_colors.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';
import 'package:her/features/cycle/domain/cycle_phase.dart';

class CycleStats {
  final CyclePhase phase;
  final int dayOfCycle;
  final int daysUntilPeriod;
  final int cycleLength;
  final double phaseProgress;

  CycleStats({
    required this.phase,
    required this.dayOfCycle,
    required this.daysUntilPeriod,
    this.cycleLength = 28,
    required this.phaseProgress,
  });
}

class CycleStatsSummary {
  final double averageCycleLength;
  final double averagePeriodDuration;
  final bool isIrregular;
  final double cycleStdDev;

  CycleStatsSummary({
    required this.averageCycleLength,
    required this.averagePeriodDuration,
    required this.isIrregular,
    required this.cycleStdDev,
  });
}

class CycleCalculator {
  static CycleStats calculate(List<CycleEntry> entries) {
    if (entries.isEmpty) {
      return CycleStats(
        phase: CyclePhase.follicular,
        dayOfCycle: 1,
        daysUntilPeriod: 14,
        phaseProgress: 0.1,
      );
    }

    // Sort descending to get the latest entry first
    final sorted = [...entries]..sort((a, b) => b.startDate.compareTo(a.startDate));
    final lastPeriod = sorted.first;

    final dayOfCycle = calculateCycleDay(lastPeriod.startDate, DateTime.now(), 28);

    CyclePhase phase;
    double progress;

    if (dayOfCycle <= 5) {
      phase = CyclePhase.menstrual;
      progress = dayOfCycle / 5;
    } else if (dayOfCycle <= 12) {
      phase = CyclePhase.follicular;
      progress = (dayOfCycle - 5) / 7;
    } else if (dayOfCycle <= 16) {
      phase = CyclePhase.ovulation;
      progress = (dayOfCycle - 12) / 4;
    } else {
      phase = CyclePhase.luteal;
      progress = (dayOfCycle - 16) / 12;
    }

    return CycleStats(
      phase: phase,
      dayOfCycle: dayOfCycle,
      daysUntilPeriod: (28 - dayOfCycle).clamp(0, 28),
      phaseProgress: progress.clamp(0.0, 1.0),
    );
  }

  static int calculateCycleDay(DateTime start, DateTime now, int cycleLength) {
    final diff = now.difference(start).inDays + 1;
    if (diff <= 0) return 1;
    return ((diff - 1) % cycleLength) + 1;
  }

  static CyclePhase calculatePhase({
    required int cycleDay,
    required int cycleLength,
    required int periodDuration,
  }) {
    final ovulationDay = (cycleLength - 14).clamp(1, cycleLength);

    if (cycleDay <= periodDuration) return CyclePhase.menstrual;
    if (cycleDay < ovulationDay - 2) return CyclePhase.follicular;
    if (cycleDay <= ovulationDay + 2) return CyclePhase.ovulation;
    return CyclePhase.luteal;
  }

  static int daysUntilNextPeriod({
    required DateTime lastPeriodStart,
    required DateTime currentDate,
    required int cycleLength,
  }) {
    final cycleDay = calculateCycleDay(
      lastPeriodStart,
      currentDate,
      cycleLength,
    );
    return (cycleLength - cycleDay).clamp(0, cycleLength);
  }

  static bool isFertile({required int cycleDay, required int cycleLength}) {
    final ovulationDay = (cycleLength - 14).clamp(1, cycleLength);
    final fertileStart = (ovulationDay - 5).clamp(1, cycleLength);
    final fertileEnd = (ovulationDay + 1).clamp(1, cycleLength);
    return cycleDay >= fertileStart && cycleDay <= fertileEnd;
  }

  static CycleStatsSummary calculateStats(List<CycleEntry> entries) {
    if (entries.isEmpty) {
      return CycleStatsSummary(
        averageCycleLength: 28,
        averagePeriodDuration: 5,
        isIrregular: false,
        cycleStdDev: 0,
      );
    }

    final sorted = [...entries]..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cycleLengths = <int>[];
    for (var i = 1; i < sorted.length; i++) {
      final diff = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      if (diff > 0) cycleLengths.add(diff);
    }

    final avgCycle = cycleLengths.isEmpty
        ? 28.0
        : cycleLengths.reduce((a, b) => a + b) / cycleLengths.length;

    double stdDev = 0;
    if (cycleLengths.length > 1) {
      final mean = avgCycle;
      final variance =
          cycleLengths
              .map((len) => (len - mean) * (len - mean))
              .reduce((a, b) => a + b) /
          cycleLengths.length;
      stdDev = variance.isFinite ? math.sqrt(variance) : 0;
    }

    final durations = <int>[];
    for (final entry in sorted) {
      if (entry.endDate != null) {
        final diff = entry.endDate!.difference(entry.startDate).inDays + 1;
        if (diff > 0) durations.add(diff);
      }
    }

    final avgPeriod = durations.isEmpty
        ? 5.0
        : durations.reduce((a, b) => a + b) / durations.length;

    final irregular = stdDev >= 2.5;

    return CycleStatsSummary(
      averageCycleLength: avgCycle,
      averagePeriodDuration: avgPeriod,
      isIrregular: irregular,
      cycleStdDev: stdDev,
    );
  }

  static Color getPhaseColor(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return AppColors.phaseMenstrual;
      case CyclePhase.follicular:
        return AppColors.phaseFollicular;
      case CyclePhase.ovulation:
        return AppColors.phaseOvulation;
      case CyclePhase.luteal:
        return AppColors.phaseLuteal;
    }
  }

  static String getPhaseDescription(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return "Your body is resting and renewing.";
      case CyclePhase.follicular:
        return "Energy is rising, a time for new beginnings.";
      case CyclePhase.ovulation:
        return "You are at your peak vibrancy and connection.";
      case CyclePhase.luteal:
        return "A time for inward turning and extra self-care.";
    }
  }

  static List<Map<String, dynamic>> getSupportTips(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return [
          {
            'title': 'Rest',
            'desc': 'Prioritize 8+ hours of sleep.',
            'icon': Icons.nightlight,
          },
          {
            'title': 'Hydrate',
            'desc': 'Warm teas and plenty of water.',
            'icon': Icons.water_drop,
          },
        ];
      case CyclePhase.follicular:
        return [
          {
            'title': 'Plan',
            'desc': 'Great time for new projects.',
            'icon': Icons.lightbulb,
          },
          {
            'title': 'Move',
            'desc': 'Try a new cardio workout.',
            'icon': Icons.bolt,
          },
        ];
      case CyclePhase.ovulation:
        return [
          {
            'title': 'Socialize',
            'desc': 'You are naturally more magnetic now.',
            'icon': Icons.people,
          },
          {
            'title': 'High Intensity',
            'desc': 'Strength training peaks here.',
            'icon': Icons.fitness_center,
          },
        ];
      case CyclePhase.luteal:
        return [
          {
            'title': 'Grace',
            'desc': 'Be kind to your body and emotions.',
            'icon': Icons.favorite,
          },
          {
            'title': 'Magnesium',
            'desc': 'Helpful for mood and muscle relaxation.',
            'icon': Icons.spa,
          },
        ];
    }
  }
}
