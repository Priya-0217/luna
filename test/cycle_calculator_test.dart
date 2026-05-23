import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:her/features/home/domain/cycle_calculator.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';

void main() {
  group('CycleCalculator Tests', () {
    final lastPeriodStart = DateTime(2026, 5, 1); // May 1st, 2026

    test('calculateCycleDay calculates correct current day', () {
      final today = DateTime(2026, 5, 8); // Day 8 of cycle
      final day = CycleCalculator.calculateCycleDay(lastPeriodStart, today, 28);
      expect(day, equals(8));
    });

    test('calculateStats computes rolling average and stdDev', () {
      final entries = [
        CycleEntry(
          id: '1',
          userId: 'u1',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 6), // 5 days
          createdAt: DateTime.now(),
        ),
        CycleEntry(
          id: '2',
          userId: 'u1',
          startDate: DateTime(2026, 1, 31), // 30 day cycle
          endDate: DateTime(2026, 2, 4), // 4 days
          createdAt: DateTime.now(),
        ),
        CycleEntry(
          id: '3',
          userId: 'u1',
          startDate: DateTime(2026, 2, 28), // 28 day cycle
          endDate: DateTime(2026, 3, 5), // 5 days
          createdAt: DateTime.now(),
        ),
      ];

      final stats = CycleCalculator.calculateStats(entries);
      
      // (30 + 28) / 2 = 29
      expect(stats.averageCycleLength, equals(29.0));
      // (5 + 4 + 5) / 3 = 4.66
      expect(stats.averagePeriodDuration, closeTo(4.66, 0.1));
      // Variance: ((30-29)^2 + (28-29)^2) / 2 = (1 + 1) / 2 = 1. StdDev = sqrt(1) = 1
      expect(stats.cycleStdDev, equals(1.0));
      expect(stats.isIrregular, isFalse);
    });

    test('calculatePhase splits stages correctly', () {
      // 28-day cycle with 5 days period duration
      // Menstrual Phase (Day 1 - 5)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 3, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.menstrual),
      );

      // Follicular Phase (Day 6 - 11) - Day 12 is Ovulation Start (14-2)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 8, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.follicular),
      );

      // Ovulation Phase (Day 12 - 16, centered on Day 14)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 14, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.ovulation),
      );

      // Luteal Phase (Day 17 - 28)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 20, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.luteal),
      );
    });

    test('isFertile reports true for the 6-day fertile window', () {
      // For a 28-day cycle, ovulation is Day 14 (28 - 14)
      // Fertile starts on Day 9 (14 - 5) and ends on Day 14
      expect(CycleCalculator.isFertile(cycleDay: 8, cycleLength: 28), isFalse);
      expect(CycleCalculator.isFertile(cycleDay: 9, cycleLength: 28), isTrue);
      expect(CycleCalculator.isFertile(cycleDay: 14, cycleLength: 28), isTrue);
      expect(CycleCalculator.isFertile(cycleDay: 15, cycleLength: 28), isFalse);
    });

    test('predictFuturePeriods handles irregularity with ranges', () {
      final regularStats = CycleStats(
        averageCycleLength: 28.0,
        averagePeriodDuration: 5.0,
        cycleStdDev: 1.0,
        isIrregular: false,
      );

      final irregularStats = CycleStats(
        averageCycleLength: 30.0,
        averagePeriodDuration: 5.0,
        cycleStdDev: 5.0,
        isIrregular: true,
      );

      final regularPredictions = CycleCalculator.predictFuturePeriods(
        lastPeriodStart: lastPeriodStart,
        stats: regularStats,
        count: 1,
      );
      
      // Regular: May 1 + 28 days = May 29
      expect(regularPredictions[0].start, equals(DateTime(2026, 5, 29)));
      expect(regularPredictions[0].end, equals(DateTime(2026, 5, 29)));
      expect(regularPredictions[0].isRange, isFalse);

      final irregularPredictions = CycleCalculator.predictFuturePeriods(
        lastPeriodStart: lastPeriodStart,
        stats: irregularStats,
        count: 1,
      );

      // Irregular: May 1 + 30 days = May 31. Range ± 5 days = May 26 to June 5
      expect(irregularPredictions[0].start, equals(DateTime(2026, 5, 26)));
      expect(irregularPredictions[0].end, equals(DateTime(2026, 6, 5)));
      expect(irregularPredictions[0].isRange, isTrue);
    });
  });
}
