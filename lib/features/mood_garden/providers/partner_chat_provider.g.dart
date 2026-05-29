// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$partnerChatMessagesHash() =>
    r'ea706f081565e7609e38aedb9ccd43f907c2fadb';

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

/// See also [partnerChatMessages].
@ProviderFor(partnerChatMessages)
const partnerChatMessagesProvider = PartnerChatMessagesFamily();

/// See also [partnerChatMessages].
class PartnerChatMessagesFamily
    extends Family<AsyncValue<List<PartnerMessage>>> {
  /// See also [partnerChatMessages].
  const PartnerChatMessagesFamily();

  /// See also [partnerChatMessages].
  PartnerChatMessagesProvider call(String coupleId) {
    return PartnerChatMessagesProvider(coupleId);
  }

  @override
  PartnerChatMessagesProvider getProviderOverride(
    covariant PartnerChatMessagesProvider provider,
  ) {
    return call(provider.coupleId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'partnerChatMessagesProvider';
}

/// See also [partnerChatMessages].
class PartnerChatMessagesProvider
    extends AutoDisposeStreamProvider<List<PartnerMessage>> {
  /// See also [partnerChatMessages].
  PartnerChatMessagesProvider(String coupleId)
    : this._internal(
        (ref) => partnerChatMessages(ref as PartnerChatMessagesRef, coupleId),
        from: partnerChatMessagesProvider,
        name: r'partnerChatMessagesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$partnerChatMessagesHash,
        dependencies: PartnerChatMessagesFamily._dependencies,
        allTransitiveDependencies:
            PartnerChatMessagesFamily._allTransitiveDependencies,
        coupleId: coupleId,
      );

  PartnerChatMessagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coupleId,
  }) : super.internal();

  final String coupleId;

  @override
  Override overrideWith(
    Stream<List<PartnerMessage>> Function(PartnerChatMessagesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PartnerChatMessagesProvider._internal(
        (ref) => create(ref as PartnerChatMessagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coupleId: coupleId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<PartnerMessage>> createElement() {
    return _PartnerChatMessagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PartnerChatMessagesProvider && other.coupleId == coupleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coupleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PartnerChatMessagesRef
    on AutoDisposeStreamProviderRef<List<PartnerMessage>> {
  /// The parameter `coupleId` of this provider.
  String get coupleId;
}

class _PartnerChatMessagesProviderElement
    extends AutoDisposeStreamProviderElement<List<PartnerMessage>>
    with PartnerChatMessagesRef {
  _PartnerChatMessagesProviderElement(super.provider);

  @override
  String get coupleId => (origin as PartnerChatMessagesProvider).coupleId;
}

String _$partnerChatControllerHash() =>
    r'1f6cba5c3e1d379d39c08186d4251df20180dde2';

/// See also [PartnerChatController].
@ProviderFor(PartnerChatController)
final partnerChatControllerProvider =
    AutoDisposeAsyncNotifierProvider<PartnerChatController, void>.internal(
      PartnerChatController.new,
      name: r'partnerChatControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$partnerChatControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PartnerChatController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
