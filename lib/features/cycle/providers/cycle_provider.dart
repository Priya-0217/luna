import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/cycle/data/cycle_repository.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';

part 'cycle_provider.g.dart';

@riverpod
class CycleHistory extends _$CycleHistory {
  @override
  FutureOr<List<CycleEntry>> build() async {
    return ref.watch(cycleRepositoryProvider).getAllEntries();
  }

  Future<void> startPeriod() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(cycleRepositoryProvider).startPeriod();
      return ref.read(cycleRepositoryProvider).getAllEntries();
    });
  }

  Future<void> endPeriod() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(cycleRepositoryProvider).endPeriod();
      return ref.read(cycleRepositoryProvider).getAllEntries();
    });
  }
}

@riverpod
Future<CycleEntry?> latestCycleEntry(LatestCycleEntryRef ref) async {
  return ref.watch(cycleRepositoryProvider).getLatestEntry();
}
