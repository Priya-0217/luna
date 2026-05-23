import 'package:her/features/cycle/data/daily_log_repository.dart';
import 'package:her/features/cycle/domain/daily_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'daily_log_provider.g.dart';

@riverpod
Stream<List<DailyLog>> dailyLogsStream(DailyLogsStreamRef ref) {
  return ref.watch(dailyLogRepositoryProvider).watchDailyLogs();
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
