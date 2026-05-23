import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

// ─── Provider ─────────────────────────────────────────────────────────────────

@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref) =>
    FirestoreService(FirebaseFirestore.instance);

// ─── Service ──────────────────────────────────────────────────────────────────

class FirestoreService {
  FirestoreService(this._db);

  final FirebaseFirestore _db;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ── User references ──────────────────────────────────────────────────────────
  DocumentReference<Map<String, dynamic>> get _userDoc =>
      _db.collection('users').doc(_uid);

  CollectionReference<Map<String, dynamic>> _userCol(String sub) =>
      _userDoc.collection(sub);

  CollectionReference<Map<String, dynamic>> _fromHimCol(String sub) =>
      _db.collection('fromHim').doc(_uid).collection(sub);

  // ── User profile ─────────────────────────────────────────────────────────────
  Future<void> saveUserProfile(Map<String, dynamic> data) =>
      _userDoc.set({...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<Map<String, dynamic>?> getUserProfile() async {
    final snap = await _userDoc.get();
    return snap.data();
  }

  // ── Daily Logs ───────────────────────────────────────────────────────────────
  Future<void> saveDailyLog(String dateKey, Map<String, dynamic> data) =>
      _userCol('dailyLogs').doc(dateKey).set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<List<Map<String, dynamic>>> getDailyLogs({int limit = 90}) async {
    final snap = await _userCol('dailyLogs')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  Future<Map<String, dynamic>?> getDailyLog(String dateKey) async {
    final snap = await _userCol('dailyLogs').doc(dateKey).get();
    return snap.data();
  }

  // ── Cycle Entries ────────────────────────────────────────────────────────────
  Future<void> saveCycleEntry(String entryId, Map<String, dynamic> data) =>
      _userCol('cycleEntries').doc(entryId).set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<void> deleteCycleEntry(String entryId) =>
      _userCol('cycleEntries').doc(entryId).delete();

  Future<List<Map<String, dynamic>>> getCycleEntries({int limit = 24}) async {
    final snap = await _userCol('cycleEntries')
        .orderBy('startDate', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // ── Journal Entries ──────────────────────────────────────────────────────────
  Future<void> saveJournalEntry(String entryId, Map<String, dynamic> data) =>
      _userCol('journalEntries').doc(entryId).set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<void> deleteJournalEntry(String entryId) =>
      _userCol('journalEntries').doc(entryId).delete();

  Future<List<Map<String, dynamic>>> getJournalEntries({int limit = 50}) async {
    final snap = await _userCol('journalEntries')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // ── Self-Care Logs ───────────────────────────────────────────────────────────
  Future<void> saveSelfCareLog(String dateKey, Map<String, dynamic> data) =>
      _userCol('selfCareLogs').doc(dateKey).set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<List<Map<String, dynamic>>> getSelfCareLogs({int limit = 30}) async {
    final snap = await _userCol('selfCareLogs')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => d.data()).toList();
  }

  // ── Garden State ─────────────────────────────────────────────────────────────
  Future<void> saveGardenState(Map<String, dynamic> data) =>
      _userDoc.collection('meta').doc('gardenState').set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<Map<String, dynamic>?> getGardenState() async {
    final snap =
        await _userDoc.collection('meta').doc('gardenState').get();
    return snap.data();
  }

  // ── Settings ─────────────────────────────────────────────────────────────────
  Future<void> saveSettings(Map<String, dynamic> data) =>
      _userDoc.collection('meta').doc('settings').set(
          {...data, 'updatedAt': FieldValue.serverTimestamp()},
          SetOptions(merge: true));

  Future<Map<String, dynamic>?> getSettings() async {
    final snap =
        await _userDoc.collection('meta').doc('settings').get();
    return snap.data();
  }

  // ── From Him (read-only for user) ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getFromHimMessages() async {
    final snap =
        await _fromHimCol('messages').orderBy('createdAt').get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<void> markMessageUnlocked(String messageId) =>
      _fromHimCol('messages').doc(messageId).update({
        'isUnlocked': true,
        'unlockedAt': FieldValue.serverTimestamp(),
      });

  Future<List<Map<String, dynamic>>> getVoiceNotes() async {
    final snap =
        await _fromHimCol('voiceNotes').orderBy('createdAt').get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  Future<List<Map<String, dynamic>>> getMemoryPhotos() async {
    final snap =
        await _fromHimCol('photos').orderBy('takenAt', descending: true).get();
    return snap.docs.map((d) => {...d.data(), 'id': d.id}).toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  /// Converts Firestore [Timestamp] to [DateTime]; passes [DateTime] through.
  static DateTime tsToDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  /// Converts [DateTime] to Firestore [Timestamp].
  static Timestamp dateToTs(DateTime dt) => Timestamp.fromDate(dt);

  /// Returns date key in YYYY-MM-DD format.
  static String dateKey(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
