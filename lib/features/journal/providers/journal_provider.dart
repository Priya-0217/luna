import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/journal/data/journal_repository.dart';
import 'package:her/features/journal/domain/journal_entry.dart';

part 'journal_provider.g.dart';

@riverpod
class JournalEntries extends _$JournalEntries {
  @override
  FutureOr<List<JournalEntry>> build() async {
    return ref.watch(journalRepositoryProvider).getAllEntries();
  }

  Future<void> addEntry({
    required String plaintextContent,
    required String mood,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(journalRepositoryProvider).saveEntry(
            plaintextContent: plaintextContent,
            mood: mood,
          );
      return ref.read(journalRepositoryProvider).getAllEntries();
    });
  }

  Future<String> decryptEntry(String encryptedContent) =>
      ref.read(journalRepositoryProvider).decrypt(encryptedContent);
}
