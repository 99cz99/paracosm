/// The single abstraction all chat providers implement.
///
/// Two real implementations ship in MVP: [OpenAiCompatibleProvider] (covers
/// DeepSeek / Kimi / GLM / SiliconFlow / OpenAI) and [AnthropicProvider]
/// (Claude Messages). [MockStreamProvider] exists for keyless tests.
library;

enum ProviderType { openaiCompatible, anthropic }

/// A chat message with a standard role. `system` is only honored by providers
/// that have a dedicated system slot (Anthropic takes it via [ChatRequest]).
class ChatMessage {
  const ChatMessage({required this.role, required this.content});

  final String role; // user / assistant / system
  final String content;

  Map<String, dynamic> toJson() => {'role': role, 'content': content};
}

class ChatRequest {
  ChatRequest({
    required this.messages,
    this.systemPrompt,
    this.temperature = 1.2,
    this.topP = 1.0,
    this.maxTokens = 4096,
    this.presencePenalty,
    this.frequencyPenalty,
    this.extra = const {},
  });

  final List<ChatMessage> messages;
  final String? systemPrompt;
  final double temperature;
  final double topP;
  final int maxTokens;

  /// OpenAI-compatible sampling penalties; null = omit (Anthropic ignores).
  final double? presencePenalty;
  final double? frequencyPenalty;
  final Map<String, dynamic> extra;
}

/// One increment of a streamed completion.
class ChatChunk {
  ChatChunk({
    this.textDelta,
    this.finishReason,
    this.promptTokens,
    this.completionTokens,
    this.metadata,
  });

  final String? textDelta;
  final String? finishReason;
  final int? promptTokens;
  final int? completionTokens;
  final Map<String, dynamic>? metadata;
}

abstract class LlmProvider {
  /// Stable identifier (usually the provider config id).
  String get id;

  ProviderType get type;

  /// Streams the completion as it arrives. Implementations must close the
  /// stream on completion and surface failures as stream errors.
  Stream<ChatChunk> streamChat(ChatRequest request);

  /// Cancels the in-flight request, if any.
  Future<void> cancel();
}
