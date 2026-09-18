import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/database.dart';
import '../utils/app_exception.dart';

/// Exports/imports all user data as a single JSON document, for backup and
/// restore. API keys live in secure storage and are intentionally excluded.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  Future<String> exportAll() async {
    final characters = await _db.select(_db.characters).get();
    final adaptations = await _db.select(_db.characterAdaptations).get();
    final worlds = await _db.select(_db.worlds).get();
    final sessions = await _db.select(_db.sessions).get();
    final messages = await _db.select(_db.messages).get();
    final stories = await _db.select(_db.stories).get();
    final storyNodes = await _db.select(_db.storyNodes).get();
    final storySaves = await _db.select(_db.storySaves).get();
    final groups = await _db.select(_db.groups).get();
    final groupMembers = await _db.select(_db.groupMembers).get();
    final groupMessages = await _db.select(_db.groupMessages).get();
    final pairRelations = await _db.select(_db.pairRelations).get();
    final sessionStates = await _db.select(_db.sessionStates).get();
    final characterRelations = await _db.select(_db.characterRelations).get();
    final characterAffinities = await _db.select(_db.characterAffinities).get();
    final characterMemories = await _db.select(_db.characterMemories).get();
    final providerConfigs = await _db.select(_db.providerConfigs).get();
    final worldbooks = await _db.select(_db.worldbooks).get();
    final characterWorldbooks = await _db.select(_db.characterWorldbooks).get();
    final worldWorldbooks = await _db.select(_db.worldWorldbooks).get();
    final groupWorldbooks = await _db.select(_db.groupWorldbooks).get();
    final storyWorldbooks = await _db.select(_db.storyWorldbooks).get();
    final groupWorlds = await _db.select(_db.groupWorlds).get();
    final storyWorlds = await _db.select(_db.storyWorlds).get();
    final presets = await _db.select(_db.presets).get();
    final settings = await _db.select(_db.settings).get();
    final groupMemories = await _db.select(_db.groupMemories).get();

    return jsonEncode({
      'version': 1,
      'characters': characters.map(_c).toList(),
      'adaptations': adaptations.map(_a).toList(),
      'worlds': worlds.map(_w).toList(),
      'sessions': sessions.map(_s).toList(),
      'messages': messages.map(_m).toList(),
      'stories': stories.map(_st).toList(),
      'storyNodes': storyNodes.map(_sn).toList(),
      'storySaves': storySaves.map(_ss).toList(),
      'groups': groups.map(_g).toList(),
      'groupMembers': groupMembers.map(_gm).toList(),
      'groupMessages': groupMessages.map(_gms).toList(),
      'pairRelations': pairRelations.map(_pr).toList(),
      'sessionStates': sessionStates.map(_sst).toList(),
      'characterRelations': characterRelations.map(_cr).toList(),
      'characterAffinities': characterAffinities.map(_ca).toList(),
      'characterMemories': characterMemories.map(_cm).toList(),
      'providerConfigs': providerConfigs.map(_pc).toList(),
      'worldbooks': worldbooks.map(_wb).toList(),
      'characterWorldbooks': characterWorldbooks.map(_cwb).toList(),
      'worldWorldbooks': worldWorldbooks.map(_wwb).toList(),
      'groupWorldbooks': groupWorldbooks.map(_gwb).toList(),
      'storyWorldbooks': storyWorldbooks.map(_swb).toList(),
      'groupWorlds': groupWorlds.map(_gw).toList(),
      'storyWorlds': storyWorlds.map(_sw).toList(),
      'presets': presets.map(_preset).toList(),
      'settings': settings.map(_setting).toList(),
      'groupMemories': groupMemories.map(_gmem).toList(),
    });
  }

  Future<void> importAll(String json) async {
    final data = jsonDecode(json);
    if (data is! Map<String, dynamic>) throw AppException('备份文件格式无效');

    await _db.transaction(() async {
      // Delete children first (FK cascade would also work, but be explicit).
      await _db.delete(_db.groupWorlds).go();
      await _db.delete(_db.storyWorlds).go();
      await _db.delete(_db.groupWorldbooks).go();
      await _db.delete(_db.storyWorldbooks).go();
      await _db.delete(_db.worldWorldbooks).go();
      await _db.delete(_db.characterWorldbooks).go();
      await _db.delete(_db.worldbooks).go();
      await _db.delete(_db.pairRelations).go();
      await _db.delete(_db.groupMessages).go();
      await _db.delete(_db.groupMembers).go();
      await _db.delete(_db.groupMemories).go();
      await _db.delete(_db.groups).go();
      await _db.delete(_db.storySaves).go();
      await _db.delete(_db.storyNodes).go();
      await _db.delete(_db.stories).go();
      await _db.delete(_db.messages).go();
      await _db.delete(_db.sessionStates).go();
      await _db.delete(_db.sessions).go();
      await _db.delete(_db.characterRelations).go();
      await _db.delete(_db.characterAffinities).go();
      await _db.delete(_db.characterMemories).go();
      await _db.delete(_db.characterAdaptations).go();
      await _db.delete(_db.characters).go();
      await _db.delete(_db.worlds).go();
      await _db.delete(_db.presets).go();
      await _db.delete(_db.settings).go();
      await _db.delete(_db.providerConfigs).go();

      await _insertAll(data);
    });
  }

  Future<void> _insertAll(Map<String, dynamic> data) async {
    for (final e in _list(data, 'characters')) {
      await _db.into(_db.characters).insert(CharactersCompanion.insert(
        id: e['id'], name: e['name'], corePersonaJson: e['corePersonaJson'],
        worldbookJson: Value(e['worldbookJson'] as String?),
        avatarPath: Value(e['avatarPath'] as String?), tags: Value(e['tags']),
        sourceType: e['sourceType'], sourcePath: Value(e['sourcePath'] as String?),
        pinnedAt: Value(e['pinnedAt'] as int?), createdAt: e['createdAt'],
        updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'adaptations')) {
      await _db.into(_db.characterAdaptations).insert(CharacterAdaptationsCompanion.insert(
        id: e['id'], characterId: e['characterId'], worldId: Value(e['worldId']),
        adaptationJson: e['adaptationJson'], createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'worlds')) {
      await _db.into(_db.worlds).insert(WorldsCompanion.insert(
        id: e['id'], name: e['name'], description: Value(e['description'] as String?),
        rulesJson: Value(e['rulesJson']), worldbookJson: Value(e['worldbookJson']),
        initialStateJson: Value(e['initialStateJson']), npcPoolJson: Value(e['npcPoolJson']),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'worldbooks')) {
      await _db.into(_db.worldbooks).insert(WorldbooksCompanion.insert(
        id: e['id'], name: e['name'], description: Value(e['description']),
        bookJson: Value(e['bookJson']), sourceType: Value(e['sourceType']),
        sourcePath: Value(e['sourcePath'] as String?),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'sessions')) {
      await _db.into(_db.sessions).insert(SessionsCompanion.insert(
        id: e['id'], characterId: e['characterId'], worldId: Value(e['worldId'] as String?),
        adaptationId: Value(e['adaptationId'] as String?), title: Value(e['title'] as String?),
        persona: Value(e['persona'] as String?), memoryEnabled: Value(e['memoryEnabled']),
        contextWindowLimit: Value(e['contextWindowLimit'] as String?),
        providerId: Value(e['providerId'] as String?),
        temperature: Value((e['temperature'] as num?)?.toDouble()),
        topP: Value((e['topP'] as num?)?.toDouble()),
        maxTokens: Value(e['maxTokens'] as int?),
        presencePenalty: Value((e['presencePenalty'] as num?)?.toDouble()),
        frequencyPenalty: Value((e['frequencyPenalty'] as num?)?.toDouble()),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'], lastMessageAt: e['lastMessageAt'],
      ));
    }
    for (final e in _list(data, 'messages')) {
      await _db.into(_db.messages).insert(MessagesCompanion.insert(
        id: e['id'], sessionId: e['sessionId'], role: e['role'], content: e['content'],
        orderIndex: e['orderIndex'], timestamp: e['timestamp'], metadata: Value(e['metadata']),
      ));
    }
    for (final e in _list(data, 'sessionStates')) {
      await _db.into(_db.sessionStates).insert(SessionStatesCompanion.insert(
        sessionId: e['sessionId'], stateJson: Value(e['stateJson']), summaryText: Value(e['summaryText']),
        summaryIndex: Value(e['summaryIndex']), updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'characterRelations')) {
      await _db.into(_db.characterRelations).insert(CharacterRelationsCompanion.insert(
        characterId: e['characterId'], worldId: Value(e['worldId'] as String? ?? ''),
        relationJson: Value(e['relationJson']), updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'characterAffinities')) {
      await _db.into(_db.characterAffinities).insert(CharacterAffinitiesCompanion.insert(
        characterId: e['characterId'], worldId: Value(e['worldId'] as String? ?? ''),
        affinityJson: Value(e['affinityJson']), updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'characterMemories')) {
      await _db.into(_db.characterMemories).insert(CharacterMemoriesCompanion.insert(
        characterId: e['characterId'], worldId: Value(e['worldId'] as String? ?? ''),
        stateJson: Value(e['stateJson']), summaryText: Value(e['summaryText']),
        updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'stories')) {
      await _db.into(_db.stories).insert(StoriesCompanion.insert(
        id: e['id'], name: e['name'], description: Value(e['description']),
        characterId: Value(e['characterId'] as String?), worldId: Value(e['worldId'] as String?),
        coverPath: Value(e['coverPath'] as String?),
        currentNodeId: Value(e['currentNodeId'] as String?),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'storyNodes')) {
      await _db.into(_db.storyNodes).insert(StoryNodesCompanion.insert(
        id: e['id'], storyId: e['storyId'], parentId: Value(e['parentId'] as String?),
        narrative: e['narrative'], choicesJson: Value(e['choicesJson']),
        chosenIndex: Value(e['chosenIndex'] as int?), depth: Value(e['depth']), createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'storySaves')) {
      await _db.into(_db.storySaves).insert(StorySavesCompanion.insert(
        id: e['id'], storyId: e['storyId'], label: e['label'],
        currentNodeId: Value(e['currentNodeId'] as String?),
        isQuick: Value(e['isQuick']), savedAt: e['savedAt'],
      ));
    }
    for (final e in _list(data, 'groups')) {
      await _db.into(_db.groups).insert(GroupsCompanion.insert(
        id: e['id'], name: e['name'], worldId: Value(e['worldId'] as String?),
        avatarPath: Value(e['avatarPath'] as String?),
        speakMode: Value(e['speakMode']), memoryEnabled: Value(e['memoryEnabled'] as bool? ?? true),
        providerId: Value(e['providerId'] as String?),
        temperature: Value((e['temperature'] as num?)?.toDouble()),
        topP: Value((e['topP'] as num?)?.toDouble()),
        maxTokens: Value(e['maxTokens'] as int?),
        presencePenalty: Value((e['presencePenalty'] as num?)?.toDouble()),
        frequencyPenalty: Value((e['frequencyPenalty'] as num?)?.toDouble()),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'], lastMessageAt: e['lastMessageAt'],
      ));
    }
    for (final e in _list(data, 'groupMemories')) {
      await _db.into(_db.groupMemories).insert(GroupMemoriesCompanion.insert(
        groupId: e['groupId'], stateJson: Value(e['stateJson']),
        summaryText: Value(e['summaryText']), summaryIndex: Value(e['summaryIndex']),
        updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'groupMembers')) {
      await _db.into(_db.groupMembers).insert(GroupMembersCompanion.insert(
        id: e['id'], groupId: e['groupId'], characterId: e['characterId'], joinOrder: e['joinOrder'],
      ));
    }
    for (final e in _list(data, 'groupMessages')) {
      await _db.into(_db.groupMessages).insert(GroupMessagesCompanion.insert(
        id: e['id'], groupId: e['groupId'],
        speakerCharacterId: Value(e['speakerCharacterId'] as String?),
        role: e['role'], content: e['content'], orderIndex: e['orderIndex'], timestamp: e['timestamp'],
      ));
    }
    for (final e in _list(data, 'pairRelations')) {
      await _db.into(_db.pairRelations).insert(PairRelationsCompanion.insert(
        id: e['id'], groupId: e['groupId'], charA: e['charA'], charB: e['charB'],
        relationJson: Value(e['relationJson']), updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'providerConfigs')) {
      await _db.into(_db.providerConfigs).insert(ProviderConfigsCompanion.insert(
        id: e['id'], name: e['name'], type: e['type'], baseUrl: e['baseUrl'],
        model: e['model'], apiKeyRef: Value(e['apiKeyRef']),
        extraParamsJson: Value(e['extraParamsJson']),
        memoryModel: Value(e['memoryModel'] as String?),
        isDefault: Value(e['isDefault']),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'presets')) {
      await _db.into(_db.presets).insert(PresetsCompanion.insert(
        id: e['id'], name: e['name'], providerId: Value(e['providerId'] as String?),
        temperature: Value((e['temperature'] as num?)?.toDouble()),
        topP: Value((e['topP'] as num?)?.toDouble()),
        maxTokens: Value(e['maxTokens'] as int?),
        presencePenalty: Value((e['presencePenalty'] as num?)?.toDouble()),
        frequencyPenalty: Value((e['frequencyPenalty'] as num?)?.toDouble()),
        createdAt: e['createdAt'], updatedAt: e['updatedAt'],
      ));
    }
    for (final e in _list(data, 'settings')) {
      await _db.into(_db.settings).insert(SettingsCompanion.insert(
        key: e['key'], value: e['value'],
      ));
    }
    for (final e in _list(data, 'characterWorldbooks')) {
      await _db.into(_db.characterWorldbooks).insert(CharacterWorldbooksCompanion.insert(
        characterId: e['characterId'], worldbookId: e['worldbookId'], createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'worldWorldbooks')) {
      await _db.into(_db.worldWorldbooks).insert(WorldWorldbooksCompanion.insert(
        worldId: e['worldId'], worldbookId: e['worldbookId'], createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'groupWorldbooks')) {
      await _db.into(_db.groupWorldbooks).insert(GroupWorldbooksCompanion.insert(
        groupId: e['groupId'], worldbookId: e['worldbookId'], createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'storyWorldbooks')) {
      await _db.into(_db.storyWorldbooks).insert(StoryWorldbooksCompanion.insert(
        storyId: e['storyId'], worldbookId: e['worldbookId'], createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'groupWorlds')) {
      await _db.into(_db.groupWorlds).insert(GroupWorldsCompanion.insert(
        groupId: e['groupId'], worldId: e['worldId'], createdAt: e['createdAt'],
      ));
    }
    for (final e in _list(data, 'storyWorlds')) {
      await _db.into(_db.storyWorlds).insert(StoryWorldsCompanion.insert(
        storyId: e['storyId'], worldId: e['worldId'], createdAt: e['createdAt'],
      ));
    }
  }

  List<Map<String, dynamic>> _list(Map<String, dynamic> data, String key) {
    final v = data[key];
    if (v is! List) return const [];
    return v.whereType<Map<String, dynamic>>().toList();
  }

  // --- serializers ---
  Map<String, dynamic> _c(Character c) => {
        'id': c.id, 'name': c.name, 'corePersonaJson': c.corePersonaJson,
        'worldbookJson': c.worldbookJson, 'avatarPath': c.avatarPath,
        'tags': c.tags, 'sourceType': c.sourceType, 'sourcePath': c.sourcePath,
        'createdAt': c.createdAt, 'updatedAt': c.updatedAt, 'pinnedAt': c.pinnedAt,
      };
  Map<String, dynamic> _a(CharacterAdaptation a) => {
        'id': a.id, 'characterId': a.characterId, 'worldId': a.worldId,
        'adaptationJson': a.adaptationJson, 'createdAt': a.createdAt, 'updatedAt': a.updatedAt,
      };
  Map<String, dynamic> _w(World w) => {
        'id': w.id, 'name': w.name, 'description': w.description,
        'rulesJson': w.rulesJson, 'worldbookJson': w.worldbookJson,
        'initialStateJson': w.initialStateJson, 'npcPoolJson': w.npcPoolJson,
        'createdAt': w.createdAt, 'updatedAt': w.updatedAt,
      };
  Map<String, dynamic> _s(Session s) => {
        'id': s.id, 'characterId': s.characterId, 'worldId': s.worldId,
        'adaptationId': s.adaptationId, 'title': s.title, 'persona': s.persona,
        'memoryEnabled': s.memoryEnabled, 'contextWindowLimit': s.contextWindowLimit,
        'providerId': s.providerId, 'temperature': s.temperature, 'topP': s.topP,
        'maxTokens': s.maxTokens, 'presencePenalty': s.presencePenalty,
        'frequencyPenalty': s.frequencyPenalty,
        'createdAt': s.createdAt, 'updatedAt': s.updatedAt, 'lastMessageAt': s.lastMessageAt,
      };
  Map<String, dynamic> _m(Message m) => {
        'id': m.id, 'sessionId': m.sessionId, 'role': m.role, 'content': m.content,
        'orderIndex': m.orderIndex, 'timestamp': m.timestamp, 'metadata': m.metadata,
      };
  Map<String, dynamic> _st(Story s) => {
        'id': s.id, 'name': s.name, 'description': s.description,
        'characterId': s.characterId, 'worldId': s.worldId, 'coverPath': s.coverPath,
        'currentNodeId': s.currentNodeId, 'createdAt': s.createdAt, 'updatedAt': s.updatedAt,
      };
  Map<String, dynamic> _sn(StoryNode n) => {
        'id': n.id, 'storyId': n.storyId, 'parentId': n.parentId, 'narrative': n.narrative,
        'choicesJson': n.choicesJson, 'chosenIndex': n.chosenIndex,
        'depth': n.depth, 'createdAt': n.createdAt,
      };
  Map<String, dynamic> _ss(StorySave s) => {
        'id': s.id, 'storyId': s.storyId, 'label': s.label,
        'currentNodeId': s.currentNodeId, 'isQuick': s.isQuick, 'savedAt': s.savedAt,
      };
  Map<String, dynamic> _g(Group g) => {
        'id': g.id, 'name': g.name, 'worldId': g.worldId, 'avatarPath': g.avatarPath,
        'speakMode': g.speakMode, 'memoryEnabled': g.memoryEnabled,
        'providerId': g.providerId, 'temperature': g.temperature, 'topP': g.topP,
        'maxTokens': g.maxTokens, 'presencePenalty': g.presencePenalty,
        'frequencyPenalty': g.frequencyPenalty,
        'createdAt': g.createdAt, 'updatedAt': g.updatedAt, 'lastMessageAt': g.lastMessageAt,
      };
  Map<String, dynamic> _gm(GroupMember m) => {
        'id': m.id, 'groupId': m.groupId, 'characterId': m.characterId, 'joinOrder': m.joinOrder,
      };
  Map<String, dynamic> _gms(GroupMessage m) => {
        'id': m.id, 'groupId': m.groupId, 'speakerCharacterId': m.speakerCharacterId,
        'role': m.role, 'content': m.content, 'orderIndex': m.orderIndex, 'timestamp': m.timestamp,
      };
  Map<String, dynamic> _pr(PairRelation p) => {
        'id': p.id, 'groupId': p.groupId, 'charA': p.charA, 'charB': p.charB,
        'relationJson': p.relationJson, 'updatedAt': p.updatedAt,
      };
  Map<String, dynamic> _sst(SessionState s) => {
        'sessionId': s.sessionId, 'stateJson': s.stateJson, 'summaryText': s.summaryText,
        'summaryIndex': s.summaryIndex, 'updatedAt': s.updatedAt,
      };
  Map<String, dynamic> _cr(CharacterRelation r) => {
        'characterId': r.characterId, 'worldId': r.worldId,
        'relationJson': r.relationJson, 'updatedAt': r.updatedAt,
      };
  Map<String, dynamic> _ca(CharacterAffinity a) => {
        'characterId': a.characterId, 'worldId': a.worldId,
        'affinityJson': a.affinityJson, 'updatedAt': a.updatedAt,
      };
  Map<String, dynamic> _cm(CharacterMemory m) => {
        'characterId': m.characterId, 'worldId': m.worldId,
        'stateJson': m.stateJson, 'summaryText': m.summaryText, 'updatedAt': m.updatedAt,
      };
  Map<String, dynamic> _pc(ProviderConfig p) => {
        'id': p.id, 'name': p.name, 'type': p.type, 'baseUrl': p.baseUrl,
        'model': p.model, 'apiKeyRef': p.apiKeyRef, 'extraParamsJson': p.extraParamsJson,
        'memoryModel': p.memoryModel, 'isDefault': p.isDefault,
        'createdAt': p.createdAt, 'updatedAt': p.updatedAt,
      };
  Map<String, dynamic> _wb(Worldbook b) => {
        'id': b.id, 'name': b.name, 'description': b.description,
        'bookJson': b.bookJson, 'sourceType': b.sourceType, 'sourcePath': b.sourcePath,
        'createdAt': b.createdAt, 'updatedAt': b.updatedAt,
      };
  Map<String, dynamic> _cwb(CharacterWorldbook r) => {
        'characterId': r.characterId, 'worldbookId': r.worldbookId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _wwb(WorldWorldbook r) => {
        'worldId': r.worldId, 'worldbookId': r.worldbookId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _gwb(GroupWorldbook r) => {
        'groupId': r.groupId, 'worldbookId': r.worldbookId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _swb(StoryWorldbook r) => {
        'storyId': r.storyId, 'worldbookId': r.worldbookId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _gw(GroupWorld r) => {
        'groupId': r.groupId, 'worldId': r.worldId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _sw(StoryWorld r) => {
        'storyId': r.storyId, 'worldId': r.worldId, 'createdAt': r.createdAt,
      };
  Map<String, dynamic> _preset(Preset p) => {
        'id': p.id, 'name': p.name, 'providerId': p.providerId,
        'temperature': p.temperature, 'topP': p.topP, 'maxTokens': p.maxTokens,
        'presencePenalty': p.presencePenalty, 'frequencyPenalty': p.frequencyPenalty,
        'createdAt': p.createdAt, 'updatedAt': p.updatedAt,
      };
  Map<String, dynamic> _setting(Setting s) => {
        'key': s.key, 'value': s.value,
      };
  Map<String, dynamic> _gmem(GroupMemory m) => {
        'groupId': m.groupId, 'stateJson': m.stateJson, 'summaryText': m.summaryText,
        'summaryIndex': m.summaryIndex, 'updatedAt': m.updatedAt,
      };
}
