import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paracosm/core/db/database.dart';
import 'package:paracosm/features/chat/data/session_repository.dart';

void main() {
  test('getGreetings returns first_mes + unique alternates', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: 'nene',
      corePersonaJson: jsonEncode({
        'first_mes': '默认开场',
        'alternate_greetings': ['默认开场', '备选1', '备选2', '备选1'],
      }),
      sourceType: 'sillytavern',
      createdAt: 1,
      updatedAt: 1,
    ));
    final greetings = await SessionRepository(db).getGreetings('c1');
    expect(greetings, ['默认开场', '备选1', '备选2']); // 去重
    await db.close();
  });

  test('createSession uses openingMessage override as the first message',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.insertCharacter(CharactersCompanion.insert(
      id: 'c1',
      name: 'nene',
      corePersonaJson: jsonEncode({'first_mes': '默认开场'}),
      sourceType: 'sillytavern',
      createdAt: 1,
      updatedAt: 1,
    ));
    final id = await SessionRepository(db)
        .createSession('c1', openingMessage: '我选的备选');
    final messages = await db.getMessages(id);
    expect(messages.single.content, '我选的备选');
    await db.close();
  });
}
