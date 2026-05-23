// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalEntriesHash() => r'01d4b4167f30618bcdd903e8cfce8bcb0b8e1030';

/// See also [JournalEntries].
@ProviderFor(JournalEntries)
final journalEntriesProvider =
    AutoDisposeAsyncNotifierProvider<
      JournalEntries,
      List<JournalEntry>
    >.internal(
      JournalEntries.new,
      name: r'journalEntriesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$journalEntriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JournalEntries = AutoDisposeAsyncNotifier<List<JournalEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
