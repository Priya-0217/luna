import 'package:her/features/auth/providers/auth_provider.dart';
import 'package:her/features/mood_garden/data/partner_chat_repository.dart';
import 'package:her/features/mood_garden/domain/partner_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'partner_chat_provider.g.dart';

@riverpod
Stream<List<PartnerMessage>> partnerChatMessages(
  PartnerChatMessagesRef ref,
  String coupleId,
) {
  return ref.watch(partnerChatRepositoryProvider).watchMessages(coupleId);
}

@riverpod
class PartnerChatController extends _$PartnerChatController {
  @override
  FutureOr<void> build() async {}

  final _uuid = const Uuid();

  Future<void> sendMessage({
    required String coupleId,
    String? content,
    String? illustrationKey,
    Map<String, dynamic>? metadata,
    PartnerMessage? replyingTo,
  }) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;

    final replyGiftLabel = replyingTo?.metadata['giftLabel'];
    final replyText =
        (replyingTo?.content != null && replyingTo!.content!.trim().isNotEmpty)
        ? replyingTo.content
        : (replyGiftLabel is String && replyGiftLabel.isNotEmpty)
        ? 'Gift: $replyGiftLabel'
        : null;

    final message = PartnerMessage(
      id: _uuid.v4(),
      senderId: user.uid,
      senderName: user.displayName.isNotEmpty
          ? user.displayName
          : (user.role == 'him' ? 'Him' : 'Her'),
      content: content,
      illustrationKey: illustrationKey,
      timestamp: DateTime.now(),
      replyToId: replyingTo?.id,
      replyToText: replyText,
      replyToSenderName: replyingTo?.senderName,
      replyToIllustrationKey: replyingTo?.illustrationKey,
      metadata: metadata ?? const {},
    );

    await ref
        .read(partnerChatRepositoryProvider)
        .sendMessage(coupleId, message);
  }

  Future<void> toggleReaction({
    required String coupleId,
    required String messageId,
    required String emoji,
  }) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;

    await ref
        .read(partnerChatRepositoryProvider)
        .reactToMessage(
          coupleId: coupleId,
          messageId: messageId,
          emoji: emoji,
          userId: user.uid,
        );
  }

  Future<void> clearHistory(String coupleId) async {
    await ref.read(partnerChatRepositoryProvider).clearHistory(coupleId);
  }
}
