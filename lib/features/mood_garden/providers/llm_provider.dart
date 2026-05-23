import 'package:her/features/mood_garden/data/llm_service.dart';
import 'package:her/features/mood_garden/data/universal_llm_service.dart';
import 'package:her/features/mood_garden/domain/llm_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'llm_provider.g.dart';

// Environment variables for API keys
const String _geminiApiKey = "AIzaSyDmydlzoOqdg5Ics6X-Q8GYDgqj6Hij1yA";
const String _openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');
const String _anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

@riverpod
LLMService llmService(LlmServiceRef ref) {
  // Logic to determine which service to use based on available keys
  if (_geminiApiKey.isNotEmpty) {
    return UniversalLLMService(LLMConfig.gemini(_geminiApiKey));
  } else if (_openAiApiKey.isNotEmpty) {
    return UniversalLLMService(LLMConfig.openai(_openAiApiKey));
  } else if (_anthropicApiKey.isNotEmpty) {
    return UniversalLLMService(LLMConfig.anthropic(_anthropicApiKey));
  }

  // Fallback to mock service if no keys are found
  return UniversalLLMService(const LLMConfig(
    type: LLMProviderType.mock,
    apiKey: '',
    model: 'mock',
  ));
}
