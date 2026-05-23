import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database.g.dart';

// ─── Tables ───────────────────────────────────────────────────────────────────

@DataClassName('DailyLogRow')
class DailyLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  TextColumn get mood => text()();
  IntColumn get flow => integer()();
  TextColumn get symptoms => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get energyLevel => integer().withDefault(const Constant(3))();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Renamed to avoid conflict with domain JournalEntry
@DataClassName('JournalRow')
class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
  TextColumn get mood => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

class SelfCareLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  RealColumn get value => real()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

// Renamed to avoid conflict with domain CycleEntry
@DataClassName('CycleRow')
class CycleEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get cycleLength => integer().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [DailyLogs, JournalEntries, SelfCareLogs, CycleEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(dailyLogs, dailyLogs.userId);
            await m.addColumn(dailyLogs, dailyLogs.energyLevel);
            await m.addColumn(dailyLogs, dailyLogs.synced);
            await m.addColumn(journalEntries, journalEntries.userId);
            await m.addColumn(journalEntries, journalEntries.synced);
            await m.addColumn(selfCareLogs, selfCareLogs.userId);
            await m.addColumn(selfCareLogs, selfCareLogs.synced);
            await m.createTable(cycleEntries);
          }
        },
      );

  // ── Daily Logs ──────────────────────────────────────────────────────────────
  Future<List<DailyLogRow>> getAllLogs() => select(dailyLogs).get();

  Future<int> insertLog(DailyLogsCompanion log) =>
      into(dailyLogs).insert(log);

  Future<void> upsertDailyLog(DailyLogsCompanion log) =>
      into(dailyLogs).insertOnConflictUpdate(log);

  Future<void> updateLogById(String id, DailyLogsCompanion companion) =>
      (update(dailyLogs)..where((t) => t.id.equals(id))).write(companion);

  Future<int> deleteLog(String id) =>
      (delete(dailyLogs)..where((t) => t.id.equals(id))).go();

  Future<DailyLogRow?> getLogByDate(DateTime targetDate) {
    final d = DateTime(targetDate.year, targetDate.month, targetDate.day);
    return (select(dailyLogs)
          ..where((t) =>
              t.date.year.equals(d.year) &
              t.date.month.equals(d.month) &
              t.date.day.equals(d.day)))
        .getSingleOrNull();
  }

  Future<List<DailyLogRow>> getUnsyncedLogs() =>
      (select(dailyLogs)..where((t) => t.synced.equals(false))).get();

  Future<void> markLogSynced(String id) =>
      (update(dailyLogs)..where((t) => t.id.equals(id)))
          .write(const DailyLogsCompanion(synced: Value(true)));

  Future<List<DailyLogRow>> getLogsInRange(DateTime from, DateTime to) =>
      (select(dailyLogs)
            ..where((t) =>
                t.date.isBiggerOrEqualValue(from) &
                t.date.isSmallerOrEqualValue(to))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  // ── Journal ─────────────────────────────────────────────────────────────────
  Future<List<JournalRow>> getAllJournalEntries() =>
      (select(journalEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<int> insertJournalEntry(JournalEntriesCompanion entry) =>
      into(journalEntries).insert(entry);

  Future<int> deleteJournalEntry(int id) =>
      (delete(journalEntries)..where((t) => t.id.equals(id))).go();

  Future<bool> updateJournalEntry(int id, JournalEntriesCompanion companion) =>
      (update(journalEntries)..where((t) => t.id.equals(id)))
          .write(companion)
          .then((rowsAffected) => rowsAffected > 0);

  Future<List<JournalRow>> getUnsyncedJournalEntries() =>
      (select(journalEntries)..where((t) => t.synced.equals(false))).get();

  Future<void> markJournalEntrySynced(int id) =>
      (update(journalEntries)..where((t) => t.id.equals(id)))
          .write(const JournalEntriesCompanion(synced: Value(true)));

  // ── Self-Care ───────────────────────────────────────────────────────────────
  Future<List<SelfCareLog>> getSelfCareLogsByType(String type) =>
      (select(selfCareLogs)..where((t) => t.type.equals(type))).get();

  Future<int> insertSelfCare(SelfCareLogsCompanion log) =>
      into(selfCareLogs).insert(log);

  Future<bool> updateSelfCareLog(SelfCareLogsCompanion log) =>
      update(selfCareLogs).replace(log);

  Future<SelfCareLog?> getSelfCareLogForToday(String type) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return (select(selfCareLogs)
          ..where((t) =>
              t.type.equals(type) &
              t.date.year.equals(today.year) &
              t.date.month.equals(today.month) &
              t.date.day.equals(today.day))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<double> getHydrationToday() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final logs = await (select(selfCareLogs)
          ..where((t) =>
              t.type.equals('hydration') &
              t.date.year.equals(today.year) &
              t.date.month.equals(today.month) &
              t.date.day.equals(today.day)))
        .get();
    return logs.fold<double>(0.0, (sum, item) => sum + item.value);
  }

  Future<double> getSleepToday() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final logs = await (select(selfCareLogs)
          ..where((t) =>
              t.type.equals('sleep') &
              t.date.year.equals(today.year) &
              t.date.month.equals(today.month) &
              t.date.day.equals(today.day)))
        .get();
    return logs.fold<double>(0.0, (sum, item) => sum + item.value);
  }

  Future<List<SelfCareLog>> getUnsyncedSelfCareLogs() =>
      (select(selfCareLogs)..where((t) => t.synced.equals(false))).get();

  Future<void> markSelfCareLogSynced(int id) =>
      (update(selfCareLogs)..where((t) => t.id.equals(id)))
          .write(const SelfCareLogsCompanion(synced: Value(true)));

  // ── Cycle Entries ───────────────────────────────────────────────────────────
  Future<List<CycleRow>> getAllCycleEntries() =>
      (select(cycleEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<void> upsertCycleEntry(CycleEntriesCompanion entry) =>
      into(cycleEntries).insertOnConflictUpdate(entry);

  Future<CycleRow?> getLatestCycleEntry() =>
      (select(cycleEntries)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<CycleRow>> getUnsyncedCycleEntries() =>
      (select(cycleEntries)..where((t) => t.synced.equals(false))).get();

  Future<void> markCycleEntrySynced(String id) =>
      (update(cycleEntries)..where((t) => t.id.equals(id)))
          .write(const CycleEntriesCompanion(synced: Value(true)));
}

// ─── Database Riverpod provider (defined here, used by sync_service) ─────────
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

// ─── Connection ───────────────────────────────────────────────────────────────
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'luna.db'));
    return NativeDatabase(file);
  });
}
