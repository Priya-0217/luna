import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/mood_garden/data/garden_repository.dart';
import 'package:her/features/mood_garden/domain/garden_state.dart';

part 'garden_provider.g.dart';

@riverpod
class GardenStateNotifier extends _$GardenStateNotifier {
  @override
  FutureOr<GardenState> build() async {
    return ref.watch(gardenRepositoryProvider).getState();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Convenient alias used by other providers
final gardenStateProvider = gardenStateNotifierProvider;
