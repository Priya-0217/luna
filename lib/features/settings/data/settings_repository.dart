import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/settings/domain/app_settings.dart';

part 'settings_repository.g.dart';

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) =>
    SettingsRepository(ref.watch(firestoreServiceProvider));

class SettingsRepository {
  SettingsRepository(this._firestore);

  final FirestoreService _firestore;

  static const _cacheKey = 'app_settings_v2';

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<AppSettings> getSettings() async {
    final box = Hive.box('settings');
    // Load from Hive first
    final cycleLength = box.get('cycle_length', defaultValue: 28) as int;
    final periodLength = box.get('period_duration', defaultValue: 5) as int;
    final notificationsEnabled =
        box.get('notifications_enabled', defaultValue: true) as bool;
    final disguiseMode =
        box.get('disguise_mode_enabled', defaultValue: false) as bool;

    // Try to enrich from Firestore
    try {
      final data = await _firestore.getSettings();
      if (data != null) {
        return AppSettings(
          userId: _uid,
          cycleLength: (data['cycleLength'] as int?) ?? cycleLength,
          periodLength: (data['periodLength'] as int?) ?? periodLength,
          notificationsEnabled:
              (data['notificationsEnabled'] as bool?) ?? notificationsEnabled,
          disguiseMode: (data['disguiseMode'] as bool?) ?? disguiseMode,
        );
      }
    } catch (_) {}

    return AppSettings(
      userId: _uid,
      cycleLength: cycleLength,
      periodLength: periodLength,
      notificationsEnabled: notificationsEnabled,
      disguiseMode: disguiseMode,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = Hive.box('settings');
    // Persist to Hive (always)
    await box.put('cycle_length', settings.cycleLength);
    await box.put('period_duration', settings.periodLength);
    await box.put('notifications_enabled', settings.notificationsEnabled);
    await box.put('disguise_mode_enabled', settings.disguiseMode);

    // Sync to Firestore
    try {
      await _firestore.saveSettings({
        'userId': settings.userId,
        'cycleLength': settings.cycleLength,
        'periodLength': settings.periodLength,
        'notificationsEnabled': settings.notificationsEnabled,
        'disguiseMode': settings.disguiseMode,
      });
    } catch (_) {}
  }
}
