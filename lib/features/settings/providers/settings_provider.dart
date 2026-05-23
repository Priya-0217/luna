import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/settings/data/settings_repository.dart';
import 'package:her/features/settings/domain/app_settings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  FutureOr<AppSettings> build() async {
    return ref.watch(settingsRepositoryProvider).getSettings();
  }

  Future<void> save(AppSettings settings) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).saveSettings(settings);
      return settings;
    });
  }

  Future<void> updateCycleLength(int days) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await save(current.copyWith(cycleLength: days));
  }

  Future<void> updatePeriodLength(int days) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await save(current.copyWith(periodLength: days));
  }

  Future<void> toggleNotifications(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await save(current.copyWith(notificationsEnabled: enabled));
  }

  Future<void> toggleDisguiseMode(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    await save(current.copyWith(disguiseMode: enabled));
  }
}
