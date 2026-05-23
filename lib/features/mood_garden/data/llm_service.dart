import 'package:her/features/mood_garden/domain/chat_message.dart';

abstract class LLMService {
  String get name;
  bool get isConfigured;

  Future<String> generateResponse({
    required String prompt,
    String? systemContext,
    List<ChatMessage> history = const [],
  });
}
