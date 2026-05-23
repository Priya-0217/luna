import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:her/features/from_him/data/from_him_repository.dart';
import 'package:her/features/from_him/domain/love_message.dart';
import 'package:her/features/from_him/domain/memory_photo.dart';
import 'package:her/features/from_him/domain/voice_note.dart';

part 'from_him_provider.g.dart';

@riverpod
Future<List<LoveMessage>> fromHimMessages(FromHimMessagesRef ref) async {
  return ref.watch(fromHimRepositoryProvider).getMessages();
}

@riverpod
Future<List<VoiceNote>> fromHimVoiceNotes(FromHimVoiceNotesRef ref) async {
  return ref.watch(fromHimRepositoryProvider).getVoiceNotes();
}

@riverpod
Future<List<MemoryPhoto>> fromHimPhotos(FromHimPhotosRef ref) async {
  return ref.watch(fromHimRepositoryProvider).getPhotos();
}

@riverpod
class FromHimNotifier extends _$FromHimNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> unlockMessage(String messageId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(fromHimRepositoryProvider).unlockMessage(messageId);
      ref.invalidate(fromHimMessagesProvider);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(fromHimRepositoryProvider).refreshAll();
      ref.invalidate(fromHimMessagesProvider);
      ref.invalidate(fromHimVoiceNotesProvider);
      ref.invalidate(fromHimPhotosProvider);
    });
  }
}
