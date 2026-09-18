import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../utils/app_exception.dart';
import '../sse/sse_parser.dart';
import 'llm_errors.dart';
import 'llm_provider.dart';

/// Anthropic Messages API with streaming events.
class AnthropicProvider implements LlmProvider {
  AnthropicProvider({
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
  ProviderType get type => ProviderType.anthropic;

  @override
  Stream<ChatChunk> streamChat(ChatRequest request) async* {
    _cancelToken = CancelToken();
    final url = '${baseUrl.replaceAll(RegExp(r'/+$'), '')}/v1/messages';

    // Anthropic forbids a "system" role inside messages; it lives top-level.
    final messages = request.messages
        .where((m) => m.role != 'system')
        .map((m) => m.toJson())
        .toList();

    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'max_tokens': request.maxTokens,
      'stream': true,
      'temperature': request.temperature,
      'top_p': request.topP,
      if (request.systemPrompt != null && request.systemPrompt!.isNotEmpty)
        'system': request.systemPrompt,
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
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
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
      if (event.event == 'ping' || event.data.isEmpty) continue;
      if (event.event == 'message_stop') return;

      final Object? decoded;
      try {
        decoded = jsonDecode(event.data);
      } on FormatException {
        continue;
      }
      if (decoded is! Map<String, dynamic>) continue;

      if (decoded['type'] == 'error') {
        final err = decoded['error'];
        final msg = err is Map
            ? (err['message']?.toString() ?? 'Unknown API error')
            : 'Unknown API error';
        throw LlmException(msg);
      }

      switch (event.event) {
        case 'content_block_delta':
          final delta = decoded['delta'];
          if (delta is Map && delta['type'] == 'text_delta') {
            yield ChatChunk(
              textDelta: delta['text'] as String?,
              metadata: decoded,
            );
          }
          break;
        case 'message_delta':
          final delta = decoded['delta'];
          final usage = decoded['usage'];
          yield ChatChunk(
            finishReason:
                delta is Map ? delta['stop_reason']?.toString() : null,
            promptTokens: usage is Map ? usage['input_tokens'] as int? : null,
            completionTokens:
                usage is Map ? usage['output_tokens'] as int? : null,
            metadata: decoded,
          );
          break;
        default:
          break;
      }
    }
  }

  @override
  Future<void> cancel() async {
    _cancelToken?.cancel();
    _cancelToken = null;
  }
}
