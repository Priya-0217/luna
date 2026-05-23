import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(SyncServiceRef ref) => SyncService(
      ref.watch(firestoreServiceProvider),
      ref.watch(appDatabaseProvider),
    );

class SyncService {
  SyncService(this._firestore, this._db);

  final FirestoreService _firestore;
  final AppDatabase _db;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> syncAllPending() async {
    if (_uid.isEmpty) return;
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) return;

    await Future.wait([
      _syncDailyLogs(),
      _syncJournalEntries(),
      _syncSelfCareLogs(),
      _syncCycleEntries(),
    ]);
  }

  void listenForConnectivity() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncAllPending();
      }
    });
  }

  Future<void> _syncDailyLogs() async {
    final pending = await _db.getUnsyncedLogs();
    for (final log in pending) {
      try {
        final dateKey = FirestoreService.dateKey(log.date);
        await _firestore.saveDailyLog(dateKey, {
          'userId': _uid,
          'date': log.date.toIso8601String(),
          'mood': log.mood,
          'flowLevel': log.flow,
          'symptoms': log.symptoms,
          'notes': log.notes,
          'energyLevel': log.energyLevel,
        });
        await _db.markLogSynced(log.id);
      } catch (_) {}
    }
  }

  Future<void> _syncJournalEntries() async {
    final pending = await _db.getUnsyncedJournalEntries();
    for (final entry in pending) {
      try {
        final entryId = '${_uid}_${entry.date.millisecondsSinceEpoch}';
        await _firestore.saveJournalEntry(entryId, {
          'userId': _uid,
          'date': entry.date.toIso8601String(),
          'encryptedContent': entry.content,
          'mood': entry.mood,
        });
        await _db.markJournalEntrySynced(entry.id);
      } catch (_) {}
    }
  }

  Future<void> _syncSelfCareLogs() async {
    final pending = await _db.getUnsyncedSelfCareLogs();
    for (final log in pending) {
      try {
        final key = '${log.type}_${log.date.millisecondsSinceEpoch}';
        await _firestore.saveSelfCareLog(key, {
          'userId': _uid,
          'date': log.date.toIso8601String(),
          'type': log.type,
          'value': log.value,
        });
        await _db.markSelfCareLogSynced(log.id);
      } catch (_) {}
    }
  }

  Future<void> _syncCycleEntries() async {
    final pending = await _db.getUnsyncedCycleEntries();
    for (final entry in pending) {
      try {
        await _firestore.saveCycleEntry(entry.id, {
          'userId': _uid,
          'startDate': entry.startDate.toIso8601String(),
          'endDate': entry.endDate?.toIso8601String(),
          'cycleLength': entry.cycleLength,
          'createdAt': entry.createdAt.toIso8601String(),
        });
        await _db.markCycleEntrySynced(entry.id);
      } catch (_) {}
    }
  }
}
