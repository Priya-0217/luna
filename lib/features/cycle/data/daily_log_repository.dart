import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:her/core/services/database.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/cycle/domain/daily_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;

part 'daily_log_repository.g.dart';

@riverpod
DailyLogRepository dailyLogRepository(DailyLogRepositoryRef ref) =>
    DailyLogRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class DailyLogRepository {
  DailyLogRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;
  final _uuid = const Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ─── Local Storage ──────────────────────────────────────────────────────────

  Future<void> saveDailyLog(DailyLog log) async {
    // Save locally
    await _db.upsertDailyLog(DailyLogsCompanion(
      id: Value(log.id),
      userId: Value(log.userId),
      date: Value(log.date),
      mood: Value(log.mood),
      flow: Value(log.flow),
      symptoms: Value(log.symptoms),
      notes: Value(log.notes),
      energyLevel: Value(log.energyLevel),
      synced: Value(log.synced),
    ));

    // Sync to Firestore
    _syncLog(log);
  }

  Future<DailyLog?> getDailyLog(DateTime date) async {
    final row = await _db.getLogByDate(date);
    return row == null ? null : _fromRow(row);
  }

  // ─── Firestore Sync ─────────────────────────────────────────────────────────

  void _syncLog(DailyLog log) async {
    try {
      final dateKey = FirestoreService.dateKey(log.date);
      debugPrint('DailyLogRepository: Syncing log $dateKey to Firestore');
      await _firestore.saveDailyLog(dateKey, {
        'id': log.id,
        'userId': log.userId,
        'date': Timestamp.fromDate(log.date),
        'mood': log.mood,
        'flow': log.flow, // Standardized field name
        'symptoms': log.symptoms, // Standardized to String (joined by ', ')
        'notes': log.notes,
        'energyLevel': log.energyLevel,
        'createdAt': Timestamp.fromDate(log.createdAt),
      });
      // Mark as synced locally
      await _db.markLogSynced(log.id);
      debugPrint('DailyLogRepository: Sync complete for $dateKey');
    } catch (e) {
      debugPrint('DailyLogRepository: Error syncing daily log: $e');
    }
  }

  // ─── Real-time Listeners ───────────────────────────────────────────────────

  Stream<List<DailyLog>> watchDailyLogs() {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
    return userDoc
        .collection('dailyLogs')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        
        // Handle potential legacy field names or types
        final dateValue = data['date'];
        final date = dateValue is String 
            ? DateTime.parse(dateValue) 
            : FirestoreService.tsToDate(dateValue);
            
        final symptomsValue = data['symptoms'];
        final symptoms = symptomsValue is List 
            ? symptomsValue.join(', ') 
            : (symptomsValue ?? '');

        return DailyLog(
          id: data['id'] ?? doc.id,
          userId: data['userId'] ?? _uid,
          date: date,
          mood: data['mood'] ?? 'calm',
          flow: data['flow'] ?? data['flowLevel'] ?? 0, // Handle both
          symptoms: symptoms,
          notes: data['notes'],
          energyLevel: data['energyLevel'] ?? 3,
          synced: true,
          createdAt: FirestoreService.tsToDate(data['createdAt'] ?? data['date']),
        );
      }).toList();
    });
  }

  DailyLog _fromRow(DailyLogRow row) => DailyLog(
        id: row.id,
        userId: row.userId,
        date: row.date,
        mood: row.mood,
        flow: row.flow,
        symptoms: row.symptoms,
        notes: row.notes,
        energyLevel: row.energyLevel,
        synced: row.synced,
        createdAt: DateTime.now(), // Row doesn't have createdAt, using now as fallback
      );
}
