import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:her/features/daily_log/data/log_repository.dart';
import 'package:her/features/daily_log/domain/daily_log_entry.dart';
import 'package:her/features/mood_garden/data/garden_repository.dart';
import 'package:her/features/mood_garden/providers/garden_provider.dart';

part 'daily_log_provider.g.dart';

@riverpod
class DailyLog extends _$DailyLog {
  @override
  FutureOr<DailyLogEntry?> build() async {
    return ref.watch(logRepositoryProvider).getTodayLog();
  }

  Future<void> save({
    required String mood,
    required int flowLevel,
    required List<String> symptoms,
    String? notes,
    required int energyLevel,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final entry = DailyLogEntry(
      id: const Uuid().v4(),
      userId: uid,
      date: DateTime.now(),
      mood: mood,
      flowLevel: flowLevel,
      symptoms: symptoms,
      notes: notes,
      energyLevel: energyLevel,
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(logRepositoryProvider).saveLog(entry);

      // Update garden after log is saved
      final garden = await ref.read(gardenRepositoryProvider).getState();
      await ref.read(gardenRepositoryProvider).onDailyLogSaved(garden);
      ref.invalidate(gardenStateProvider);

      return entry;
    });
  }
}

@riverpod
Future<List<DailyLogEntry>> recentLogs(RecentLogsRef ref,
    {int days = 30}) async {
  return ref.watch(logRepositoryProvider).getRecentLogs(days: days);
}
