import 'anthropic_provider.dart';
import 'llm_provider.dart';
import 'openai_compatible_provider.dart';
import 'provider_config.dart';

/// Builds a concrete [LlmProvider] from a resolved [LlmProviderConfig].
LlmProvider buildLlmProvider(LlmProviderConfig config) {
  switch (config.type) {
    case ProviderType.openaiCompatible:
      return OpenAiCompatibleProvider(
        id: config.id,
        baseUrl: config.baseUrl,
        model: config.model,
        apiKey: config.apiKey,
        extraParams: config.extraParams,
      );
    case ProviderType.anthropic:
      return AnthropicProvider(
        id: config.id,
        baseUrl: config.baseUrl,
        model: config.model,
        apiKey: config.apiKey,
        extraParams: config.extraParams,
      );
  }
}
