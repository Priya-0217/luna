import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/mood_garden/domain/garden_state.dart';

part 'garden_repository.g.dart';

@riverpod
GardenRepository gardenRepository(GardenRepositoryRef ref) =>
    GardenRepository(ref.watch(firestoreServiceProvider));

class GardenRepository {
  GardenRepository(this._firestore);

  final FirestoreService _firestore;

  static const _cacheKey = 'garden_state';

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<GardenState> getState() async {
    // Try local first
    final box = Hive.box('settings');
    final cached = box.get(_cacheKey);
    if (cached != null && cached is Map) {
      try {
        return GardenState.fromJson(Map<String, dynamic>.from(cached));
      } catch (_) {}
    }
    // Fetch from Firestore
    try {
      final data = await _firestore.getGardenState();
      if (data != null) {
        final state = GardenState.fromJson(data);
        await box.put(_cacheKey, state.toJson());
        return state;
      }
    } catch (_) {}
    return GardenState.empty(_uid);
  }

  Future<void> saveState(GardenState state) async {
    final box = Hive.box('settings');
    await box.put(_cacheKey, state.toJson());
    try {
      await _firestore.saveGardenState(state.toJson());
    } catch (_) {}
  }

  /// Called after each daily log — updates streak and adds a flower.
  Future<GardenState> onDailyLogSaved(GardenState current) async {
    final today = DateTime.now();
    final isNewDay = current.lastLogDate == null ||
        !_isSameDay(current.lastLogDate!, today);

    if (!isNewDay) return current;

    final yesterday = today.subtract(const Duration(days: 1));
    final isConsecutive = current.lastLogDate != null &&
        _isSameDay(current.lastLogDate!, yesterday);

    final newStreak = isConsecutive ? current.streak + 1 : 1;
    final newFlowerCounts = Map<String, int>.from(current.flowerCounts);
    final flower = _pickFlowerForStreak(newStreak);
    newFlowerCounts[flower] = (newFlowerCounts[flower] ?? 0) + 1;

    final updated = current.copyWith(
      streak: newStreak,
      totalFlowers: current.totalFlowers + 1,
      lastLogDate: today,
      weather: _weatherForStreak(newStreak),
      flowerCounts: newFlowerCounts,
    );

    await saveState(updated);
    return updated;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _pickFlowerForStreak(int streak) {
    if (streak >= 30) return 'cherry';
    if (streak >= 14) return 'rose';
    if (streak >= 7) return 'tulip';
    if (streak >= 3) return 'lavender';
    return 'daisy';
  }

  String _weatherForStreak(int streak) {
    if (streak >= 14) return 'golden';
    if (streak >= 7) return 'sunny';
    if (streak >= 3) return 'cloudy';
    return 'cloudy';
  }
}
