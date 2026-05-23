// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyLogsStreamHash() => r'635eb4f0d23de5d22d755bc4924c6a69582a328c';

/// See also [dailyLogsStream].
@ProviderFor(dailyLogsStream)
final dailyLogsStreamProvider =
    AutoDisposeStreamProvider<List<DailyLog>>.internal(
      dailyLogsStream,
      name: r'dailyLogsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyLogsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DailyLogsStreamRef = AutoDisposeStreamProviderRef<List<DailyLog>>;
String _$todayLogHash() => r'30d31aae4d54f7806ab426e7b32b31b9f393dcbd';

/// See also [todayLog].
@ProviderFor(todayLog)
final todayLogProvider = AutoDisposeFutureProvider<DailyLog?>.internal(
  todayLog,
  name: r'todayLogProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayLogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayLogRef = AutoDisposeFutureProviderRef<DailyLog?>;
String _$dailyLogControllerHash() =>
    r'4d00ef3df8d7975ed3a9ad82b8315f126e0615b9';

/// See also [DailyLogController].
@ProviderFor(DailyLogController)
final dailyLogControllerProvider =
    AutoDisposeAsyncNotifierProvider<DailyLogController, void>.internal(
      DailyLogController.new,
      name: r'dailyLogControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyLogControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DailyLogController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
