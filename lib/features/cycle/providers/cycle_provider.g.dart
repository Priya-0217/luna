// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestCycleEntryHash() => r'15b8aef7f70bfbe578eb5a8f1ea78dfb93d7195f';

/// See also [latestCycleEntry].
@ProviderFor(latestCycleEntry)
final latestCycleEntryProvider =
    AutoDisposeFutureProvider<CycleEntry?>.internal(
      latestCycleEntry,
      name: r'latestCycleEntryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$latestCycleEntryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestCycleEntryRef = AutoDisposeFutureProviderRef<CycleEntry?>;
String _$cycleHistoryHash() => r'5f544c77b566725df509817740aaa7e545a2e05b';

/// See also [CycleHistory].
@ProviderFor(CycleHistory)
final cycleHistoryProvider =
    AutoDisposeAsyncNotifierProvider<CycleHistory, List<CycleEntry>>.internal(
      CycleHistory.new,
      name: r'cycleHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cycleHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CycleHistory = AutoDisposeAsyncNotifier<List<CycleEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
