enum LLMProviderType {
  gemini,
  openai,
  anthropic,
  custom,
  mock,
}

class LLMConfig {
  final LLMProviderType type;
  final String apiKey;
  final String model;
  final String? baseUrl;
  final Map<String, String>? additionalHeaders;

  const LLMConfig({
    required this.type,
    required this.apiKey,
    required this.model,
    this.baseUrl,
    this.additionalHeaders,
  });

  factory LLMConfig.gemini(String apiKey, {String model = 'gemini-3.5-flash'}) {
    return LLMConfig(
      type: LLMProviderType.gemini,
      apiKey: apiKey,
      model: model,
    );
  }

  factory LLMConfig.openai(String apiKey, {String model = 'gpt-4o-mini'}) {
    return LLMConfig(
      type: LLMProviderType.openai,
      apiKey: apiKey,
      model: model,
    );
  }

  factory LLMConfig.anthropic(String apiKey, {String model = 'claude-3-5-sonnet-20240620'}) {
    return LLMConfig(
      type: LLMProviderType.anthropic,
      apiKey: apiKey,
      model: model,
    );
  }
}
