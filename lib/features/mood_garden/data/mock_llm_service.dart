import 'package:her/features/mood_garden/domain/chat_message.dart';
import 'package:her/features/mood_garden/data/llm_service.dart';

class MockLLMService implements LLMService {
  @override
  String get name => 'Mock';

  @override
  bool get isConfigured => true;

  @override
  Future<String> generateResponse({
    required String prompt,
    String? systemContext,
    List<ChatMessage> history = const [],
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final lower = prompt.toLowerCase();
    if (lower.contains('cramp') || lower.contains('pain')) {
      return "Oh sweetheart, I'm so sorry you're hurting 💗 A heating pad, some chamomile tea, and resting are your best friends right now. He'd want you to take it easy today. 🌸";
    }
    if (lower.contains('sad') || lower.contains('cry')) {
      return "It's okay to feel this way, love. Your feelings are valid and they will pass 🌧️ Take a deep breath. You're braver than you know. 💕";
    }
    if (lower.contains('anxious') || lower.contains('stress')) {
      return "Let's take a breath together 🌿 In for 4 counts, hold for 4, out for 6. You've handled hard things before, and you'll handle this too. 💗";
    }
    return "I'm here with you, always 🌸 Tell me more about how you're feeling, and we'll figure it out together. 💕";
  }
}
