import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:her/features/mood_garden/data/llm_service.dart';
import 'package:her/features/mood_garden/domain/chat_message.dart';
import 'package:her/features/mood_garden/domain/llm_config.dart';

class UniversalLLMService implements LLMService {
  final LLMConfig config;
  final Dio _dio = Dio();

  UniversalLLMService(this.config);

  @override
  String get name => config.type.name.toUpperCase();

  @override
  bool get isConfigured => config.apiKey.isNotEmpty || config.type == LLMProviderType.mock;

  @override
  Future<String> generateResponse({
    required String prompt,
    String? systemContext,
    List<ChatMessage> history = const [],
  }) async {
    debugPrint('UniversalLLMService: Generating response for provider: $name');
    
    // Auto-discovery of models ONLY if a 404 error occurs later
    // or keep it here for initial debugging as requested
    // await _listGeminiModels();

    if (!isConfigured) {
      debugPrint('UniversalLLMService: Error - Provider $name is not configured (missing API Key)');
      return "API Key not found, love. 💕";
    }

    try {
      final response = await switch (config.type) {
        LLMProviderType.gemini => _handleGemini(prompt, systemContext, history),
        LLMProviderType.openai => _handleOpenAI(prompt, systemContext, history),
        LLMProviderType.anthropic => _handleAnthropic(prompt, systemContext, history),
        LLMProviderType.mock => _handleMock(prompt),
        LLMProviderType.custom => _handleCustom(prompt, systemContext, history),
      };
      debugPrint('UniversalLLMService: Successfully received response from $name');
      return response;
    } catch (e) {
      debugPrint('UniversalLLMService: EXCEPTION from $name: $e');
      if (e is DioException) {
        final errorData = e.response?.data;
        debugPrint('Dio Error Data: $errorData');
        debugPrint('Dio Error Status: ${e.response?.statusCode}');
        
        // Handle specific model not found errors
         if (e.response?.statusCode == 404 && errorData is Map && errorData['error']?['message']?.contains('not found')) {
           if (config.type == LLMProviderType.gemini) {
             await _listGeminiModels();
           }
           return "I'm so sorry, love. I'm having trouble finding the right model to talk to you. Please check my settings. 💕";
         }
      }
      return "I'm having a little trouble thinking right now. Could you try again? 💕";
    }
  }

  Future<void> _listGeminiModels() async {
    try {
      final url = 'https://generativelanguage.googleapis.com/v1beta/models?key=${config.apiKey}';
      debugPrint('UniversalLLMService: Listing available Gemini models from $url');
      final response = await _dio.get(url);
      final List models = response.data['models'];
      debugPrint('UniversalLLMService: Available Gemini Models:');
      for (var model in models) {
        debugPrint('  - ${model['name']} (Methods: ${model['supportedGenerationMethods']})');
      }
    } catch (e) {
      debugPrint('UniversalLLMService: Failed to list Gemini models: $e');
    }
  }

  Future<String> _handleGemini(String prompt, String? system, List<ChatMessage> history) async {
    // Using v1beta as it often has better support for newer model aliases
    final url = '${config.baseUrl ?? 'https://generativelanguage.googleapis.com/v1beta'}/models/${config.model}:generateContent?key=${config.apiKey}';
    debugPrint('UniversalLLMService: Calling Gemini API at $url');
    
    final contents = history.map((msg) => {
      "role": msg.role == MessageRole.user ? "user" : "model",
      "parts": [{"text": msg.content}]
    }).toList();

    // Gemini 1.5 prefers system instruction in a specific field, 
    // but for simplicity in this universal wrapper, we'll keep it in the prompt if needed
    // or use the 'system_instruction' field if the API supports it in this format.
    // For now, let's use the user prompt approach which is most compatible.
    
    final fullPrompt = system != null ? "$system\n\nUser: $prompt" : prompt;

    contents.add({
      "role": "user",
      "parts": [{"text": fullPrompt}]
    });

    final response = await _dio.post(url, data: {"contents": contents});
    
    if (response.data['candidates'] == null || response.data['candidates'].isEmpty) {
      debugPrint('UniversalLLMService: Gemini returned empty candidates. Full response: ${response.data}');
      throw Exception('Gemini returned no response candidates');
    }

    return response.data['candidates'][0]['content']['parts'][0]['text'];
  }

  Future<String> _handleOpenAI(String prompt, String? system, List<ChatMessage> history) async {
    final url = '${config.baseUrl ?? 'https://api.openai.com/v1'}/chat/completions';
    
    final messages = <Map<String, String>>[];
    if (system != null) messages.add({"role": "system", "content": system});
    
    for (var msg in history) {
      messages.add({
        "role": msg.role == MessageRole.user ? "user" : "assistant",
        "content": msg.content
      });
    }
    
    messages.add({"role": "user", "content": prompt});

    final response = await _dio.post(
      url,
      data: {
        "model": config.model,
        "messages": messages,
      },
      options: Options(headers: {
        "Authorization": "Bearer ${config.apiKey}",
        ...?config.additionalHeaders,
      }),
    );
    return response.data['choices'][0]['message']['content'];
  }

  Future<String> _handleAnthropic(String prompt, String? system, List<ChatMessage> history) async {
    final url = '${config.baseUrl ?? 'https://api.anthropic.com/v1'}/messages';
    
    final messages = history.map((msg) => {
      "role": msg.role == MessageRole.user ? "user" : "assistant",
      "content": msg.content
    }).toList();

    messages.add({"role": "user", "content": prompt});

    final response = await _dio.post(
      url,
      data: {
        "model": config.model,
        "max_tokens": 1024,
        "system": system,
        "messages": messages,
      },
      options: Options(headers: {
        "x-api-key": config.apiKey,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
        ...?config.additionalHeaders,
      }),
    );
    return response.data['content'][0]['text'];
  }

  Future<String> _handleMock(String prompt) async {
    await Future.delayed(const Duration(seconds: 1));
    return "I'm your gentle Luna companion. (Mock Response for: $prompt) 💕";
  }

  Future<String> _handleCustom(String prompt, String? system, List<ChatMessage> history) async {
    if (config.baseUrl == null) throw Exception("Base URL required for custom LLM");
    // Default to OpenAI-compatible format for custom endpoints (like Ollama or LocalAI)
    return _handleOpenAI(prompt, system, history);
  }
}
