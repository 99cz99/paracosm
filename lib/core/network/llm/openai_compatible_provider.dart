import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utils/app_exception.dart';
import '../sse/sse_parser.dart';
import 'llm_errors.dart';
import 'llm_provider.dart';

/// OpenAI-compatible chat completions with SSE streaming.
///
/// Works with any provider exposing `POST {baseUrl}/chat/completions`
/// (DeepSeek, Kimi, GLM, SiliconFlow, OpenAI, …). Only baseUrl + model differ.
class OpenAiCompatibleProvider implements LlmProvider {
  OpenAiCompatibleProvider({
    required this.id,
    required this.baseUrl,
    required this.model,
    required this.apiKey,
    this.extraParams = const {},
    Dio? dio,
  }) : _dio = dio ?? Dio();

  @override
  final String id;
  final String baseUrl;
  final String model;
  final String apiKey;
  final Map<String, dynamic> extraParams;
  final Dio _dio;

  CancelToken? _cancelToken;

  @override
  ProviderType get type => ProviderType.openaiCompatible;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    _cancelToken = CancelToken();
    final url = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/chat/completions';

    final messages = <Map<String, dynamic>>[
      if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty)
        {'role': 'system', 'content': request.systemPrompt},
      ...request.messages.map((m) => m.toJson()),
    ];

    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'stream': true,
      // Ask OpenAI-compatible backends (DeepSeek/Kimi/GLM/SiliconFlow/OpenAI)
      // to include the per-request token usage block in the final SSE chunk.
      'stream_options': {'include_usage': true},
      'temperature': request.temperature,
      'top_p': request.topP,
      'max_tokens': request.maxTokens,
      if (request.presencePenalty != null)
        'presence_penalty': request.presencePenalty,
      if (request.frequencyPenalty != null)
        'frequency_penalty': request.frequencyPenalty,
      ...extraParams,
    };

    final Response<ResponseBody> response;
    try {
      response = await _dio.post<ResponseBody>(
        url,
        data: body,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }

    final lineStream = utf8.decoder
        .bind(response.data!.stream)
        .transform(const LineSplitter());

    await for (final event in lineStream.transform(SseParser())) {
      if (event.data == '[DONE]') return;

      final Object? decoded;
      try {
        decoded = jsonDecode(event.data);
      } on FormatException {
        continue; // keepalive / partial line
      }
      if (decoded is! Map<String, dynamic>) continue;

      final error = decoded['error'];
      if (error != null) {
        final msg = error is Map
            ? (error['message']?.toString() ?? 'Unknown API error')
            : error.toString();
        throw LlmException(msg);
      }

      final choices = decoded['choices'];
      if (choices is! List || choices.isEmpty) continue;
      final choice = choices.first;
      if (choice is! Map<String, dynamic>) continue;

      String? text;
      final delta = choice['delta'];
      if (delta is Map<String, dynamic>) {
        final c = delta['content'];
        if (c is String && c.isNotEmpty) text = c;
      }

      final finishReason = choice['finish_reason']?.toString();
      final usage = decoded['usage'];
      int? promptTokens;
      int? completionTokens;
      if (usage is Map<String, dynamic>) {
        promptTokens = usage['prompt_tokens'] as int?;
        completionTokens = usage['completion_tokens'] as int?;
      }

      if (text == null && finishReason == null && promptTokens == null) {
        continue;
      }

      yield ChatChunk(
        textDelta: text,
        finishReason: finishReason,
        promptTokens: promptTokens,
        completionTokens: completionTokens,
        metadata: decoded,
      );
    }
  }

  @override
  Future<void> cancel() async {
    _cancelToken?.cancel();
    _cancelToken = null;
  }
}
