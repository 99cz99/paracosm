import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';

void main() {
  test('insert and query character, adaptation, session, message', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: '测试角色',
      corePersonaJson: '{"personality":"温柔"}',
      sourceType: 'manual',
      createdAt: 1,
      updatedAt: 1,
    ));
    await db.insertAdaptation(CharacterAdaptationsCompanion.insert(
      id: 'a1',
      characterId: 'c1',
      adaptationJson: '{}',
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
    await db.insertMessage(MessagesCompanion.insert(
      id: 'm1',
      sessionId: 's1',
      role: 'user',
      content: '你好',
      orderIndex: 0,
      timestamp: 1,
    ));

    final character = await db.getCharacter('c1');
    expect(character?.name, '测试角色');

    final adaptation = await db.getAdaptation('c1', '');
    expect(adaptation, isNotNull);

    final messages = await db.getMessages('s1');
    expect(messages, hasLength(1));
    expect(messages.first.content, '你好');

    final next = await db.nextOrderIndex('s1');
    expect(next, 1);

    final sessions = await db.watchSessionsWithCharacter().first;
    expect(sessions, hasLength(1));
    expect(sessions.first.characterName, '测试角色');

    await db.close();
  });
}
