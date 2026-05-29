import 'package:flutter/foundation.dart';
import 'package:her/features/cycle/providers/cycle_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/home/domain/cycle_calculator.dart';
import 'package:her/features/home/domain/cycle_phase.dart';
import 'package:her/features/self_care/providers/self_care_provider.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';

part 'dashboard_provider.g.dart';

class DashboardData {
  final String username;
  final int cycleDay;
  final CyclePhase phase;
  final int daysUntilPeriod;
  final bool isFertile;
  final double hydration;
  final double sleep;
  final int cycleLength;
  final int periodDuration;
  final bool isIrregular;
  final double cycleStdDev;
  final bool isLinked;
  final String? myLoveCode;

  DashboardData({
    required this.username,
    required this.cycleDay,
    required this.phase,
    required this.daysUntilPeriod,
    required this.isFertile,
    required this.hydration,
    required this.sleep,
    required this.cycleLength,
    required this.periodDuration,
    required this.isIrregular,
    required this.cycleStdDev,
    required this.isLinked,
    this.myLoveCode,
  });
}

@riverpod
class Dashboard extends _$Dashboard {
  @override
  FutureOr<DashboardData> build() async {
    final box = Hive.box('settings');
    debugPrint('📊 DashboardProvider: Rebuilding dashboard data...');

    // Use real username from Firebase auth, fall back to Hive cache
    final authUser = ref.watch(authProvider).valueOrNull;

    // 🚨 PROTECTION: If role is HIM, we should NOT be calculating her dashboard data here.
    if (authUser?.role == 'him') {
      debugPrint(
        '🛡️ DashboardProvider: User is HIM, returning partner-only dashboard state',
      );
      return DashboardData(
        username: authUser?.displayName ?? 'Partner',
        cycleDay: 1,
        phase: CyclePhase.follicular,
        daysUntilPeriod: 0,
        isFertile: false,
        hydration: 0,
        sleep: 0,
        cycleLength: 28,
        periodDuration: 5,
        isIrregular: false,
        cycleStdDev: 0,
        isLinked: authUser?.isLinked ?? false,
        myLoveCode: authUser?.myLoveCode,
      );
    }

    final username = authUser?.displayName.isNotEmpty == true
        ? authUser!.displayName
        : box.get('username', defaultValue: 'Love') as String;

    // Fetch all cycle entries to calculate real averages
    debugPrint('📊 DashboardProvider: Fetching cycle entries for stats...');
    final allEntries = await ref.watch(cycleEntriesStreamProvider.future);
    final stats = CycleCalculator.calculateStats(allEntries);

    final int cycleLength = stats.averageCycleLength.round();
    final int periodDuration = stats.averagePeriodDuration.round();

    debugPrint(
      '📊 DashboardProvider: Calculated stats - avgCycle: $cycleLength, avgPeriod: $periodDuration, isIrregular: ${stats.isIrregular}',
    );

    // Fetch real last period date from CycleRepository reactively
    final latestCycle = await ref.watch(cycleLatestEntryProvider.future);

    // Fallback order:
    // 1. Latest cycle entry from DB
    // 2. Saved preference in Hive
    // 3. 10 days ago (absolute last resort)
    DateTime lastPeriodDate;
    if (latestCycle != null) {
      lastPeriodDate = latestCycle.startDate;
      debugPrint(
        '📊 DashboardProvider: Using last period from DB: $lastPeriodDate',
      );
    } else {
      final dateStr = box.get('last_period_date');
      if (dateStr != null) {
        lastPeriodDate = DateTime.parse(dateStr);
        debugPrint(
          '📊 DashboardProvider: Using last period from Hive: $lastPeriodDate',
        );
      } else {
        lastPeriodDate = DateTime.now().subtract(const Duration(days: 10));
        debugPrint(
          '📊 DashboardProvider: Using fallback last period (10 days ago)',
        );
      }
    }

    // Ensure lastPeriodDate has no time component for cleaner calculations
    lastPeriodDate = DateTime(
      lastPeriodDate.year,
      lastPeriodDate.month,
      lastPeriodDate.day,
    );

    final today = DateTime.now();
    final cycleDay = CycleCalculator.calculateCycleDay(
      lastPeriodDate,
      today,
      cycleLength,
    );

    debugPrint(
      'Dashboard: Today: $today, lastPeriodDate: $lastPeriodDate, calculated cycleDay: $cycleDay',
    );

    final phase = CycleCalculator.calculatePhase(
      cycleDay: cycleDay,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
    );

    final daysUntilPeriod = CycleCalculator.daysUntilNextPeriod(
      lastPeriodStart: lastPeriodDate,
      currentDate: today,
      cycleLength: cycleLength,
    );

    final isFertile = CycleCalculator.isFertile(
      cycleDay: cycleDay,
      cycleLength: cycleLength,
    );

    // Get self-care from provider (backed by Drift + Firestore)
    final selfCare = await ref.watch(selfCareNotifierProvider.future);

    return DashboardData(
      username: username,
      cycleDay: cycleDay,
      phase: phase,
      daysUntilPeriod: daysUntilPeriod,
      isFertile: isFertile,
      hydration: selfCare.hydrationMl,
      sleep: selfCare.sleepHours,
      cycleLength: cycleLength,
      periodDuration: periodDuration,
      isIrregular: stats.isIrregular,
      cycleStdDev: stats.cycleStdDev,
      isLinked: authUser?.isLinked ?? false,
      myLoveCode: authUser?.myLoveCode,
    );
  }

  Future<void> addHydration(double amount) async {
    await ref.read(selfCareNotifierProvider.notifier).addHydration(amount);
    ref.invalidateSelf();
  }

  Future<void> setSleep(double hours) async {
    await ref.read(selfCareNotifierProvider.notifier).setSleep(hours);
    ref.invalidateSelf();
  }
}
