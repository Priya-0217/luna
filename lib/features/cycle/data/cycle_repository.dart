import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/cycle/domain/cycle_entry.dart';

part 'cycle_repository.g.dart';

@riverpod
CycleRepository cycleRepository(CycleRepositoryRef ref) => CycleRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class CycleRepository {
  CycleRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;
  final _uuid = const Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<CycleEntry> startPeriod([DateTime? startDate]) async {
    final date = startDate ?? DateTime.now();
    final id = _uuid.v4();

    await _db.upsertCycleEntry(CycleEntriesCompanion.insert(
      id: id,
      userId: _uid,
      startDate: date,
      endDate: const Value(null),
      cycleLength: const Value(null),
      synced: const Value(false),
      createdAt: DateTime.now(),
    ));

    final entry = CycleEntry(
        id: id, userId: _uid, startDate: date, synced: false, createdAt: DateTime.now());
    _syncEntry(entry);
    return entry;
  }

  Future<CycleEntry?> endPeriod() async {
    final latest = await _db.getLatestCycleEntry();
    if (latest == null || latest.endDate != null) return null;

    final now = DateTime.now();
    final cycleLen = now.difference(latest.startDate).inDays;

    await _db.upsertCycleEntry(CycleEntriesCompanion(
      id: Value(latest.id),
      userId: Value(latest.userId),
      startDate: Value(latest.startDate),
      endDate: Value(now),
      cycleLength: Value(cycleLen),
      synced: const Value(false),
      createdAt: Value(latest.createdAt),
    ));

    final updated = CycleEntry(
      id: latest.id,
      userId: latest.userId,
      startDate: latest.startDate,
      endDate: now,
      cycleLength: cycleLen,
      synced: false,
      createdAt: latest.createdAt,
    );
    _syncEntry(updated);
    return updated;
  }

  Future<List<CycleEntry>> getAllEntries() async {
    final rows = await _db.getAllCycleEntries();
    return rows.map(_fromRow).toList();
  }

  Future<CycleEntry?> getLatestEntry() async {
    final row = await _db.getLatestCycleEntry();
    return row == null ? null : _fromRow(row);
  }

  // ─── Real-time Listeners ───────────────────────────────────────────────────

  Stream<List<CycleEntry>> watchCycleEntries() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('cycleEntries')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CycleEntry(
          id: doc.id,
          userId: data['userId'] ?? _uid,
          startDate: FirestoreService.tsToDate(data['startDate']),
          endDate: data['endDate'] != null
              ? FirestoreService.tsToDate(data['endDate'])
              : null,
          cycleLength: data['cycleLength'],
          synced: true,
          createdAt: FirestoreService.tsToDate(data['createdAt']),
        );
      }).toList();
    });
  }

  void _syncEntry(CycleEntry entry) async {
    try {
      await _firestore.saveCycleEntry(entry.id, {
        'userId': entry.userId,
        'startDate': entry.startDate.toIso8601String(),
        'endDate': entry.endDate?.toIso8601String(),
        'cycleLength': entry.cycleLength,
        'createdAt': entry.createdAt.toIso8601String(),
      });
      await _db.markCycleEntrySynced(entry.id);
    } catch (_) {}
  }

  // Convert Drift CycleRow → domain CycleEntry
  CycleEntry _fromRow(CycleRow row) => CycleEntry(
        id: row.id,
        userId: row.userId,
        startDate: row.startDate,
        endDate: row.endDate,
        cycleLength: row.cycleLength,
        synced: row.synced,
        createdAt: row.createdAt,
      );
}
