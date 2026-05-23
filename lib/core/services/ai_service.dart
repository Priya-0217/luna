/// AI Companion Service — Claude API stub.
///
/// The actual Anthropic API key and implementation will be added once the key
/// is available. This stub provides the same interface so the rest of the app
/// can be built without the key.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_service.g.dart';

@riverpod
AiService aiService(AiServiceRef ref) => AiService();

class AiService {
  // TODO: Replace with real Claude API key via --dart-define or .env file
  static const String _apiKey = '';
  static const String _model = 'claude-sonnet-4-20250514';

  bool get isConfigured => _apiKey.isNotEmpty;

  /// Sends a message to the AI companion and returns a response.
  /// Returns a warm fallback message if the API key is not configured.
  Future<String> chat({
    required String userMessage,
    required String systemContext,
    List<Map<String, String>> history = const [],
  }) async {
    if (!isConfigured) {
      return _fallbackResponse(userMessage);
    }
    // TODO: Implement real Claude API call via dio
    // POST https://api.anthropic.com/v1/messages
    // Headers: x-api-key, anthropic-version, content-type
    // Body: { model, max_tokens, system, messages }
    throw UnimplementedError('Configure API key to enable AI companion');
  }

  String _fallbackResponse(String input) {
    final lower = input.toLowerCase();
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
