import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/self_care/data/self_care_repository.dart';

part 'self_care_provider.g.dart';

class SelfCareData {
  const SelfCareData({required this.hydrationMl, required this.sleepHours});
  final double hydrationMl;
  final double sleepHours;
}

@riverpod
class SelfCareNotifier extends _$SelfCareNotifier {
  @override
  FutureOr<SelfCareData> build() async {
    final repo = ref.watch(selfCareRepositoryProvider);
    final hydration = await repo.getHydrationToday();
    final sleep = await repo.getSleepToday();
    return SelfCareData(hydrationMl: hydration, sleepHours: sleep);
  }

  Future<void> addHydration(double amountMl) async {
    await ref.read(selfCareRepositoryProvider).addHydration(amountMl);
    ref.invalidateSelf();
  }

  Future<void> setSleep(double hours) async {
    await ref.read(selfCareRepositoryProvider).setSleep(hours);
    ref.invalidateSelf();
  }
}
