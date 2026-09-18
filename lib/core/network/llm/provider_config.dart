import 'llm_provider.dart';

/// Domain model for a user-configured LLM provider.
///
/// Distinct from the Drift row of the same concept: the API key is resolved
/// from secure storage and attached here at runtime, never persisted in SQLite.
class LlmProviderConfig {
  LlmProviderConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.baseUrl,
    required this.model,
    this.apiKey = '',
    this.extraParams = const {},
    this.memoryModel,
  });

  final String id;
  final String name;
  final ProviderType type;
  final String baseUrl;
  final String model;
  final String apiKey;
  final Map<String, dynamic> extraParams;

  /// 记忆抽取/摘要用的模型名；为 null 时用 [model]。
  final String? memoryModel;
}

/// Built-in presets shown in the provider settings screen (no API key).
class ProviderPreset {
  const ProviderPreset(this.name, this.type, this.baseUrl, this.model);

  final String name;
  final ProviderType type;
  final String baseUrl;
  final String model;
}

const List<ProviderPreset> kProviderPresets = [
  ProviderPreset('DeepSeek', ProviderType.openaiCompatible,
      'https://api.deepseek.com/v1', 'deepseek-chat'),
  ProviderPreset('Kimi (Moonshot)', ProviderType.openaiCompatible,
      'https://api.moonshot.cn/v1', 'moonshot-v1-8k'),
  ProviderPreset('GLM (智谱)', ProviderType.openaiCompatible,
      'https://open.bigmodel.cn/api/paas/v4', 'glm-4-plus'),
  ProviderPreset('SiliconFlow', ProviderType.openaiCompatible,
      'https://api.siliconflow.cn/v1', 'deepseek-ai/DeepSeek-V3'),
  ProviderPreset('OpenAI', ProviderType.openaiCompatible,
      'https://api.openai.com/v1', 'gpt-4o-mini'),
  ProviderPreset('Anthropic', ProviderType.anthropic,
      'https://api.anthropic.com', 'claude-sonnet-4-5'),
];
