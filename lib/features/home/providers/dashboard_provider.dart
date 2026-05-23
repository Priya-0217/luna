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
  });
}

@riverpod
class Dashboard extends _$Dashboard {
  @override
  FutureOr<DashboardData> build() async {
    final box = Hive.box('settings');

    // Use real username from Firebase auth, fall back to Hive cache
    final authUser = ref.watch(authProvider).valueOrNull;
    final username = authUser?.displayName.isNotEmpty == true
        ? authUser!.displayName
        : box.get('username', defaultValue: 'Love') as String;

    final int cycleLength = authUser?.cycleAverageLength ?? 28;
    final int periodDuration = authUser?.periodAverageLength ?? 5;
    
    // Fetch real last period date from CycleRepository
    final cycleRepo = ref.read(cycleRepositoryProvider);
    final latestCycle = await cycleRepo.getLatestEntry();
    
    final lastPeriodDate = latestCycle?.startDate ?? 
        DateTime.now().subtract(const Duration(days: 10));

    final today = DateTime.now();
    final cycleDay =
        CycleCalculator.calculateCycleDay(lastPeriodDate, today, cycleLength);

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
