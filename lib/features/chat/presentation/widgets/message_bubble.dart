import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:path/path.dart' as p;

import '../../../contacts/presentation/widgets/character_avatar.dart';
import '../../../../core/utils/html_sanitize.dart';
import '../../../../core/utils/regex_scripts.dart';
import '../../../../core/widgets/markdown_text.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.role,
    required this.content,
    this.type,
    this.metadata,
    this.isStreaming = false,
    this.avatarName,
    this.avatarPath,
    this.onAvatarTap,
    this.onRecall,
    this.imagePaths = const {},
    this.regexScripts = const [],
    this.depth,
    this.bubbleColor,
    this.textColor,
  });

  final String role;
  final String content;
  final String? type;

  /// Message metadata JSON (e.g. `{filename}` for file attachments).
  final String? metadata;
  final bool isStreaming;
  final String? avatarName;
  final String? avatarPath;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onRecall;

  /// Gallery name → file path, used to render `<img="name">` markers.
  final Map<String, String> imagePaths;

  /// SillyTavern regex scripts applied to the displayed content.
  final List<Map<String, dynamic>> regexScripts;

  /// Distance from the newest message (0 = newest), gating scripts that carry
  /// `minDepth`/`maxDepth` (e.g. a display-side deletion that only clears old
  /// messages). Null disables gating (e.g. in previews / static contexts).
  final int? depth;

  /// Bubble background color override; null falls back to the theme's
  /// user/assistant container color.
  final Color? bubbleColor;

  /// Message text color override; null falls back to the inherited text style.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    // Command replies (and any system message) render as a centered, muted
    // bubble — no avatar, distinct from assistant bubbles.
    if (type == 'command_reply' || role == 'system') {
      return _buildSystem(context);
    }

    // Image messages render the referenced file as an illustration.
    if (type == 'image') {
      return _buildImage(context);
    }

    // File attachments render a filename card (no image preview).
    if (type == 'file') {
      return _buildFile(context);
    }

    final isUser = role == 'user';
    final scheme = Theme.of(context).colorScheme;

    Widget body = (isStreaming && content.isEmpty)
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : _buildBody(context);
    if (textColor != null) {
      body = DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: textColor),
        child: body,
      );
    }

    final bubble = Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      constraints: const BoxConstraints(maxWidth: 320),
      decoration: BoxDecoration(
        color: bubbleColor ??
            (isUser ? scheme.primaryContainer : scheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(16),
      ),
      child: body,
    );

    if (isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: GestureDetector(
              onTap: onAvatarTap,
              child: CharacterAvatar(
                name: avatarName ?? '',
                avatarPath: avatarPath,
                radius: 16,
              ),
            ),
          ),
          Flexible(child: bubble),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final processed =
        applyRegexScripts(regexScripts, content, role: role, depth: depth);
    if (_hasHtml(processed)) {
      return _buildHtml(context, processed);
    }
    if (!processed.contains('<img')) {
      return MarkdownSelectableText(
        _stripHtmlKeepColor(processed),
        contextMenuBuilder: _recallMenu(),
      );
    }
    final segments = _splitContent(processed);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in segments)
          if (s.embedded != null)
            _galleryImage(imagePaths[s.embedded])
          else if (s.remote != null)
            _remoteImage(s.remote!)
          else if (s.text.trim().isNotEmpty)
            MarkdownSelectableText(
              _stripHtmlKeepColor(s.text).trim(),
              contextMenuBuilder: _recallMenu(),
            ),
      ],
    );
  }

  EditableTextContextMenuBuilder? _recallMenu() {
    if (onRecall == null) return null;
    return (context, editableTextState) {
      final items = editableTextState.contextMenuButtonItems;
      items.add(ContextMenuButtonItem(
        label: '撤回',
        onPressed: () {
          ContextMenuController.removeAny();
          onRecall!();
        },
      ));
      return AdaptiveTextSelectionToolbar.buttonItems(
        anchors: editableTextState.contextMenuAnchors,
        buttonItems: items,
      );
    };
  }

  List<({String text, String? embedded, String? remote})> _splitContent(
      String input) {
    final out = <({String text, String? embedded, String? remote})>[];
    // Matches <img="name"> (embedded) and <img ... src="url"> (remote).
    final regex = RegExp(r'<img(?:="([^"]*)"|[^>]*?src="([^"]*)")[^>]*>');
    var last = 0;
    for (final m in regex.allMatches(input)) {
      if (m.start > last) {
        out.add(
            (text: input.substring(last, m.start), embedded: null, remote: null));
      }
      out.add((text: '', embedded: m.group(1), remote: m.group(2)));
      last = m.end;
    }
    if (last < input.length) {
      out.add((text: input.substring(last), embedded: null, remote: null));
    }
    return out;
  }

  /// Strips HTML tags but keeps `<font>`/`<span>` color tags so inline text
  /// colors (from the card/model) reach the markdown renderer.
  String _stripHtmlKeepColor(String s) =>
      s.replaceAll(RegExp(r'<(?!\/?(font|span)\b)[^>]+>'), '');

  bool _hasHtml(String s) =>
      RegExp(r'<(div|style|details|summary|p|body|span|section)[\s>]')
          .hasMatch(s) ||
      RegExp(r'<img\s').hasMatch(s);

  Widget _buildHtml(BuildContext context, String html) {
    return SelectionArea(
      contextMenuBuilder: onRecall == null ? null : _htmlSelectionMenu,
      child: _HtmlView(
        html: sanitizeHtml(html),
        textStyle: DefaultTextStyle.of(context).style,
      ),
    );
  }

  /// Appends 撤回 to the built-in selection toolbar, so HTML panels (rendered
  /// via HtmlWidget, which honors SelectionArea) can be recalled like normal
  /// text messages.
  Widget _htmlSelectionMenu(
      BuildContext context, SelectableRegionState state) {
    final items = state.contextMenuButtonItems;
    items.add(ContextMenuButtonItem(
      label: '撤回',
      onPressed: () {
        ContextMenuController.removeAny();
        onRecall!();
      },
    ));
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: state.contextMenuAnchors,
      buttonItems: items,
    );
  }

  Widget _galleryImage(String? path) {
    if (path == null || path.isEmpty) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240, maxHeight: 320),
        child: Image.file(
          File(path),
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _remoteImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240, maxHeight: 320),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
        ),
      ),
    );
  }

  Widget _buildSystem(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SelectableText(
          content,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Align(
      alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240, maxHeight: 320),
            child: Image.file(
              File(content),
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFile(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: role == 'user' ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_drive_file, color: scheme.primary),
            const SizedBox(width: 8),
            Flexible(child: Text(_filename(), overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  String _filename() {
    try {
      final decoded = metadata == null ? null : jsonDecode(metadata!);
      final name = decoded is Map ? decoded['filename']?.toString() : null;
      if (name != null && name.isNotEmpty) return name;
    } catch (_) {}
    return p.basename(content);
  }
}

/// Renders a regex-script HTML message with HtmlWidget. Forced to synchronous
/// build — the default async build (auto-on when HTML exceeds 10k chars) uses
/// a FutureBuilder whose `future.then(...)` is recreated on every rebuild, so
/// the content keeps resetting to its loading state and the bubble renders
/// blank (the "content disappears" bug).
class _HtmlView extends StatelessWidget {
  const _HtmlView({required this.html, required this.textStyle});

  final String html;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) =>
      HtmlWidget(html, textStyle: textStyle, buildAsync: false);
}
