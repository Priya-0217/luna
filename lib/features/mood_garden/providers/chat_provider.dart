import 'package:her/features/mood_garden/data/chat_repository.dart';
import 'package:her/features/mood_garden/domain/chat_message.dart';
import 'package:her/features/mood_garden/providers/llm_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_provider.g.dart';

@riverpod
Stream<List<ChatMessage>> chatMessages(ChatMessagesRef ref) {
  return ref.watch(chatRepositoryProvider).watchMessages();
}

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() async {}

  final _uuid = const Uuid();

  Future<void> sendMessage(String content) async {
    final repository = ref.read(chatRepositoryProvider);
    final llm = ref.read(llmServiceProvider);
    
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: content,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    // Save user message
    await repository.saveMessage(userMessage);

    // Create placeholder for assistant message
    final assistantId = _uuid.v4();
    
    try {
      // Get current history for context
      // Note: In a real app, you might want to fetch this from the stream's current value
      final history = await ref.read(chatMessagesProvider.future);

      final response = await llm.generateResponse(
        prompt: content,
        history: history,
        systemContext: "You are Luna, a gentle and deeply caring emotional companion. "
            "Your purpose is to provide comfort, advice, and a listening ear. "
            "Your tone is always soft, warm, and supportive. "
            "You are part of an app that tracks her cycle and well-being, "
            "so you can offer suggestions based on her needs.",
      );

      final assistantMessage = ChatMessage(
        id: assistantId,
        content: response,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );

      await repository.saveMessage(assistantMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
        id: assistantId,
        content: "I'm so sorry, love, I had a little trouble connecting. Could you try again? 💕",
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        isError: true,
      );
      await repository.saveMessage(errorMessage);
    }
  }

  Future<void> clearHistory() async {
    await ref.read(chatRepositoryProvider).clearHistory();
  }
}
