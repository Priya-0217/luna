import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';

class CycleStats {
  final double averageCycleLength;
  final double averagePeriodDuration;
  final double cycleStdDev;
  final bool isIrregular;

  CycleStats({
    required this.averageCycleLength,
    required this.averagePeriodDuration,
    required this.cycleStdDev,
    required this.isIrregular,
  });

  factory CycleStats.defaultStats() => CycleStats(
        averageCycleLength: 28.0,
        averagePeriodDuration: 5.0,
        cycleStdDev: 0.0,
        isIrregular: false,
      );
}

class CyclePrediction {
  final DateTime start;
  final DateTime end;

  CyclePrediction({required this.start, required this.end});

  bool get isRange => start != end;
}

class CycleCalculator {
  CycleCalculator._();

  /// Calculates the active day of the cycle.
  /// Day 1 is the first day of the last period start date.
  /// If the current date is before [lastPeriodStart], returns 1 (as absolute baseline).
  static int calculateCycleDay(DateTime lastPeriodStart, DateTime currentDate, int cycleLength) {
    final start = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final current = DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (current.isBefore(start)) {
      return 1;
    }

    final diff = current.difference(start).inDays;
    // Handle multiple cycles since lastPeriodStart
    var day = (diff % cycleLength) + 1;
    return day;
  }

  /// Calculates historical averages and standard deviation from past cycle entries.
  /// Averages are calculated over the last [count] cycles (typically 3-6).
  static CycleStats calculateStats(List<CycleEntry> entries, {int count = 6}) {
    if (entries.length < 2) {
      return CycleStats.defaultStats();
    }

    // Sort entries by date ascending
    final sorted = List<CycleEntry>.from(entries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    // Calculate cycle lengths (gap between start dates)
    final cycleLengths = <int>[];
    for (int i = 0; i < sorted.length - 1; i++) {
      final len = sorted[i + 1].startDate.difference(sorted[i].startDate).inDays;
      if (len >= 21 && len <= 45) { // Filter out unrealistic gaps
        cycleLengths.add(len);
      }
    }

    // Calculate period durations
    final periodDurations = sorted
        .where((e) => e.endDate != null)
        .map((e) => e.endDate!.difference(e.startDate).inDays)
        .where((d) => d >= 1 && d <= 10)
        .toList();

    // Use up to 'count' most recent samples
    final recentLengths = cycleLengths.reversed.take(count).toList();
    final recentDurations = periodDurations.reversed.take(count).toList();

    if (recentLengths.isEmpty) return CycleStats.defaultStats();

    final avgCycle = recentLengths.reduce((a, b) => a + b) / recentLengths.length;
    final avgPeriod = recentDurations.isEmpty 
        ? 5.0 
        : recentDurations.reduce((a, b) => a + b) / recentDurations.length;

    // Standard Deviation
    double variance = 0;
    for (var len in recentLengths) {
      variance += pow(len - avgCycle, 2);
    }
    final stdDev = sqrt(variance / recentLengths.length);

    return CycleStats(
      averageCycleLength: avgCycle,
      averagePeriodDuration: avgPeriod,
      cycleStdDev: stdDev,
      isIrregular: stdDev > 3.0, // High deviation threshold
    );
  }

  /// Categorizes the current cycle day into one of the four key phases:
  /// - Menstrual: Days 1 to [periodDuration]
  /// - Follicular: Days 1 to [ovulationDay]-1 (overlaps with menstrual)
  /// - Ovulation: [ovulationDay]-2 to [ovulationDay]+2
  /// - Luteal: [ovulationDay]+1 to end of cycle
  static CyclePhase calculatePhase({
    required int cycleDay,
    required int cycleLength,
    required int periodDuration,
  }) {
    final ovulationDay = cycleLength - 14;

    // Menstrual Phase (highest priority if overlaps)
    if (cycleDay >= 1 && cycleDay <= periodDuration) {
      return CyclePhase.menstrual;
    }

    // Ovulation Window: Day 14 ± 2
    final ovulationStart = ovulationDay - 2;
    final ovulationEnd = ovulationDay + 2;

    if (cycleDay >= ovulationStart && cycleDay <= ovulationEnd) {
      return CyclePhase.ovulation;
    }

    // Follicular Phase: Day 1 to day before ovulation
    if (cycleDay >= 1 && cycleDay < ovulationStart) {
      return CyclePhase.follicular;
    }

    // Luteal Phase: everything after Ovulation until end of cycle
    return CyclePhase.luteal;
  }

  /// Calculates the remaining days until the next period.
  static int daysUntilNextPeriod({
    required DateTime lastPeriodStart,
    required DateTime currentDate,
    required int cycleLength,
  }) {
    final start = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final current = DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (current.isBefore(start)) {
      return start.difference(current).inDays;
    }

    final diff = current.difference(start).inDays;
    final daysInCurrentCycle = diff % cycleLength;
    final remaining = cycleLength - daysInCurrentCycle;
    
    return remaining == cycleLength ? 0 : remaining;
  }

  /// Determines if the current day falls inside the fertile window (5 days before ovulation + ovulation day itself)
  static bool isFertile({
    required int cycleDay,
    required int cycleLength,
  }) {
    final ovulationDay = cycleLength - 14;
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay;

    return cycleDay >= fertileStart && cycleDay <= fertileEnd;
  }

  /// Checks if ovulation is today
  static bool isOvulationDay({
    required int cycleDay,
    required int cycleLength,
  }) {
    return cycleDay == (cycleLength - 14);
  }

  /// Predicts the next future period starting dates.
  /// If [stats.isIrregular] is true, returns a range around the expected date.
  static List<CyclePrediction> predictFuturePeriods({
    required DateTime lastPeriodStart,
    required CycleStats stats,
    int count = 3,
  }) {
    final predictions = <CyclePrediction>[];
    var currentBaseDate = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final avg = stats.averageCycleLength.round();
    final stdDev = stats.cycleStdDev.round();

    for (int i = 0; i < count; i++) {
      currentBaseDate = currentBaseDate.add(Duration(days: avg));
      
      if (stats.isIrregular) {
        // Show range based on standard deviation
        final start = currentBaseDate.subtract(Duration(days: stdDev));
        final end = currentBaseDate.add(Duration(days: stdDev));
        predictions.add(CyclePrediction(start: start, end: end));
      } else {
        // Simple date prediction (range of 1 day)
        predictions.add(CyclePrediction(start: currentBaseDate, end: currentBaseDate));
      }
    }
    return predictions;
  }
}
