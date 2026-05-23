// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentLogsHash() => r'f97d4e9ed502b71d8f177f135f98e24cfa08b582';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recentLogs].
@ProviderFor(recentLogs)
const recentLogsProvider = RecentLogsFamily();

/// See also [recentLogs].
class RecentLogsFamily extends Family<AsyncValue<List<DailyLogEntry>>> {
  /// See also [recentLogs].
  const RecentLogsFamily();

  /// See also [recentLogs].
  RecentLogsProvider call({int days = 30}) {
    return RecentLogsProvider(days: days);
  }

  @override
  RecentLogsProvider getProviderOverride(
    covariant RecentLogsProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentLogsProvider';
}

/// See also [recentLogs].
class RecentLogsProvider
    extends AutoDisposeFutureProvider<List<DailyLogEntry>> {
  /// See also [recentLogs].
  RecentLogsProvider({int days = 30})
    : this._internal(
        (ref) => recentLogs(ref as RecentLogsRef, days: days),
        from: recentLogsProvider,
        name: r'recentLogsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentLogsHash,
        dependencies: RecentLogsFamily._dependencies,
        allTransitiveDependencies: RecentLogsFamily._allTransitiveDependencies,
        days: days,
      );

  RecentLogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<List<DailyLogEntry>> Function(RecentLogsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentLogsProvider._internal(
        (ref) => create(ref as RecentLogsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DailyLogEntry>> createElement() {
    return _RecentLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentLogsProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentLogsRef on AutoDisposeFutureProviderRef<List<DailyLogEntry>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _RecentLogsProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyLogEntry>>
    with RecentLogsRef {
  _RecentLogsProviderElement(super.provider);

  @override
  int get days => (origin as RecentLogsProvider).days;
}

String _$dailyLogHash() => r'c19446a1efcfa147df23da86f8db95fb2d2dfee1';

/// See also [DailyLog].
@ProviderFor(DailyLog)
final dailyLogProvider =
    AutoDisposeAsyncNotifierProvider<DailyLog, DailyLogEntry?>.internal(
      DailyLog.new,
      name: r'dailyLogProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dailyLogHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DailyLog = AutoDisposeAsyncNotifier<DailyLogEntry?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
