import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/network/llm/provider_factory.dart';
import '../../../core/network/llm/translator.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import 'contacts_providers.dart';

/// Per-character greeting-translation progress, exposed so the detail page can
/// show a non-blocking indicator while the (background) translation runs.
class TranslationProgress {
  const TranslationProgress({
    required this.done,
    required this.total,
    required this.running,
    this.error,
  });

  final int done;
  final int total;
  final bool running;
  final String? error;
}

/// Global (non-autoDispose) controller for translating a character's English
/// greetings to Chinese. Runs in the background so the user can leave the
/// detail page and the translation keeps going.
class TranslationController
    extends Notifier<Map<String, TranslationProgress>> {
  @override
  Map<String, TranslationProgress> build() => const {};

  Future<void> startTranslate(String characterId) async {
    if (state[characterId]?.running == true) return;

    final db = ref.read(dbProvider);
    final character = await db.getCharacter(characterId);
    if (character == null) return;

    Map<String, dynamic> core;
    try {
      core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    // Already translated — don't re-translate / overwrite the cache.
    final cachedZh = core['greetings_zh'];
    if (cachedZh is List && cachedZh.isNotEmpty) return;

    // Preserve original formatting: trim + exact dedupe only (no whitespace
    // collapsing, or newline/paragraph structure is lost).
    final greetings = <String>[];
    void add(String s) {
      final t = s.trim();
      if (t.isEmpty || greetings.contains(t)) return;
      greetings.add(t);
    }

    add((core['first_mes'] ?? '').toString());
    final alts = core['alternate_greetings'];
    if (alts is List) {
      for (final a in alts) {
        add(a.toString());
      }
    }
    if (greetings.isEmpty) return;

    final config =
        await resolveActiveProvider(db, ref.read(secureKeyStoreProvider));
    if (config == null) {
      state = {
        ...state,
        characterId: TranslationProgress(
          done: 0,
          total: greetings.length,
          running: false,
          error: '请先在「我」中配置 API Provider',
        ),
      };
      return;
    }

    final total = greetings.length;
    state = {
      ...state,
      characterId: TranslationProgress(done: 0, total: total, running: true),
    };

    final zh = <String>[];
    try {
      for (var i = 0; i < greetings.length; i++) {
        final g = greetings[i];
        final t = needsTranslation(g)
            ? await translateToChinese(buildLlmProvider(config), g)
            : g;
        zh.add(t.isNotEmpty ? t : g);
        state = {
          ...state,
          characterId:
              TranslationProgress(done: i + 1, total: total, running: true),
        };
      }

      core['greetings_zh'] = zh;
      await db.updateCharacter(
        characterId,
        CharactersCompanion(
          corePersonaJson: Value(jsonEncode(core)),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
      ref.invalidate(characterProvider(characterId));
      state = {
        ...state,
        characterId:
            TranslationProgress(done: total, total: total, running: false),
      };
    } catch (e) {
      state = {
        ...state,
        characterId: TranslationProgress(
          done: state[characterId]?.done ?? 0,
          total: total,
          running: false,
          error: '$e',
        ),
      };
    }
  }
}

final translationControllerProvider =
    NotifierProvider<TranslationController, Map<String, TranslationProgress>>(
        TranslationController.new);
