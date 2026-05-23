import 'package:her/features/home/domain/cycle_phase.dart';

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

  /// Categorizes the current cycle day into one of the four key phases:
  /// - Menstrual: Days 1 to [periodDuration]
  /// - Follicular: Day after menstrual to 4 days before ovulation (typically Day [periodDuration]+1 to Day 10)
  /// - Ovulation: 3 days before ovulation to 1 day after ovulation (typically Days 11 to 15, centered on Day [cycleLength] - 14)
  /// - Luteal: Day after ovulation to next cycle start
  static CyclePhase calculatePhase({
    required int cycleDay,
    required int cycleLength,
    required int periodDuration,
  }) {
    // Ovulation occurs approximately 14 days before the end of the cycle
    final ovulationDay = cycleLength - 14;

    // Menstrual Phase
    if (cycleDay >= 1 && cycleDay <= periodDuration) {
      return CyclePhase.menstrual;
    }

    // Ovulation Window: 3 days before ovulation to 1 day after
    final ovulationStart = ovulationDay - 3;
    final ovulationEnd = ovulationDay + 1;

    if (cycleDay >= ovulationStart && cycleDay <= ovulationEnd) {
      return CyclePhase.ovulation;
    }

    // Follicular Phase: everything between Menstrual and Ovulation
    if (cycleDay > periodDuration && cycleDay < ovulationStart) {
      return CyclePhase.follicular;
    }

    // Luteal Phase: everything after Ovulation until end of cycle
    return CyclePhase.luteal;
  }

  /// Calculates the remaining days until the next period.
  /// If today is past the expected start date, returns negative values (irregular/overdue days).
  static int daysUntilNextPeriod({
    required DateTime lastPeriodStart,
    required DateTime currentDate,
    required int cycleLength,
  }) {
    final start = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final current = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final nextPeriodStart = start.add(Duration(days: cycleLength));

    return nextPeriodStart.difference(current).inDays;
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

  /// Predicts the next 3 future period starting dates using rolling historical averages.
  static List<DateTime> predictFuturePeriods({
    required DateTime lastPeriodStart,
    required int cycleLength,
    int count = 3,
  }) {
    final predictions = <DateTime>[];
    var currentPrediction = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);

    for (int i = 0; i < count; i++) {
      currentPrediction = currentPrediction.add(Duration(days: cycleLength));
      predictions.add(currentPrediction);
    }
    return predictions;
  }
}
