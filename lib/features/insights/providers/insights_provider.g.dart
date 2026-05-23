// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wellnessTrendsHash() => r'a71846c8cd4d77af130a16bfcfc1e3eada2beea8';

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

/// See also [wellnessTrends].
@ProviderFor(wellnessTrends)
const wellnessTrendsProvider = WellnessTrendsFamily();

/// See also [wellnessTrends].
class WellnessTrendsFamily extends Family<AsyncValue<List<WellnessTrend>>> {
  /// See also [wellnessTrends].
  const WellnessTrendsFamily();

  /// See also [wellnessTrends].
  WellnessTrendsProvider call({int days = 30}) {
    return WellnessTrendsProvider(days: days);
  }

  @override
  WellnessTrendsProvider getProviderOverride(
    covariant WellnessTrendsProvider provider,
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
  String? get name => r'wellnessTrendsProvider';
}

/// See also [wellnessTrends].
class WellnessTrendsProvider
    extends AutoDisposeFutureProvider<List<WellnessTrend>> {
  /// See also [wellnessTrends].
  WellnessTrendsProvider({int days = 30})
    : this._internal(
        (ref) => wellnessTrends(ref as WellnessTrendsRef, days: days),
        from: wellnessTrendsProvider,
        name: r'wellnessTrendsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$wellnessTrendsHash,
        dependencies: WellnessTrendsFamily._dependencies,
        allTransitiveDependencies:
            WellnessTrendsFamily._allTransitiveDependencies,
        days: days,
      );

  WellnessTrendsProvider._internal(
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
    FutureOr<List<WellnessTrend>> Function(WellnessTrendsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WellnessTrendsProvider._internal(
        (ref) => create(ref as WellnessTrendsRef),
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
  AutoDisposeFutureProviderElement<List<WellnessTrend>> createElement() {
    return _WellnessTrendsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WellnessTrendsProvider && other.days == days;
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
mixin WellnessTrendsRef on AutoDisposeFutureProviderRef<List<WellnessTrend>> {
  /// The parameter `days` of this provider.
  int get days;
}

class _WellnessTrendsProviderElement
    extends AutoDisposeFutureProviderElement<List<WellnessTrend>>
    with WellnessTrendsRef {
  _WellnessTrendsProviderElement(super.provider);

  @override
  int get days => (origin as WellnessTrendsProvider).days;
}

String _$generatedInsightsHash() => r'9643965f13b15c35cfb905f94abfde11a5f53223';

/// See also [generatedInsights].
@ProviderFor(generatedInsights)
final generatedInsightsProvider =
    AutoDisposeFutureProvider<List<Insight>>.internal(
      generatedInsights,
      name: r'generatedInsightsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generatedInsightsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GeneratedInsightsRef = AutoDisposeFutureProviderRef<List<Insight>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
