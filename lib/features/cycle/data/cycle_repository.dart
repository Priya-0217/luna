import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('🩸 CycleRepository: startPeriod called for date: $date');

    // Find if we already have an active cycle (no end date)
    final latest = await getLatestEntry();

    if (latest != null && latest.endDate == null) {
      // If we have an active cycle, update its start date instead of creating a new one.
      debugPrint(
        '🩸 CycleRepository: Found active cycle ${latest.id}, updating start date to $date',
      );
      return updateLatestPeriodStart(date);
    }

    // Check if we already have an entry for this exact date to prevent duplicates
    final allEntries = await getAllEntries();
    final duplicate = allEntries
        .where(
          (e) =>
              e.startDate.year == date.year &&
              e.startDate.month == date.month &&
              e.startDate.day == date.day,
        )
        .firstOrNull;

    if (duplicate != null) {
      debugPrint(
        '🩸 CycleRepository: Entry already exists for $date, skipping duplicate creation.',
      );
      return duplicate;
    }

    final id = _uuid.v4();
    debugPrint('🩸 CycleRepository: Creating new cycle entry record: $id');
    await _db.upsertCycleEntry(
      CycleEntriesCompanion.insert(
        id: id,
        userId: _uid,
        startDate: date,
        endDate: const Value(null),
        cycleLength: const Value(null),
        synced: const Value(false),
        createdAt: DateTime.now(),
      ),
    );

    final entry = CycleEntry(
      id: id,
      userId: _uid,
      startDate: date,
      synced: false,
      createdAt: DateTime.now(),
    );
    _syncEntry(entry);
    return entry;
  }

  Future<CycleEntry> updateLatestPeriodStart(DateTime startDate) async {
    final latest = await getLatestEntry();
    if (latest == null) {
      debugPrint(
        '🩸 CycleRepository: No latest entry found, defaulting to startPeriod',
      );
      return startPeriod(startDate);
    }

    debugPrint(
      '🩸 CycleRepository: Modifying entry ${latest.id} start date -> $startDate',
    );
    final updated = latest.copyWith(startDate: startDate, synced: false);

    // If there are other active cycles that now start AFTER this updated one,
    // they are likely duplicates or invalid state from the previous date.
    final allEntries = await getAllEntries();
    final otherActive = allEntries
        .where((e) => e.id != updated.id && e.endDate == null)
        .toList();

    for (var other in otherActive) {
      debugPrint(
        '🩸 CycleRepository: Cleaning up conflicting active cycle: ${other.id}',
      );
      await deleteCycleEntry(other.id);
    }

    await _db.upsertCycleEntry(
      CycleEntriesCompanion(
        id: Value(updated.id),
        userId: Value(updated.userId),
        startDate: Value(updated.startDate),
        endDate: const Value(null),
        synced: const Value(false),
      ),
    );

    _syncEntry(updated);
    return updated;
  }

  Future<CycleEntry?> endPeriod() async {
    final latest = await _db.getLatestCycleEntry();
    if (latest == null || latest.endDate != null) return null;

    final now = DateTime.now();
    final cycleLen = now.difference(latest.startDate).inDays;

    await _db.upsertCycleEntry(
      CycleEntriesCompanion(
        id: Value(latest.id),
        userId: Value(latest.userId),
        startDate: Value(latest.startDate),
        endDate: Value(now),
        cycleLength: Value(cycleLen),
        synced: const Value(false),
        createdAt: Value(latest.createdAt),
      ),
    );

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

  Stream<CycleEntry?> watchLatestEntry() {
    return _db.watchLatestCycleEntry().map(
      (row) => row == null ? null : _fromRow(row),
    );
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
          final entries = snapshot.docs.map((doc) {
            final data = doc.data();
            final entry = CycleEntry(
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

            // Background sync to local DB
            _updateLocal(entry);

            return entry;
          }).toList();
          return entries;
        });
  }

  void _updateLocal(CycleEntry entry) async {
    await _db.upsertCycleEntry(
      CycleEntriesCompanion(
        id: Value(entry.id),
        userId: Value(entry.userId),
        startDate: Value(entry.startDate),
        endDate: Value(entry.endDate),
        cycleLength: Value(entry.cycleLength),
        synced: const Value(true),
        createdAt: Value(entry.createdAt),
      ),
    );
  }

  void _syncEntry(CycleEntry entry) async {
    try {
      debugPrint('CycleRepository: Syncing entry ${entry.id} to Firestore');
      // The collection used here is 'cycleEntries' defined in FirestoreService
      await _firestore.saveCycleEntry(entry.id, {
        'id': entry.id, // Ensure ID is included in data
        'userId': entry.userId,
        // Match the field names expected by partner_data_provider.dart
        'date': Timestamp.fromDate(entry.startDate),
        'startDate': Timestamp.fromDate(entry.startDate),
        'endDate': entry.endDate != null
            ? Timestamp.fromDate(entry.endDate!)
            : null,
        'cycleLength': entry.cycleLength,
        'createdAt': Timestamp.fromDate(entry.createdAt),
      });
      await _db.markCycleEntrySynced(entry.id);
      debugPrint('CycleRepository: Sync complete for ${entry.id}');
    } catch (e) {
      debugPrint('CycleRepository: Sync failed for ${entry.id}: $e');
    }
  }

  Future<void> deleteCycleEntry(String id) async {
    await _db.deleteCycleEntry(id);
    _deleteFromFirestore(id);
  }

  void _deleteFromFirestore(String id) async {
    try {
      debugPrint('CycleRepository: Deleting entry $id from Firestore');
      await _firestore.deleteCycleEntry(id);
    } catch (e) {
      debugPrint('CycleRepository: Deletion failed for $id: $e');
    }
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
