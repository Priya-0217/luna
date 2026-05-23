import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' show Value;
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/daily_log/domain/daily_log_entry.dart';

part 'log_repository.g.dart';

@riverpod
LogRepository logRepository(LogRepositoryRef ref) => LogRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class LogRepository {
  LogRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> saveLog(DailyLogEntry entry) async {
    final symptomsStr = entry.symptoms.join(',');
    final existing = await _db.getLogByDate(entry.date);

    if (existing != null) {
      await _db.updateLogById(
        existing.id,
        DailyLogsCompanion(
          mood: Value(entry.mood),
          flow: Value(entry.flowLevel),
          symptoms: Value(symptomsStr),
          notes: Value(entry.notes),
          energyLevel: Value(entry.energyLevel),
          synced: const Value(false),
        ),
      );
    } else {
      await _db.insertLog(DailyLogsCompanion.insert(
        id: '${entry.userId}_${entry.date.millisecondsSinceEpoch}',
        userId: Value(entry.userId),
        date: entry.date,
        mood: entry.mood,
        flow: entry.flowLevel,
        symptoms: symptomsStr,
        notes: Value(entry.notes),
        energyLevel: Value(entry.energyLevel),
        synced: const Value(false),
      ));
    }

    // Immediate Firestore sync attempt
    try {
      final dateKey = FirestoreService.dateKey(entry.date);
      await _firestore.saveDailyLog(dateKey, {
        'userId': _uid,
        'date': entry.date.toIso8601String(),
        'mood': entry.mood,
        'flowLevel': entry.flowLevel,
        'symptoms': entry.symptoms,
        'notes': entry.notes,
        'energyLevel': entry.energyLevel,
      });
      final saved = await _db.getLogByDate(entry.date);
      if (saved != null) await _db.markLogSynced(saved.id);
    } catch (_) {
      // Queued for next SyncService pass
    }
  }

  Future<DailyLogEntry?> getTodayLog() async {
    final log = await _db.getLogByDate(DateTime.now());
    return log == null ? null : _fromDrift(log);
  }

  Future<List<DailyLogEntry>> getRecentLogs({int days = 90}) async {
    final from = DateTime.now().subtract(Duration(days: days));
    final logs = await _db.getLogsInRange(from, DateTime.now());
    return logs.map(_fromDrift).toList();
  }

  DailyLogEntry _fromDrift(DailyLogRow log) => DailyLogEntry(
        id: '${log.userId}_${log.date.millisecondsSinceEpoch}',
        userId: log.userId,
        date: log.date,
        mood: log.mood,
        flowLevel: log.flow,
        symptoms: log.symptoms.isEmpty ? [] : log.symptoms.split(','),
        notes: log.notes,
        energyLevel: log.energyLevel,
        synced: log.synced,
      );
}
