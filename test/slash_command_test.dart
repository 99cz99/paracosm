import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/commands/slash_commands.dart';
import 'package:paracosm/core/db/database.dart';

AppDatabase _db() => AppDatabase.forTesting(NativeDatabase.memory());

Future<Session> _insertSession(
  AppDatabase db, {
  String core = '{"personality":"温柔"}',
}) async {
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c1',
    name: '测试角色',
    corePersonaJson: core,
    sourceType: 'manual',
    createdAt: 1,
    updatedAt: 1,
  ));
  await db.insertSession(SessionsCompanion.insert(
    id: 's1',
    characterId: 'c1',
    createdAt: 1,
    updatedAt: 1,
    lastMessageAt: 1,
  ));
  return (await db.getSession('s1'))!;
}

void main() {
  test('/help lists commands by category', () {
    final text = helpText();
    expect(text, contains('可用指令'));
    expect(text, contains('【状态】'));
    expect(text, contains('/status'));
    expect(text, contains('/relation'));
    expect(text, contains('【记忆】'));
    expect(text, contains('/summary'));
    expect(text, contains('【世界书】'));
    expect(text, contains('/lore'));
    expect(text, contains('【群聊】'));
    expect(text, contains('/mode'));
    expect(text, contains('【系统】'));
    expect(text, contains('/help'));
  });

  test('/help <name> shows details; unknown name errors', () {
    expect(helpText('status'), contains('【/status】'));
    expect(helpText('status'), contains('用法：/status'));
    expect(helpText('nope'), contains('未知指令：/nope'));
  });

  test('/status shows structured state', () async {
    final db = _db();
    final session = await _insertSession(db);
    await db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      stateJson: const Value(
          '{"scene":"图书馆","facts":["在找书"],"items":["钥匙"],"npcs":{}}'),
      updatedAt: 1,
    ));

    final reply = await statusText(db, session);
    expect(reply, contains('场景：图书馆'));
    expect(reply, contains('已知事实：在找书'));
    expect(reply, contains('物品：钥匙'));
    expect(reply, isNot(contains('【关系】')));
    await db.close();
  });

  test('/status with no memory shows placeholders', () async {
    final db = _db();
    final session = await _insertSession(db);
    final reply = await statusText(db, session);
    expect(reply, contains('暂无状态信息'));
    await db.close();
  });

  test('/status uses the skill state_schema for field labels', () async {
    final db = _db();
    final session = await _insertSession(
      db,
      core: '{"state_schema":{"scene":"位置","mood":"心情"},"personality":"温柔"}',
    );
    await db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      stateJson: const Value('{"scene":"图书馆","mood":"开心"}'),
      updatedAt: 1,
    ));

    final reply = await statusText(db, session);
    expect(reply, contains('位置：图书馆'));
    expect(reply, contains('心情：开心'));
    await db.close();
  });

  test('executeCommand dispatches and reports unknown commands', () async {
    final db = _db();
    final session = await _insertSession(db);
    expect(await executeCommand(db, session, '/help'), contains('可用指令'));
    expect(await executeCommand(db, session, '/status'), contains('暂无状态信息'));
    expect(
        await executeCommand(db, session, '/unknown'), contains('未知指令：/unknown'));
    await db.close();
  });

  test('/relation shows the relation', () async {
    final db = _db();
    final session = await _insertSession(db);
    await db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      relationJson:
          const Value('{"affection":5,"trust":3,"intimacy":2,"notes":"同学"}'),
      updatedAt: 1,
    ));

    final reply = await executeCommand(db, session, '/relation');
    expect(reply, contains('好感：5'));
    expect(reply, contains('信任：3'));
    await db.close();
  });

  test('/relation with unknown name lists present characters', () async {
    final db = _db();
    final session = await _insertSession(db);
    final reply = await executeCommand(db, session, '/relation 小明');
    expect(reply, contains('角色「小明」不存在'));
    expect(reply, contains('测试角色'));
    await db.close();
  });

  test('/relation shows affinity for skill characters', () async {
    final db = _db();
    final session =
        await _insertSession(db, core: '{"affinity":{"trust_level":2}}');
    await db.upsertCharacterAffinity(CharacterAffinitiesCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      affinityJson: const Value('{"trust_level":2,"trust_value":40}'),
      updatedAt: 1,
    ));

    final reply = await executeCommand(db, session, '/relation');
    expect(reply, contains('信任：Lv2'));
    await db.close();
  });

  test('/summary shows the rolling summary', () async {
    final db = _db();
    final session = await _insertSession(db);
    await db.upsertCharacterMemory(CharacterMemoriesCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      summaryText: const Value('用户和角色在图书馆相遇，聊了关于书的话题。'),
      updatedAt: 1,
    ));

    final reply = await executeCommand(db, session, '/summary');
    expect(reply, contains('用户和角色在图书馆相遇'));
    await db.close();
  });

  test('/summary with no memory shows placeholder', () async {
    final db = _db();
    final session = await _insertSession(db);
    final reply = await executeCommand(db, session, '/summary');
    expect(reply, contains('暂无摘要'));
    await db.close();
  });

  test('/lore lists bound worldbook names', () async {
    final db = _db();
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '测试角色',
      corePersonaJson: '{"personality":"温柔"}',
      worldbookJson: const Value('{"name":"宁宁内置","entries":[]}'),
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertSession(SessionsCompanion.insert(
      id: 's1',
      characterId: 'c1',
      createdAt: 1,
      updatedAt: 1,
      lastMessageAt: 1,
    ));
    final session = (await db.getSession('s1'))!;

    final reply = await executeCommand(db, session, '/lore');
    expect(reply, contains('【角色世界书】'));
    expect(reply, contains('宁宁内置'));
    await db.close();
  });

  test('/lore with no worldbooks shows placeholder', () async {
    final db = _db();
    final session = await _insertSession(db);
    final reply = await executeCommand(db, session, '/lore');
    expect(reply, contains('暂无世界书'));
    await db.close();
  });

  test('/mode displays and switches the group speak mode', () async {
    final db = _db();
    await db.insertGroup(GroupsCompanion.insert(
      id: 'g1',
      name: '测试群',
      createdAt: 1,
      updatedAt: 1,
      lastMessageAt: 1,
    ));
    final group = (await db.getGroup('g1'))!;

    expect(await executeGroupCommand(db, group, '/mode'), contains('当前：自动'));
    expect(
        await executeGroupCommand(db, group, '/mode turn'), contains('已切换为：轮流'));
    expect((await db.getGroup('g1'))!.speakMode, 'turn');
    expect(await executeGroupCommand(db, group, '/mode mention'),
        contains('已切换为：点名@角色'));
    expect((await db.getGroup('g1'))!.speakMode, 'call');
    expect(await executeGroupCommand(db, group, '/mode bogus'), contains('未知模式'));
    await db.close();
  });

  test('/mode in single chat is group-only', () async {
    final db = _db();
    final session = await _insertSession(db);
    expect(await executeCommand(db, session, '/mode'), contains('此指令仅群聊可用'));
    await db.close();
  });

  test('/lore reads the session-level worldbook selection', () async {
    final db = _db();
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '测试角色',
      corePersonaJson: '{"personality":"温柔"}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: 'wb1',
      name: '共享世界书',
      bookJson: const Value(
          '{"entries":[{"comment":"图书馆","keys":["图书馆"],"content":"..."}]}'),
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertSession(SessionsCompanion.insert(
      id: 's1',
      characterId: 'c1',
      worldbookIdsJson: const Value('["wb1"]'),
      createdAt: 1,
      updatedAt: 1,
      lastMessageAt: 1,
    ));
    final session = (await db.getSession('s1'))!;

    final reply = await executeCommand(db, session, '/lore');
    expect(reply, contains('共享世界书'));
    await db.close();
  });

  test('/status in group chat shows group state', () async {
    final db = _db();
    final group = await _groupWithMembers(db);
    await db.upsertGroupMemory(GroupMemoriesCompanion.insert(
      groupId: 'g1',
      stateJson: const Value('{"scene":"森林","facts":["遇到狼"]}'),
      updatedAt: 1,
    ));

    final reply = await executeGroupCommand(db, group, '/status');
    expect(reply, contains('场景：森林'));
    await db.close();
  });

  test('/summary in group chat shows group summary', () async {
    final db = _db();
    final group = await _groupWithMembers(db);
    await db.upsertGroupMemory(GroupMemoriesCompanion.insert(
      groupId: 'g1',
      summaryText: const Value('大家去了森林。'),
      updatedAt: 1,
    ));

    final reply = await executeGroupCommand(db, group, '/summary');
    expect(reply, contains('大家去了森林'));
    await db.close();
  });

  test('/relation in group chat shows all members', () async {
    final db = _db();
    final group = await _groupWithMembers(db);
    await db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
      characterId: 'c1',
      worldId: const Value(''),
      relationJson: const Value('{"affection":5}'),
      updatedAt: 1,
    ));
    await db.upsertCharacterRelation(CharacterRelationsCompanion.insert(
      characterId: 'c2',
      worldId: const Value(''),
      relationJson: const Value('{"affection":3}'),
      updatedAt: 1,
    ));

    final reply = await executeGroupCommand(db, group, '/relation');
    expect(reply, contains('小明'));
    expect(reply, contains('小红'));
    await db.close();
  });

  test('/lore in group chat shows group-bound worldbook names', () async {
    final db = _db();
    final group = await _groupWithMembers(db);
    await db.insertWorldbook(WorldbooksCompanion.insert(
      id: 'wb1',
      name: '群聊世界书',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.bindGroupWorldbook('g1', 'wb1', 1);

    final reply = await executeGroupCommand(db, group, '/lore');
    expect(reply, contains('群聊世界书'));
    await db.close();
  });
}

Future<Group> _groupWithMembers(AppDatabase db) async {
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c1',
    name: '小明',
    corePersonaJson: '{}',
    sourceType: 'manual',
    createdAt: 1,
    updatedAt: 1,
  ));
  await db.insertCharacter(CharactersCompanion.insert(
    id: 'c2',
    name: '小红',
    corePersonaJson: '{}',
    sourceType: 'manual',
    createdAt: 1,
    updatedAt: 1,
  ));
  await db.insertGroup(GroupsCompanion.insert(
    id: 'g1',
    name: '测试群',
    createdAt: 1,
    updatedAt: 1,
    lastMessageAt: 1,
  ));
  await db.insertMember(GroupMembersCompanion.insert(
    id: 'm1',
    groupId: 'g1',
    characterId: 'c1',
    joinOrder: 0,
  ));
  await db.insertMember(GroupMembersCompanion.insert(
    id: 'm2',
    groupId: 'g1',
    characterId: 'c2',
    joinOrder: 1,
  ));
  return (await db.getGroup('g1'))!;
}
