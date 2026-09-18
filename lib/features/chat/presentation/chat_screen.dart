import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/commands/slash_commands.dart';
import '../../../core/db/database.dart';
import '../../../core/network/llm/token_estimator.dart';
import '../../../core/providers/db_providers.dart';
import '../../../core/providers/llm_providers.dart';
import '../../../core/utils/app_exception.dart';
import '../../../core/utils/dialogs.dart';
import '../data/session_exporter.dart';
import '../data/session_repository.dart';
import 'chat_controller.dart';
import 'chat_providers.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _inputController = TextEditingController();
  late final FocusNode _inputFocus = FocusNode(onKeyEvent: _onKeyEvent);

  // Slash-command popup state.
  bool _slashOpen = false;
  List<SlashCommand> _slashMatches = const [];
  int _slashIndex = 0;
  bool _suppressSlash = false;

  @override
  void initState() {
    super.initState();
    // Rebuild on every keystroke so the token chip tracks the input text.
    _inputController.addListener(_onInputTick);
  }

  void _onInputTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // The chat controller is global; leaving this screen must NOT cancel an
    // in-flight reply (the user can background the app and let it finish).
    // `sendMessage` already guards persisting against deleted sessions.
    _inputFocus.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    try {
      await ref
          .read(chatControllerProvider.notifier)
          .sendMessage(widget.sessionId, text);
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context,
          e is AppException ? e.message : '发送失败：$e',
        );
      }
    }
  }

  void _cancel() => ref.read(chatControllerProvider.notifier).cancel();

  // --- Slash-command popup ---

  void _onInputChanged(String text) {
    if (_suppressSlash) return;
    final match = RegExp(r'^/(\S*)$').firstMatch(text);
    if (match == null) {
      if (_slashOpen) setState(() => _slashOpen = false);
      return;
    }
    final prefix = match.group(1)!;
    final matches =
        allSlashCommands.where((c) => c.name.startsWith(prefix)).toList();
    setState(() {
      _slashOpen = matches.isNotEmpty;
      _slashMatches = matches;
      _slashIndex = 0;
    });
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!_slashOpen || _slashMatches.isEmpty) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveSlash(1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveSlash(-1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() => _slashOpen = false);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _moveSlash(int delta) {
    if (_slashMatches.isEmpty) return;
    setState(() {
      _slashIndex =
          (_slashIndex + delta + _slashMatches.length) % _slashMatches.length;
    });
  }

  /// Fills the highlighted command into the input (does not execute it).
  void _chooseSlash(int index) {
    if (index < 0 || index >= _slashMatches.length) return;
    final text = '/${_slashMatches[index].name}';
    _suppressSlash = true;
    _inputController.text = text;
    _inputController.selection = TextSelection.collapsed(offset: text.length);
    setState(() {
      _slashOpen = false;
      _slashMatches = const [];
    });
    _suppressSlash = false;
  }

  /// TextField submit: if the popup is open, select the highlighted command;
  /// otherwise send (which executes `/`-prefixed input as a command).
  void _onSubmit(String _) {
    if (_slashOpen && _slashMatches.isNotEmpty) {
      _chooseSlash(_slashIndex);
      return;
    }
    if (ref.read(chatControllerProvider).isGenerating) return;
    _send();
  }

  /// Recalls (deletes) a persisted message after confirmation.
  Future<void> _recall(Message msg) async {
    if (!mounted) return;
    final ok = await showConfirmDialog(
      context,
      title: '撤回消息',
      message: '确定撤回这条消息吗？',
      confirmLabel: '撤回',
    );
    if (!ok) return;
    await ref.read(dbProvider).deleteMessage(msg.id);
  }

  /// Cycles the opening message by [delta] (+1 next, -1 previous).
  Future<void> _switchGreeting(int delta) async {
    final db = ref.read(dbProvider);
    final session = await db.getSession(widget.sessionId);
    if (session == null) return;
    final greetings =
        await SessionRepository(db).getGreetings(session.characterId);
    if (greetings.length < 2) return;

    final messages = await db.getMessages(widget.sessionId);
    final current = messages.isEmpty ? '' : messages.first.content;
    var index = greetings.indexOf(current);
    if (index < 0) index = 0;
    final next = (index + delta + greetings.length) % greetings.length;
    await db.replaceOpeningMessage(widget.sessionId, greetings[next]);
  }

  /// Picks a random opening message.
  Future<void> _randomGreeting() async {
    final db = ref.read(dbProvider);
    final session = await db.getSession(widget.sessionId);
    if (session == null) return;
    final greetings =
        await SessionRepository(db).getGreetings(session.characterId);
    if (greetings.length < 2) return;
    final index = Random().nextInt(greetings.length);
    await db.replaceOpeningMessage(widget.sessionId, greetings[index]);
  }

  Future<void> _deleteSession() async {
    final ok = await showConfirmDialog(
      context,
      title: '删除会话',
      message: '确定删除该会话？消息记录和记忆也会被删除。',
    );
    if (!ok) return;
    await SessionRepository(ref.read(dbProvider))
        .deleteSession(widget.sessionId);
    if (mounted) context.pop();
  }

  Future<void> _exportSession() async {
    final db = ref.read(dbProvider);
    final session = await db.getSession(widget.sessionId);
    if (session == null) return;
    final messages = await db.getMessages(widget.sessionId);
    final json = exportSessionJson(session, messages);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('导出会话'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Text(json, style: const TextStyle(fontSize: 12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: json));
              Navigator.of(dialogContext).pop();
            },
            child: const Text('复制 JSON'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Future<void> _sessionSettings() async {
    final db = ref.read(dbProvider);
    final session = await db.getSession(widget.sessionId);
    if (session == null || !mounted) return;
    final configs = ref.read(providerConfigsProvider).value ?? [];
    final presets = await db.watchPresets().first;
    if (!mounted) return;

    final result = await showDialog<_SessionSettingsResult>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _SessionSettingsDialog(
        session: session,
        configs: configs,
        presets: presets,
      ),
    );
    if (result == null) return;

    await db.updateSession(widget.sessionId, SessionsCompanion(
      providerId: Value(result.providerId),
      temperature: Value(result.temperature),
      topP: Value(result.topP),
      maxTokens: Value(result.maxTokens),
      presencePenalty: Value(result.presencePenalty),
      frequencyPenalty: Value(result.frequencyPenalty),
    ));
    if (mounted) await showSuccessDialog(context, '已保存');
  }

  bool _hasAlternates(Character? character) {
    if (character == null) return false;
    try {
      final core = jsonDecode(character.corePersonaJson) as Map<String, dynamic>;
      final alts = core['alternate_greetings'];
      return alts is List && alts.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.sessionId));
    final character = ref.watch(chatCharacterProvider(widget.sessionId)).value;
    final characterId = character?.id;
    final title = character?.name ?? '聊天';
    final hasAlternates = _hasAlternates(character);
    final showToken = ref.watch(tokenDisplayEnabledProvider).value ?? false;
    final tokenUsage = ref.watch(tokenUsageProvider(widget.sessionId)).value;
    final userInputTokens = estimateTokens(_inputController.text);

    final messages = messagesAsync.value ?? <Message>[];
    final hasUserReply =
        messages.any((m) => m.role == 'user' && m.type != 'command');
    final reversed = messages.reversed.toList();
    // Only show the streaming bubble for THIS session — a stream running in
    // another conversation must not leak into this one. Intentionally do NOT
    // select `streamingText` here: it changes every delta and would rebuild
    // the whole screen. The bubble widget below watches `streamingText` itself.
    final showStreaming = ref.watch(chatControllerProvider.select(
        (s) => s.isGenerating && s.streamingSessionId == widget.sessionId));

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            if (characterId != null) context.push('/contacts/$characterId');
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(title),
          ),
        ),
        actions: [
          if (hasAlternates && !hasUserReply) ...[
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: '上一条开场白',
              onPressed: () => _switchGreeting(-1),
            ),
            IconButton(
              icon: const Icon(Icons.casino),
              tooltip: '随机开场白',
              onPressed: _randomGreeting,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: '下一条开场白',
              onPressed: () => _switchGreeting(1),
            ),
          ],
          if (showToken && tokenUsage != null)
            _tokenChip(context, tokenUsage, userInputTokens),
          PopupMenuButton<String>(
            tooltip: '更多',
            onSelected: (value) {
              if (value == 'detail') {
                if (characterId != null) {
                  context.push('/contacts/$characterId');
                }
              } else if (value == 'edit') {
                if (characterId != null) {
                  context.push('/contacts/$characterId/edit');
                }
              } else if (value == 'settings') {
                _sessionSettings();
              } else if (value == 'export') {
                _exportSession();
              } else if (value == 'delete') {
                _deleteSession();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'detail', child: Text('查看角色详情')),
              PopupMenuItem(value: 'edit', child: Text('编辑人设')),
              PopupMenuItem(value: 'settings', child: Text('会话设置')),
              PopupMenuItem(value: 'export', child: Text('导出会话')),
              PopupMenuItem(value: 'delete', child: Text('删除会话')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('加载失败：$e')),
              data: (_) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: reversed.length + (showStreaming ? 1 : 0),
                itemBuilder: (context, index) {
                  if (showStreaming && index == 0) {
                    return _StreamingBubble(
                      sessionId: widget.sessionId,
                      avatarName: character?.name,
                      avatarPath: character?.avatarPath,
                      onAvatarTap: characterId == null
                          ? null
                          : () => context.push('/contacts/$characterId'),
                    );
                  }
                  final msg = reversed[showStreaming ? index - 1 : index];
                  return MessageBubble(
                    role: msg.role,
                    content: msg.content,
                    type: msg.type,
                    avatarName: character?.name,
                    avatarPath: character?.avatarPath,
                    onAvatarTap: characterId == null
                        ? null
                        : () => context.push('/contacts/$characterId'),
                    onRecall: () => _recall(msg),
                  );
                },
              ),
            ),
          ),
          _inputBar(context),
        ],
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    final isStreaming = ref.watch(chatControllerProvider).isGenerating;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_slashOpen) _slashPopup(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    focusNode: _inputFocus,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onChanged: _onInputChanged,
                    onSubmitted: _onSubmit,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: const InputDecoration(
                      hintText: '发消息…',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: isStreaming ? _cancel : _send,
                  icon: Icon(isStreaming ? Icons.stop : Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slashPopup(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: _slashMatches.length,
            itemBuilder: (context, i) {
              final c = _slashMatches[i];
              final selected = i == _slashIndex;
              return ListTile(
                dense: true,
                selected: selected,
                leading: Text(
                  c.usage,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                title: Text(c.description),
                subtitle: c.params.isEmpty
                    ? null
                    : Text('参数：${c.params.join('、')}'),
                onTap: () => _chooseSlash(i),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _tokenChip(
    BuildContext context,
    TokenUsage usage,
    int userInputTokens,
  ) {
    final total = usage.totalWith(userInputTokens);
    final available = usage.available;
    final ratio = available <= 0 ? 2.0 : total / available;
    final Color color;
    if (ratio < 0.6) {
      color = Colors.green;
    } else if (ratio < 0.85) {
      color = Colors.amber.shade700;
    } else if (ratio < 1.0) {
      color = Colors.orange.shade800;
    } else {
      color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: InkWell(
          onTap: () => _showTokenDetail(context, usage, userInputTokens),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_formatK(total)}/${_formatK(available)}',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTokenDetail(
    BuildContext context,
    TokenUsage usage,
    int userInputTokens,
  ) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      builder: (_) =>
          _TokenDetailSheet(usage: usage, userInputTokens: userInputTokens),
    );
  }
}

String _formatK(int tokens) {
  if (tokens >= 1000) return '${(tokens / 1000).toStringAsFixed(1)}K';
  return '$tokens';
}

class _TokenDetailSheet extends StatelessWidget {
  const _TokenDetailSheet({required this.usage, required this.userInputTokens});

  final TokenUsage usage;
  final int userInputTokens;

  @override
  Widget build(BuildContext context) {
    final total = usage.totalWith(userInputTokens);
    final available = usage.available;
    final remaining = (available - total).clamp(0, 1 << 40);
    final scheme = Theme.of(context).colorScheme;

    Widget row(String label, int tokens) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(
                _formatK(tokens),
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        );

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Token 占用（估算）',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              for (final s in usage.sections) row(s.label, s.tokens),
              row('最近对话', usage.historyTokens),
              row('用户输入', userInputTokens),
              const Divider(height: 20),
              row('输入总计', total),
              row('输出预留', usage.outputReserve),
              row('模型上限', usage.contextLimit),
              row('剩余', remaining),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionSettingsResult {
  const _SessionSettingsResult({
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
  });

  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;
}

class _SessionSettingsDialog extends StatefulWidget {
  const _SessionSettingsDialog({
    required this.session,
    required this.configs,
    required this.presets,
  });

  final Session session;
  final List<ProviderConfig> configs;
  final List<Preset> presets;

  @override
  State<_SessionSettingsDialog> createState() => _SessionSettingsDialogState();
}

class _SessionSettingsDialogState extends State<_SessionSettingsDialog> {
  String? _providerId;
  late final TextEditingController _temperature = TextEditingController(
      text: widget.session.temperature?.toString() ?? '');
  late final TextEditingController _topP =
      TextEditingController(text: widget.session.topP?.toString() ?? '');
  late final TextEditingController _maxTokens = TextEditingController(
      text: widget.session.maxTokens?.toString() ?? '');
  late final TextEditingController _presence = TextEditingController(
      text: widget.session.presencePenalty?.toString() ?? '');
  late final TextEditingController _frequency = TextEditingController(
      text: widget.session.frequencyPenalty?.toString() ?? '');

  @override
  void initState() {
    super.initState();
    _providerId = widget.session.providerId;
  }

  @override
  void dispose() {
    _temperature.dispose();
    _topP.dispose();
    _maxTokens.dispose();
    _presence.dispose();
    _frequency.dispose();
    super.dispose();
  }

  void _applyPreset(Preset p) {
    setState(() {
      _providerId = p.providerId;
      _temperature.text = p.temperature?.toString() ?? '';
      _topP.text = p.topP?.toString() ?? '';
      _maxTokens.text = p.maxTokens?.toString() ?? '';
      _presence.text = p.presencePenalty?.toString() ?? '';
      _frequency.text = p.frequencyPenalty?.toString() ?? '';
    });
  }

  static double? _d(String s) =>
      s.trim().isEmpty ? null : double.tryParse(s.trim());
  static int? _i(String s) => s.trim().isEmpty ? null : int.tryParse(s.trim());

  void _submit() {
    Navigator.of(context).pop(_SessionSettingsResult(
      providerId: _providerId,
      temperature: _d(_temperature.text),
      topP: _d(_topP.text),
      maxTokens: _i(_maxTokens.text),
      presencePenalty: _d(_presence.text),
      frequencyPenalty: _d(_frequency.text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('会话设置'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.presets.isNotEmpty) ...[
              Text('套用预设', style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: [
                  for (final p in widget.presets)
                    ActionChip(
                      label: Text(p.name),
                      onPressed: () => _applyPreset(p),
                    ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            DropdownButtonFormField<String?>(
              initialValue: _providerId,
              decoration: const InputDecoration(labelText: 'API Provider'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('默认')),
                for (final c in widget.configs)
                  DropdownMenuItem<String?>(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => setState(() => _providerId = v),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _temperature,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'temperature',
                helperText: '越高越发散、随机，越低越确定、保守（常用 0.6–1.2）',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _topP,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'top_p',
                helperText: '核采样，只从累积概率前 top_p 的候选里抽样（0–1）',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _maxTokens,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'maxTokens',
                helperText: '单次回复最多生成的 token 数',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _presence,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Presence Penalty',
                helperText: '惩罚已出现过的词，鼓励聊新话题（-2–2）',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _frequency,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Frequency Penalty',
                helperText: '惩罚高频重复词，降低啰嗦/重复（-2–2）',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
        FilledButton(onPressed: _submit, child: const Text('保存')),
      ],
    );
  }
}

/// The in-progress assistant bubble. Watches `streamingText` itself so each
/// delta only rebuilds this small widget, not the whole chat screen.
class _StreamingBubble extends ConsumerWidget {
  const _StreamingBubble({
    required this.sessionId,
    this.avatarName,
    this.avatarPath,
    this.onAvatarTap,
  });

  final String sessionId;
  final String? avatarName;
  final String? avatarPath;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamingText =
        ref.watch(chatControllerProvider.select((s) => s.streamingText)) ?? '';
    // Hide once the reply has been persisted (streamingText equals the last
    // message), so it doesn't double up on the persisted message for a frame.
    final messages =
        ref.watch(messagesProvider(sessionId)).value ?? const <Message>[];
    final lastContent = messages.isEmpty ? null : messages.last.content;
    if (streamingText.isNotEmpty && streamingText == lastContent) {
      return const SizedBox.shrink();
    }
    return MessageBubble(
      role: 'assistant',
      content: streamingText,
      isStreaming: true,
      avatarName: avatarName,
      avatarPath: avatarPath,
      onAvatarTap: onAvatarTap,
    );
  }
}
