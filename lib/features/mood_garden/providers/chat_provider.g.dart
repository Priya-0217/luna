// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesHash() => r'b078fd541aa04ab6b8d159bed7168d3f9aaa1975';

/// See also [chatMessages].
@ProviderFor(chatMessages)
final chatMessagesProvider =
    AutoDisposeStreamProvider<List<ChatMessage>>.internal(
      chatMessages,
      name: r'chatMessagesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatMessagesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessagesRef = AutoDisposeStreamProviderRef<List<ChatMessage>>;
String _$chatControllerHash() => r'b6c9fe4652f30d265b7e96bb33bd098393c2a8bd';

/// See also [ChatController].
@ProviderFor(ChatController)
final chatControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChatController, void>.internal(
      ChatController.new,
      name: r'chatControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChatController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
