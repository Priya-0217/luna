import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/core/services/sync_service.dart';
import 'package:her/features/self_care/domain/hydration_log.dart';
import 'package:her/features/self_care/domain/sleep_log.dart';
import 'package:uuid/uuid.dart';

part 'self_care_repository.g.dart';

@riverpod
SelfCareRepository selfCareRepository(SelfCareRepositoryRef ref) =>
    SelfCareRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class SelfCareRepository {
  SelfCareRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;
  final _uuid = const Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ── Hydration ────────────────────────────────────────────────────────────────
  Future<void> addHydration(double amountMl) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final existing = await _db.getSelfCareLogForToday('hydration');
    if (existing != null) {
      // Update: add the new amount to today's total
      final newValue = existing.value + amountMl;
      await _db.updateSelfCareLog(SelfCareLogsCompanion(
        id: Value(existing.id),
        userId: Value(existing.userId),
        date: Value(existing.date),
        type: const Value('hydration'),
        value: Value(newValue),
        synced: const Value(false),
      ));
      _syncSelfCare('hydration', newValue, today);
    } else {
      // Insert first log for today
      await _db.insertSelfCare(SelfCareLogsCompanion.insert(
        userId: Value(_uid),
        date: today,
        type: 'hydration',
        value: amountMl,
        synced: const Value(false),
      ));
      _syncSelfCare('hydration', amountMl, today);
    }
  }

  Future<double> getHydrationToday() => _db.getHydrationToday();

  // ── Sleep ────────────────────────────────────────────────────────────────────
  Future<void> setSleep(double hours, {int quality = 3}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final existing = await _db.getSelfCareLogForToday('sleep');
    if (existing != null) {
      // Update: replace today's sleep value with the new slider position
      await _db.updateSelfCareLog(SelfCareLogsCompanion(
        id: Value(existing.id),
        userId: Value(existing.userId),
        date: Value(existing.date),
        type: const Value('sleep'),
        value: Value(hours),
        synced: const Value(false),
      ));
      _syncSelfCare('sleep', hours, today);
    } else {
      // Insert first log for today
      await _db.insertSelfCare(SelfCareLogsCompanion.insert(
        userId: Value(_uid),
        date: today,
        type: 'sleep',
        value: hours,
        synced: const Value(false),
      ));
      _syncSelfCare('sleep', hours, today);
    }
  }

  Future<double> getSleepToday() => _db.getSleepToday();

  void _syncSelfCare(String type, double value, DateTime date) async {
    try {
      final key = '${type}_${DateFormat('yyyy-MM-dd').format(date)}';
      await _firestore.saveSelfCareLog(key, {
        'userId': _uid,
        'date': date.toIso8601String(),
        'type': type,
        'value': value,
      });
    } catch (_) {}
  }
}
