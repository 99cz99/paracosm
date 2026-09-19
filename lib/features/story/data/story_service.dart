import 'dart:convert';

import '../../../core/db/database.dart';
import '../../../core/network/llm/llm_provider.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/prompt_template.dart';
import '../../../core/world/world_context.dart';

/// A generated story beat: narrative text + the choices offered to the user.
class StoryNodeResult {
  const StoryNodeResult({required this.narrative, required this.choices});

  final String narrative;
  final List<String> choices;
}

/// Generates visual-novel beats from a story's premise + the path so far.
///
/// The provider is injected so the LLM part is testable with a fake.
class StoryService {
  StoryService(this._db);

  final AppDatabase _db;

  Future<StoryNodeResult> generateNode({
    required String storyId,
    required LlmProvider provider,
    String? parentNodeId,
  }) async {
    final story = await _db.getStory(storyId);
    if (story == null) throw AppException('剧本不存在');
    final character = story.characterId == null
        ? null
        : await _db.getCharacter(story.characterId!);
    final path = await _db.getStoryPath(storyId, parentNodeId ?? story.currentNodeId);

    final worldIds = await _db.getStoryWorldIds(storyId);
    if (worldIds.isEmpty && (story.worldId?.isNotEmpty ?? false)) {
      worldIds.add(story.worldId!);
    }
    final worldCtx = await WorldContextBuilder(_db).build(
      worldIds: worldIds,
      worldbookIds: (await _db.getStoryWorldbookIds(storyId)).toSet(),
    );

    final userName = await _db.getSetting('user_name') ?? '我';
    final text =
        await _complete(provider, _prompt(story, character, worldCtx, path, userName));
    final node = _parseNode(text);
    if (node == null) {
      throw AppException('剧情生成失败，请重试');
    }
    return node;
  }

  String _prompt(
    Story story,
    Character? character,
    WorldContext worldCtx,
    List<StoryNode> path,
    String userName,
  ) {
    final parts = <String>['你是视觉小说引擎，生成下一段剧情。'];
    parts.add('剧本名称：${story.name}');
    if (story.description.isNotEmpty) parts.add('剧本简介：${story.description}');
    if (character != null) {
      parts.add('角色：${character.name}\n${_persona(character, userName)}');
    }
    final worldSection = worldCtx.buildWorldSection();
    if (worldSection.isNotEmpty) parts.add(worldSection);
    const worldbookScan = 6;
    final recentForBook = path.length <= worldbookScan
        ? path
        : path.sublist(path.length - worldbookScan);
    final worldbookContext = <String>[
      if (story.description.isNotEmpty) story.description,
      ...recentForBook.map((n) => n.narrative),
    ].join('\n');
    final worldbookSection = worldCtx.buildWorldbookSection(worldbookContext);
    if (worldbookSection.isNotEmpty) parts.add(worldbookSection);
    if (path.isEmpty) {
      parts.add('请生成开场剧情（叙述 + 2-3 个选项）。');
    } else {
      const maxHistory = 15;
      final recent = path.length <= maxHistory
          ? path
          : path.sublist(path.length - maxHistory);
      final flow = recent.map((n) {
        final line = n.narrative;
        final choices = _decodeChoices(n.choicesJson);
        if (n.chosenIndex != null && n.chosenIndex! < choices.length) {
          return '$line\n（用户选择了：${choices[n.chosenIndex!]}）';
        }
        return line;
      }).join('\n');
      parts.add('已发生的剧情：\n$flow');
      if (path.length > maxHistory) {
        parts.add('（前略 ${path.length - maxHistory} 段剧情）');
      }
      parts.add('请生成接下来的剧情（叙述 + 2-3 个选项）。');
    }
    parts.add('若剧情已到达自然结局，choices 返回空数组 [] 表示结局。');
    parts.add('只输出 JSON：{"narrative":"...","choices":["...","...","..."]}');
    return parts.join('\n\n');
  }

  String _persona(Character c, String userName) {
    try {
      final core = jsonDecode(c.corePersonaJson) as Map<String, dynamic>;
      final parts = [
        (core['description'] ?? '').toString(),
        (core['personality'] ?? '').toString(),
      ].where((s) => s.isNotEmpty).toList();
      return applyPlaceholders(parts.join('\n'), c.name, userName);
    } catch (_) {
      return '';
    }
  }

  Future<String> _complete(LlmProvider provider, String prompt) async {
    final buffer = StringBuffer();
    await for (final chunk in provider.streamChat(ChatRequest(
      messages: [ChatMessage(role: 'user', content: prompt)],
      systemPrompt: '你是视觉小说剧情生成器。',
      maxTokens: 4096,
      temperature: 0.8,
    ))) {
      if (chunk.textDelta != null) buffer.write(chunk.textDelta);
    }
    return buffer.toString();
  }

  StoryNodeResult? _parseNode(String text) {
    final cleaned = _stripFences(text);
    var decoded = _tryDecodeJson(cleaned);
    // Some models wrap JSON in prose or emit unescaped newlines; fall back to
    // regex extraction of the narrative + choices fields.
    decoded ??= _extractFields(cleaned);
    if (decoded == null) return null;
    final narrative = (decoded['narrative'] ?? '').toString().trim();
    if (narrative.isEmpty) return null;
    final choices = decoded['choices'] is List
        ? List<String>.from((decoded['choices'] as List)
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty))
        : <String>[];
    return StoryNodeResult(narrative: narrative, choices: choices);
  }

  /// Strips ```json / ``` fences so the first { ... } block is the JSON.
  String _stripFences(String text) {
    var t = text.trim();
    t = t.replaceFirst(RegExp(r'^```[a-zA-Z]*\s*'), '');
    t = t.replaceAll(RegExp(r'```\s*$'), '');
    return t;
  }

  Map<String, dynamic>? _tryDecodeJson(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start < 0 || end <= start) return null;
    try {
      final decoded = jsonDecode(text.substring(start, end + 1));
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// Last-resort: pull `narrative` and `choices` out of a malformed JSON body.
  Map<String, dynamic>? _extractFields(String text) {
    final narrativeMatch =
        RegExp(r'"narrative"\s*:\s*"((?:[^"\\]|\\.)*)"').firstMatch(text);
    final narrative = narrativeMatch?.group(1);
    if (narrative == null) return null;
    final choices = <String>[];
    final choicesMatch =
        RegExp(r'"choices"\s*:\s*\[(.*?)\]', dotAll: true).firstMatch(text);
    if (choicesMatch != null) {
      for (final m in RegExp(r'"((?:[^"\\]|\\.)*)"')
          .allMatches(choicesMatch.group(1)!)) {
        choices.add(m.group(1)!);
      }
    }
    return {'narrative': narrative, 'choices': choices};
  }

  List<String> _decodeChoices(String json) {
    try {
      return List<String>.from(jsonDecode(json) as List<dynamic>);
    } catch (_) {
      return const <String>[];
    }
  }
}
