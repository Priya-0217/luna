import 'package:her/features/cycle/data/daily_log_repository.dart';
import 'package:her/features/cycle/domain/daily_log.dart';
import 'package:her/features/home/providers/dashboard_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_log_provider.g.dart';

@riverpod
Stream<List<DailyLog>> dailyLogsStream(DailyLogsStreamRef ref) {
  return ref.watch(dailyLogRepositoryProvider).watchDailyLogs();
}

@riverpod
Stream<List<DailyLog>> currentCycleLogs(CurrentCycleLogsRef ref) {
  final dashboardAsync = ref.watch(dashboardProvider);
  final logsAsync = ref.watch(dailyLogsStreamProvider);

  return dashboardAsync.when(
    data: (data) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final cycleStart = today.subtract(Duration(days: data.cycleDay - 1));

      return logsAsync.when(
        data: (logs) {
          final filtered = logs.where((log) => 
            log.date.isAfter(cycleStart.subtract(const Duration(seconds: 1)))
          ).toList();
          return Stream.value(filtered);
        },
        loading: () => const Stream.empty(),
        error: (e, s) => Stream.error(e, s),
      );
    },
    loading: () => const Stream.empty(),
    error: (e, s) => Stream.error(e, s),
  );
}

@riverpod
class DailyLogController extends _$DailyLogController {
  @override
  FutureOr<void> build() async {}

  Future<void> saveLog(DailyLog log) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(dailyLogRepositoryProvider).saveDailyLog(log);
    });
  }
}

@riverpod
Future<DailyLog?> todayLog(TodayLogRef ref) async {
  final now = DateTime.now();
  final date = DateTime(now.year, now.month, now.day);
  return ref.watch(dailyLogRepositoryProvider).getDailyLog(date);
}
