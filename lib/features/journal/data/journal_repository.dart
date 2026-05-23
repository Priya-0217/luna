import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' show Value;
import 'package:her/core/services/database.dart';
import 'package:her/core/services/encryption_service.dart';
import 'package:her/core/services/firestore_service.dart';
import 'package:her/features/journal/domain/journal_entry.dart';

part 'journal_repository.g.dart';

@riverpod
JournalRepository journalRepository(JournalRepositoryRef ref) =>
    JournalRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(firestoreServiceProvider),
    );

class JournalRepository {
  JournalRepository(this._db, this._firestore);

  final AppDatabase _db;
  final FirestoreService _firestore;
  final _uuid = const Uuid();

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  // ── Tag extraction ──────────────────────────────────────────────────────────
  /// Extracts @him, @cycle1, @cycle2, etc. from plaintext before encryption.
  List<String> _extractTags(String plaintext) {
    final regex = RegExp(r'@(him|cycle\d*)', caseSensitive: false);
    final matches = regex.allMatches(plaintext);
    return matches.map((m) => '@${m.group(1)!.toLowerCase()}').toSet().toList();
  }

  // ── Save (create new entry) ─────────────────────────────────────────────────
  Future<JournalEntry> saveEntry({
    required String plaintextContent,
    required String mood,
  }) async {
    final tags = _extractTags(plaintextContent);
    final encrypted = await EncryptionService.encryptText(plaintextContent);
    final now = DateTime.now();
    final id = _uuid.v4();

    await _db.insertJournalEntry(JournalEntriesCompanion.insert(
      userId: Value(_uid),
      date: now,
      content: encrypted,
      mood: mood,
      synced: const Value(false),
    ));

    final entry = JournalEntry(
      id: id,
      userId: _uid,
      date: now,
      encryptedContent: encrypted,
      mood: mood,
      synced: false,
      createdAt: now,
    );
    _syncEntry(entry, tags: tags);
    return entry;
  }

  // ── Update (edit existing entry) ────────────────────────────────────────────
  Future<void> updateEntry({
    required int driftId,
    required String firestoreId,
    required String plaintextContent,
    required String mood,
    required DateTime originalDate,
  }) async {
    final tags = _extractTags(plaintextContent);
    final encrypted = await EncryptionService.encryptText(plaintextContent);

    await _db.updateJournalEntry(
      driftId,
      JournalEntriesCompanion(
        content: Value(encrypted),
        mood: Value(mood),
        synced: const Value(false),
      ),
    );

    // Sync updated entry to Firebase with tags
    try {
      await _firestore.saveJournalEntry(firestoreId, {
        'userId': _uid,
        'date': originalDate.toIso8601String(),
        'encryptedContent': encrypted,
        'mood': mood,
        'tags': tags,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await _db.markJournalEntrySynced(driftId);
    } catch (_) {}
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final rows = await _db.getAllJournalEntries();
    return rows.map(_fromRow).toList();
  }

  Future<String> decrypt(String encryptedContent) =>
      EncryptionService.decryptText(encryptedContent);

  Future<void> deleteEntry(int driftId, {String? firestoreId}) async {
    await _db.deleteJournalEntry(driftId);
    if (firestoreId != null) {
      try {
        await _firestore.deleteJournalEntry(firestoreId);
      } catch (_) {}
    }
  }

  void _syncEntry(JournalEntry entry, {List<String> tags = const []}) async {
    try {
      await _firestore.saveJournalEntry(entry.id, {
        'userId': entry.userId,
        'date': entry.date.toIso8601String(),
        'encryptedContent': entry.encryptedContent,
        'mood': entry.mood,
        'tags': tags,
        'createdAt': entry.createdAt.toIso8601String(),
      });
      final rows = await _db.getAllJournalEntries();
      final match = rows
          .where((r) =>
              r.date.millisecondsSinceEpoch ==
              entry.date.millisecondsSinceEpoch)
          .firstOrNull;
      if (match != null) await _db.markJournalEntrySynced(match.id);
    } catch (_) {}
  }

  // Convert Drift JournalRow → domain JournalEntry
  // Store the Drift integer ID in the domain id field so screens can use it.
  JournalEntry _fromRow(JournalRow row) => JournalEntry(
        id: '${row.userId}_${row.date.millisecondsSinceEpoch}',
        userId: row.userId,
        date: row.date,
        encryptedContent: row.content,
        mood: row.mood,
        synced: row.synced,
        createdAt: row.date,
      );

  /// Maps the domain id string back to the Drift integer PK for update/delete.
  Future<int?> getDriftId(DateTime entryDate) async {
    final rows = await _db.getAllJournalEntries();
    return rows
        .where(
            (r) => r.date.millisecondsSinceEpoch == entryDate.millisecondsSinceEpoch)
        .firstOrNull
        ?.id;
  }
}
