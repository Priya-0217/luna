import 'package:flutter_test/flutter_test.dart';
import 'package:her/features/home/domain/cycle_calculator.dart';
import 'package:her/features/home/domain/cycle_phase.dart';

void main() {
  group('CycleCalculator Tests', () {
    final lastPeriodStart = DateTime(2026, 5, 1); // May 1st, 2026

    test('calculateCycleDay calculates correct current day', () {
      final today = DateTime(2026, 5, 8); // Day 8 of cycle
      final day = CycleCalculator.calculateCycleDay(lastPeriodStart, today);
      expect(day, equals(8));
    });

    test('calculateCycleDay returns Day 1 for dates before lastPeriodStart', () {
      final earlier = DateTime(2026, 4, 30);
      final day = CycleCalculator.calculateCycleDay(lastPeriodStart, earlier);
      expect(day, equals(1));
    });

    test('calculatePhase splits stages correctly', () {
      // 28-day cycle with 5 days period duration
      // Menstrual Phase (Day 1 - 5)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 3, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.menstrual),
      );

      // Follicular Phase (Day 6 - 10)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 8, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.follicular),
      );

      // Ovulation Phase (Day 11 - 15, centered on Day 14)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 14, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.ovulation),
      );

      // Luteal Phase (Day 16 - 28)
      expect(
        CycleCalculator.calculatePhase(cycleDay: 20, cycleLength: 28, periodDuration: 5),
        equals(CyclePhase.luteal),
      );
    });

    test('daysUntilNextPeriod computes offsets correctly', () {
      final today = DateTime(2026, 5, 20); // 19 days since May 1st
      final days = CycleCalculator.daysUntilNextPeriod(
        lastPeriodStart: lastPeriodStart,
        currentDate: today,
        cycleLength: 28,
      );
      expect(days, equals(9)); // 28 - 19 = 9 days remaining
    });

    test('isFertile reports true for the 6-day fertile window', () {
      // For a 28-day cycle, ovulation is Day 14 (28 - 14)
      // Fertile starts on Day 9 (14 - 5) and ends on Day 14
      expect(CycleCalculator.isFertile(cycleDay: 8, cycleLength: 28), isFalse);
      expect(CycleCalculator.isFertile(cycleDay: 9, cycleLength: 28), isTrue);
      expect(CycleCalculator.isFertile(cycleDay: 14, cycleLength: 28), isTrue);
      expect(CycleCalculator.isFertile(cycleDay: 15, cycleLength: 28), isFalse);
    });

    test('isOvulationDay matches exact ovulation index', () {
      expect(CycleCalculator.isOvulationDay(cycleDay: 14, cycleLength: 28), isTrue);
      expect(CycleCalculator.isOvulationDay(cycleDay: 13, cycleLength: 28), isFalse);
    });

    test('predictFuturePeriods outputs predictions spaced by cycleLength', () {
      final predictions = CycleCalculator.predictFuturePeriods(
        lastPeriodStart: lastPeriodStart,
        cycleLength: 28,
        count: 2,
      );
      expect(predictions.length, equals(2));
      expect(predictions[0], equals(DateTime(2026, 5, 29)));
      expect(predictions[1], equals(DateTime(2026, 6, 26)));
    });
  });
}
