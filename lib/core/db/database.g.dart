// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, Character> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _corePersonaJsonMeta = const VerificationMeta(
    'corePersonaJson',
  );
  @override
  late final GeneratedColumn<String> corePersonaJson = GeneratedColumn<String>(
    'core_persona_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldbookJsonMeta = const VerificationMeta(
    'worldbookJson',
  );
  @override
  late final GeneratedColumn<String> worldbookJson = GeneratedColumn<String>(
    'worldbook_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinnedAtMeta = const VerificationMeta(
    'pinnedAt',
  );
  @override
  late final GeneratedColumn<int> pinnedAt = GeneratedColumn<int>(
    'pinned_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    corePersonaJson,
    worldbookJson,
    avatarPath,
    tags,
    sourceType,
    sourcePath,
    createdAt,
    updatedAt,
    pinnedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Character> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('core_persona_json')) {
      context.handle(
        _corePersonaJsonMeta,
        corePersonaJson.isAcceptableOrUnknown(
          data['core_persona_json']!,
          _corePersonaJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_corePersonaJsonMeta);
    }
    if (data.containsKey('worldbook_json')) {
      context.handle(
        _worldbookJsonMeta,
        worldbookJson.isAcceptableOrUnknown(
          data['worldbook_json']!,
          _worldbookJsonMeta,
        ),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('pinned_at')) {
      context.handle(
        _pinnedAtMeta,
        pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Character map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Character(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      corePersonaJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}core_persona_json'],
      )!,
      worldbookJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_json'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      pinnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pinned_at'],
      ),
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }
}

class Character extends DataClass implements Insertable<Character> {
  final String id;
  final String name;

  /// 核心人格 JSON（description/personality/scenario/first_mes/system_prompt…）。
  final String corePersonaJson;

  /// 世界书 JSON（MVP 暂存于此，P2 迁入 Worlds）。
  final String? worldbookJson;
  final String? avatarPath;

  /// JSON 数组（自由标签，不做内容管控）。
  final String tags;

  /// 来源：sillytavern / skill / manual。
  final String sourceType;
  final String? sourcePath;
  final int createdAt;
  final int updatedAt;

  /// 置顶时间戳；null = 未置顶（联系人列表置顶区按此倒序）。
  final int? pinnedAt;
  const Character({
    required this.id,
    required this.name,
    required this.corePersonaJson,
    this.worldbookJson,
    this.avatarPath,
    required this.tags,
    required this.sourceType,
    this.sourcePath,
    required this.createdAt,
    required this.updatedAt,
    this.pinnedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['core_persona_json'] = Variable<String>(corePersonaJson);
    if (!nullToAbsent || worldbookJson != null) {
      map['worldbook_json'] = Variable<String>(worldbookJson);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['tags'] = Variable<String>(tags);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourcePath != null) {
      map['source_path'] = Variable<String>(sourcePath);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || pinnedAt != null) {
      map['pinned_at'] = Variable<int>(pinnedAt);
    }
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      id: Value(id),
      name: Value(name),
      corePersonaJson: Value(corePersonaJson),
      worldbookJson: worldbookJson == null && nullToAbsent
          ? const Value.absent()
          : Value(worldbookJson),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      tags: Value(tags),
      sourceType: Value(sourceType),
      sourcePath: sourcePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      pinnedAt: pinnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedAt),
    );
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Character(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      corePersonaJson: serializer.fromJson<String>(json['corePersonaJson']),
      worldbookJson: serializer.fromJson<String?>(json['worldbookJson']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      tags: serializer.fromJson<String>(json['tags']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourcePath: serializer.fromJson<String?>(json['sourcePath']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      pinnedAt: serializer.fromJson<int?>(json['pinnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'corePersonaJson': serializer.toJson<String>(corePersonaJson),
      'worldbookJson': serializer.toJson<String?>(worldbookJson),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'tags': serializer.toJson<String>(tags),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourcePath': serializer.toJson<String?>(sourcePath),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'pinnedAt': serializer.toJson<int?>(pinnedAt),
    };
  }

  Character copyWith({
    String? id,
    String? name,
    String? corePersonaJson,
    Value<String?> worldbookJson = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    String? tags,
    String? sourceType,
    Value<String?> sourcePath = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    Value<int?> pinnedAt = const Value.absent(),
  }) => Character(
    id: id ?? this.id,
    name: name ?? this.name,
    corePersonaJson: corePersonaJson ?? this.corePersonaJson,
    worldbookJson: worldbookJson.present
        ? worldbookJson.value
        : this.worldbookJson,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    tags: tags ?? this.tags,
    sourceType: sourceType ?? this.sourceType,
    sourcePath: sourcePath.present ? sourcePath.value : this.sourcePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    pinnedAt: pinnedAt.present ? pinnedAt.value : this.pinnedAt,
  );
  Character copyWithCompanion(CharactersCompanion data) {
    return Character(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      corePersonaJson: data.corePersonaJson.present
          ? data.corePersonaJson.value
          : this.corePersonaJson,
      worldbookJson: data.worldbookJson.present
          ? data.worldbookJson.value
          : this.worldbookJson,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      tags: data.tags.present ? data.tags.value : this.tags,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Character(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('corePersonaJson: $corePersonaJson, ')
          ..write('worldbookJson: $worldbookJson, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('tags: $tags, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('pinnedAt: $pinnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    corePersonaJson,
    worldbookJson,
    avatarPath,
    tags,
    sourceType,
    sourcePath,
    createdAt,
    updatedAt,
    pinnedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Character &&
          other.id == this.id &&
          other.name == this.name &&
          other.corePersonaJson == this.corePersonaJson &&
          other.worldbookJson == this.worldbookJson &&
          other.avatarPath == this.avatarPath &&
          other.tags == this.tags &&
          other.sourceType == this.sourceType &&
          other.sourcePath == this.sourcePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.pinnedAt == this.pinnedAt);
}

class CharactersCompanion extends UpdateCompanion<Character> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> corePersonaJson;
  final Value<String?> worldbookJson;
  final Value<String?> avatarPath;
  final Value<String> tags;
  final Value<String> sourceType;
  final Value<String?> sourcePath;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> pinnedAt;
  final Value<int> rowid;
  const CharactersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.corePersonaJson = const Value.absent(),
    this.worldbookJson = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.tags = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    required String id,
    required String name,
    required String corePersonaJson,
    this.worldbookJson = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.tags = const Value.absent(),
    required String sourceType,
    this.sourcePath = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.pinnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       corePersonaJson = Value(corePersonaJson),
       sourceType = Value(sourceType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Character> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? corePersonaJson,
    Expression<String>? worldbookJson,
    Expression<String>? avatarPath,
    Expression<String>? tags,
    Expression<String>? sourceType,
    Expression<String>? sourcePath,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? pinnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (corePersonaJson != null) 'core_persona_json': corePersonaJson,
      if (worldbookJson != null) 'worldbook_json': worldbookJson,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (tags != null) 'tags': tags,
      if (sourceType != null) 'source_type': sourceType,
      if (sourcePath != null) 'source_path': sourcePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? corePersonaJson,
    Value<String?>? worldbookJson,
    Value<String?>? avatarPath,
    Value<String>? tags,
    Value<String>? sourceType,
    Value<String?>? sourcePath,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? pinnedAt,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      corePersonaJson: corePersonaJson ?? this.corePersonaJson,
      worldbookJson: worldbookJson ?? this.worldbookJson,
      avatarPath: avatarPath ?? this.avatarPath,
      tags: tags ?? this.tags,
      sourceType: sourceType ?? this.sourceType,
      sourcePath: sourcePath ?? this.sourcePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (corePersonaJson.present) {
      map['core_persona_json'] = Variable<String>(corePersonaJson.value);
    }
    if (worldbookJson.present) {
      map['worldbook_json'] = Variable<String>(worldbookJson.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<int>(pinnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('corePersonaJson: $corePersonaJson, ')
          ..write('worldbookJson: $worldbookJson, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('tags: $tags, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterAdaptationsTable extends CharacterAdaptations
    with TableInfo<$CharacterAdaptationsTable, CharacterAdaptation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterAdaptationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _adaptationJsonMeta = const VerificationMeta(
    'adaptationJson',
  );
  @override
  late final GeneratedColumn<String> adaptationJson = GeneratedColumn<String>(
    'adaptation_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    worldId,
    adaptationJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_adaptations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterAdaptation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('adaptation_json')) {
      context.handle(
        _adaptationJsonMeta,
        adaptationJson.isAcceptableOrUnknown(
          data['adaptation_json']!,
          _adaptationJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_adaptationJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {characterId, worldId},
  ];
  @override
  CharacterAdaptation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterAdaptation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      adaptationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adaptation_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharacterAdaptationsTable createAlias(String alias) {
    return $CharacterAdaptationsTable(attachedDatabase, alias);
  }
}

class CharacterAdaptation extends DataClass
    implements Insertable<CharacterAdaptation> {
  final String id;
  final String characterId;

  /// 空串表示默认适配；非空逻辑上引用 Worlds.id。
  final String worldId;

  /// 语气/人设/关系设定 JSON。
  final String adaptationJson;
  final int createdAt;
  final int updatedAt;
  const CharacterAdaptation({
    required this.id,
    required this.characterId,
    required this.worldId,
    required this.adaptationJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['character_id'] = Variable<String>(characterId);
    map['world_id'] = Variable<String>(worldId);
    map['adaptation_json'] = Variable<String>(adaptationJson);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CharacterAdaptationsCompanion toCompanion(bool nullToAbsent) {
    return CharacterAdaptationsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      worldId: Value(worldId),
      adaptationJson: Value(adaptationJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CharacterAdaptation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterAdaptation(
      id: serializer.fromJson<String>(json['id']),
      characterId: serializer.fromJson<String>(json['characterId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      adaptationJson: serializer.fromJson<String>(json['adaptationJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'characterId': serializer.toJson<String>(characterId),
      'worldId': serializer.toJson<String>(worldId),
      'adaptationJson': serializer.toJson<String>(adaptationJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CharacterAdaptation copyWith({
    String? id,
    String? characterId,
    String? worldId,
    String? adaptationJson,
    int? createdAt,
    int? updatedAt,
  }) => CharacterAdaptation(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    worldId: worldId ?? this.worldId,
    adaptationJson: adaptationJson ?? this.adaptationJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CharacterAdaptation copyWithCompanion(CharacterAdaptationsCompanion data) {
    return CharacterAdaptation(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      adaptationJson: data.adaptationJson.present
          ? data.adaptationJson.value
          : this.adaptationJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAdaptation(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('adaptationJson: $adaptationJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    worldId,
    adaptationJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterAdaptation &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.adaptationJson == this.adaptationJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CharacterAdaptationsCompanion
    extends UpdateCompanion<CharacterAdaptation> {
  final Value<String> id;
  final Value<String> characterId;
  final Value<String> worldId;
  final Value<String> adaptationJson;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CharacterAdaptationsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.adaptationJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterAdaptationsCompanion.insert({
    required String id,
    required String characterId,
    this.worldId = const Value.absent(),
    required String adaptationJson,
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       characterId = Value(characterId),
       adaptationJson = Value(adaptationJson),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterAdaptation> custom({
    Expression<String>? id,
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? adaptationJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (adaptationJson != null) 'adaptation_json': adaptationJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterAdaptationsCompanion copyWith({
    Value<String>? id,
    Value<String>? characterId,
    Value<String>? worldId,
    Value<String>? adaptationJson,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CharacterAdaptationsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      adaptationJson: adaptationJson ?? this.adaptationJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (adaptationJson.present) {
      map['adaptation_json'] = Variable<String>(adaptationJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAdaptationsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('adaptationJson: $adaptationJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldsTable extends Worlds with TableInfo<$WorldsTable, World> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rulesJsonMeta = const VerificationMeta(
    'rulesJson',
  );
  @override
  late final GeneratedColumn<String> rulesJson = GeneratedColumn<String>(
    'rules_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _worldbookJsonMeta = const VerificationMeta(
    'worldbookJson',
  );
  @override
  late final GeneratedColumn<String> worldbookJson = GeneratedColumn<String>(
    'worldbook_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _initialStateJsonMeta = const VerificationMeta(
    'initialStateJson',
  );
  @override
  late final GeneratedColumn<String> initialStateJson = GeneratedColumn<String>(
    'initial_state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _npcPoolJsonMeta = const VerificationMeta(
    'npcPoolJson',
  );
  @override
  late final GeneratedColumn<String> npcPoolJson = GeneratedColumn<String>(
    'npc_pool_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    rulesJson,
    worldbookJson,
    initialStateJson,
    npcPoolJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worlds';
  @override
  VerificationContext validateIntegrity(
    Insertable<World> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('rules_json')) {
      context.handle(
        _rulesJsonMeta,
        rulesJson.isAcceptableOrUnknown(data['rules_json']!, _rulesJsonMeta),
      );
    }
    if (data.containsKey('worldbook_json')) {
      context.handle(
        _worldbookJsonMeta,
        worldbookJson.isAcceptableOrUnknown(
          data['worldbook_json']!,
          _worldbookJsonMeta,
        ),
      );
    }
    if (data.containsKey('initial_state_json')) {
      context.handle(
        _initialStateJsonMeta,
        initialStateJson.isAcceptableOrUnknown(
          data['initial_state_json']!,
          _initialStateJsonMeta,
        ),
      );
    }
    if (data.containsKey('npc_pool_json')) {
      context.handle(
        _npcPoolJsonMeta,
        npcPoolJson.isAcceptableOrUnknown(
          data['npc_pool_json']!,
          _npcPoolJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  World map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return World(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      rulesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rules_json'],
      )!,
      worldbookJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_json'],
      )!,
      initialStateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}initial_state_json'],
      )!,
      npcPoolJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}npc_pool_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorldsTable createAlias(String alias) {
    return $WorldsTable(attachedDatabase, alias);
  }
}

class World extends DataClass implements Insertable<World> {
  final String id;
  final String name;
  final String? description;
  final String rulesJson;
  final String worldbookJson;
  final String initialStateJson;
  final String npcPoolJson;
  final int createdAt;
  final int updatedAt;
  const World({
    required this.id,
    required this.name,
    this.description,
    required this.rulesJson,
    required this.worldbookJson,
    required this.initialStateJson,
    required this.npcPoolJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['rules_json'] = Variable<String>(rulesJson);
    map['worldbook_json'] = Variable<String>(worldbookJson);
    map['initial_state_json'] = Variable<String>(initialStateJson);
    map['npc_pool_json'] = Variable<String>(npcPoolJson);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WorldsCompanion toCompanion(bool nullToAbsent) {
    return WorldsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      rulesJson: Value(rulesJson),
      worldbookJson: Value(worldbookJson),
      initialStateJson: Value(initialStateJson),
      npcPoolJson: Value(npcPoolJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory World.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return World(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      rulesJson: serializer.fromJson<String>(json['rulesJson']),
      worldbookJson: serializer.fromJson<String>(json['worldbookJson']),
      initialStateJson: serializer.fromJson<String>(json['initialStateJson']),
      npcPoolJson: serializer.fromJson<String>(json['npcPoolJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'rulesJson': serializer.toJson<String>(rulesJson),
      'worldbookJson': serializer.toJson<String>(worldbookJson),
      'initialStateJson': serializer.toJson<String>(initialStateJson),
      'npcPoolJson': serializer.toJson<String>(npcPoolJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  World copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? rulesJson,
    String? worldbookJson,
    String? initialStateJson,
    String? npcPoolJson,
    int? createdAt,
    int? updatedAt,
  }) => World(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    rulesJson: rulesJson ?? this.rulesJson,
    worldbookJson: worldbookJson ?? this.worldbookJson,
    initialStateJson: initialStateJson ?? this.initialStateJson,
    npcPoolJson: npcPoolJson ?? this.npcPoolJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  World copyWithCompanion(WorldsCompanion data) {
    return World(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      rulesJson: data.rulesJson.present ? data.rulesJson.value : this.rulesJson,
      worldbookJson: data.worldbookJson.present
          ? data.worldbookJson.value
          : this.worldbookJson,
      initialStateJson: data.initialStateJson.present
          ? data.initialStateJson.value
          : this.initialStateJson,
      npcPoolJson: data.npcPoolJson.present
          ? data.npcPoolJson.value
          : this.npcPoolJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('World(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('worldbookJson: $worldbookJson, ')
          ..write('initialStateJson: $initialStateJson, ')
          ..write('npcPoolJson: $npcPoolJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    rulesJson,
    worldbookJson,
    initialStateJson,
    npcPoolJson,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is World &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.rulesJson == this.rulesJson &&
          other.worldbookJson == this.worldbookJson &&
          other.initialStateJson == this.initialStateJson &&
          other.npcPoolJson == this.npcPoolJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorldsCompanion extends UpdateCompanion<World> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> rulesJson;
  final Value<String> worldbookJson;
  final Value<String> initialStateJson;
  final Value<String> npcPoolJson;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WorldsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.worldbookJson = const Value.absent(),
    this.initialStateJson = const Value.absent(),
    this.npcPoolJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.rulesJson = const Value.absent(),
    this.worldbookJson = const Value.absent(),
    this.initialStateJson = const Value.absent(),
    this.npcPoolJson = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<World> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? rulesJson,
    Expression<String>? worldbookJson,
    Expression<String>? initialStateJson,
    Expression<String>? npcPoolJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (rulesJson != null) 'rules_json': rulesJson,
      if (worldbookJson != null) 'worldbook_json': worldbookJson,
      if (initialStateJson != null) 'initial_state_json': initialStateJson,
      if (npcPoolJson != null) 'npc_pool_json': npcPoolJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? rulesJson,
    Value<String>? worldbookJson,
    Value<String>? initialStateJson,
    Value<String>? npcPoolJson,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorldsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rulesJson: rulesJson ?? this.rulesJson,
      worldbookJson: worldbookJson ?? this.worldbookJson,
      initialStateJson: initialStateJson ?? this.initialStateJson,
      npcPoolJson: npcPoolJson ?? this.npcPoolJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rulesJson.present) {
      map['rules_json'] = Variable<String>(rulesJson.value);
    }
    if (worldbookJson.present) {
      map['worldbook_json'] = Variable<String>(worldbookJson.value);
    }
    if (initialStateJson.present) {
      map['initial_state_json'] = Variable<String>(initialStateJson.value);
    }
    if (npcPoolJson.present) {
      map['npc_pool_json'] = Variable<String>(npcPoolJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('rulesJson: $rulesJson, ')
          ..write('worldbookJson: $worldbookJson, ')
          ..write('initialStateJson: $initialStateJson, ')
          ..write('npcPoolJson: $npcPoolJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adaptationIdMeta = const VerificationMeta(
    'adaptationId',
  );
  @override
  late final GeneratedColumn<String> adaptationId = GeneratedColumn<String>(
    'adaptation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personaMeta = const VerificationMeta(
    'persona',
  );
  @override
  late final GeneratedColumn<String> persona = GeneratedColumn<String>(
    'persona',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoryEnabledMeta = const VerificationMeta(
    'memoryEnabled',
  );
  @override
  late final GeneratedColumn<bool> memoryEnabled = GeneratedColumn<bool>(
    'memory_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("memory_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _contextWindowLimitMeta =
      const VerificationMeta('contextWindowLimit');
  @override
  late final GeneratedColumn<String> contextWindowLimit =
      GeneratedColumn<String>(
        'context_window_limit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topPMeta = const VerificationMeta('topP');
  @override
  late final GeneratedColumn<double> topP = GeneratedColumn<double>(
    'top_p',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxTokensMeta = const VerificationMeta(
    'maxTokens',
  );
  @override
  late final GeneratedColumn<int> maxTokens = GeneratedColumn<int>(
    'max_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presencePenaltyMeta = const VerificationMeta(
    'presencePenalty',
  );
  @override
  late final GeneratedColumn<double> presencePenalty = GeneratedColumn<double>(
    'presence_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyPenaltyMeta = const VerificationMeta(
    'frequencyPenalty',
  );
  @override
  late final GeneratedColumn<double> frequencyPenalty = GeneratedColumn<double>(
    'frequency_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _worldbookIdsJsonMeta = const VerificationMeta(
    'worldbookIdsJson',
  );
  @override
  late final GeneratedColumn<String> worldbookIdsJson = GeneratedColumn<String>(
    'worldbook_ids_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<int> lastMessageAt = GeneratedColumn<int>(
    'last_message_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    characterId,
    worldId,
    adaptationId,
    title,
    persona,
    memoryEnabled,
    contextWindowLimit,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    worldbookIdsJson,
    createdAt,
    updatedAt,
    lastMessageAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('adaptation_id')) {
      context.handle(
        _adaptationIdMeta,
        adaptationId.isAcceptableOrUnknown(
          data['adaptation_id']!,
          _adaptationIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('persona')) {
      context.handle(
        _personaMeta,
        persona.isAcceptableOrUnknown(data['persona']!, _personaMeta),
      );
    }
    if (data.containsKey('memory_enabled')) {
      context.handle(
        _memoryEnabledMeta,
        memoryEnabled.isAcceptableOrUnknown(
          data['memory_enabled']!,
          _memoryEnabledMeta,
        ),
      );
    }
    if (data.containsKey('context_window_limit')) {
      context.handle(
        _contextWindowLimitMeta,
        contextWindowLimit.isAcceptableOrUnknown(
          data['context_window_limit']!,
          _contextWindowLimitMeta,
        ),
      );
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('top_p')) {
      context.handle(
        _topPMeta,
        topP.isAcceptableOrUnknown(data['top_p']!, _topPMeta),
      );
    }
    if (data.containsKey('max_tokens')) {
      context.handle(
        _maxTokensMeta,
        maxTokens.isAcceptableOrUnknown(data['max_tokens']!, _maxTokensMeta),
      );
    }
    if (data.containsKey('presence_penalty')) {
      context.handle(
        _presencePenaltyMeta,
        presencePenalty.isAcceptableOrUnknown(
          data['presence_penalty']!,
          _presencePenaltyMeta,
        ),
      );
    }
    if (data.containsKey('frequency_penalty')) {
      context.handle(
        _frequencyPenaltyMeta,
        frequencyPenalty.isAcceptableOrUnknown(
          data['frequency_penalty']!,
          _frequencyPenaltyMeta,
        ),
      );
    }
    if (data.containsKey('worldbook_ids_json')) {
      context.handle(
        _worldbookIdsJsonMeta,
        worldbookIdsJson.isAcceptableOrUnknown(
          data['worldbook_ids_json']!,
          _worldbookIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastMessageAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      ),
      adaptationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adaptation_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      persona: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}persona'],
      ),
      memoryEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}memory_enabled'],
      )!,
      contextWindowLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_window_limit'],
      ),
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      topP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_p'],
      ),
      maxTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_tokens'],
      ),
      presencePenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}presence_penalty'],
      ),
      frequencyPenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frequency_penalty'],
      ),
      worldbookIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_ids_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_message_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final String id;
  final String characterId;

  /// 逻辑上引用 Worlds.id（无外键，允许为空）。
  final String? worldId;

  /// 逻辑上引用 CharacterAdaptations.id（无外键）。
  final String? adaptationId;
  final String? title;

  /// 用户人设 JSON（可选，空着跳过）。
  final String? persona;

  /// 跨世界记忆开关，默认开启。
  final bool memoryEnabled;
  final String? contextWindowLimit;

  /// 会话级采样参数（null = 用默认）。[providerId] 指向 [ProviderConfigs].id。
  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;

  /// 会话级世界书选择（JSON 数组）；null = 用角色绑定默认。
  final String? worldbookIdsJson;
  final int createdAt;
  final int updatedAt;
  final int lastMessageAt;
  const Session({
    required this.id,
    required this.characterId,
    this.worldId,
    this.adaptationId,
    this.title,
    this.persona,
    required this.memoryEnabled,
    this.contextWindowLimit,
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
    this.worldbookIdsJson,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessageAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['character_id'] = Variable<String>(characterId);
    if (!nullToAbsent || worldId != null) {
      map['world_id'] = Variable<String>(worldId);
    }
    if (!nullToAbsent || adaptationId != null) {
      map['adaptation_id'] = Variable<String>(adaptationId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || persona != null) {
      map['persona'] = Variable<String>(persona);
    }
    map['memory_enabled'] = Variable<bool>(memoryEnabled);
    if (!nullToAbsent || contextWindowLimit != null) {
      map['context_window_limit'] = Variable<String>(contextWindowLimit);
    }
    if (!nullToAbsent || providerId != null) {
      map['provider_id'] = Variable<String>(providerId);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || topP != null) {
      map['top_p'] = Variable<double>(topP);
    }
    if (!nullToAbsent || maxTokens != null) {
      map['max_tokens'] = Variable<int>(maxTokens);
    }
    if (!nullToAbsent || presencePenalty != null) {
      map['presence_penalty'] = Variable<double>(presencePenalty);
    }
    if (!nullToAbsent || frequencyPenalty != null) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty);
    }
    if (!nullToAbsent || worldbookIdsJson != null) {
      map['worldbook_ids_json'] = Variable<String>(worldbookIdsJson);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['last_message_at'] = Variable<int>(lastMessageAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      characterId: Value(characterId),
      worldId: worldId == null && nullToAbsent
          ? const Value.absent()
          : Value(worldId),
      adaptationId: adaptationId == null && nullToAbsent
          ? const Value.absent()
          : Value(adaptationId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      persona: persona == null && nullToAbsent
          ? const Value.absent()
          : Value(persona),
      memoryEnabled: Value(memoryEnabled),
      contextWindowLimit: contextWindowLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(contextWindowLimit),
      providerId: providerId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerId),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      topP: topP == null && nullToAbsent ? const Value.absent() : Value(topP),
      maxTokens: maxTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTokens),
      presencePenalty: presencePenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(presencePenalty),
      frequencyPenalty: frequencyPenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyPenalty),
      worldbookIdsJson: worldbookIdsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(worldbookIdsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastMessageAt: Value(lastMessageAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<String>(json['id']),
      characterId: serializer.fromJson<String>(json['characterId']),
      worldId: serializer.fromJson<String?>(json['worldId']),
      adaptationId: serializer.fromJson<String?>(json['adaptationId']),
      title: serializer.fromJson<String?>(json['title']),
      persona: serializer.fromJson<String?>(json['persona']),
      memoryEnabled: serializer.fromJson<bool>(json['memoryEnabled']),
      contextWindowLimit: serializer.fromJson<String?>(
        json['contextWindowLimit'],
      ),
      providerId: serializer.fromJson<String?>(json['providerId']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      topP: serializer.fromJson<double?>(json['topP']),
      maxTokens: serializer.fromJson<int?>(json['maxTokens']),
      presencePenalty: serializer.fromJson<double?>(json['presencePenalty']),
      frequencyPenalty: serializer.fromJson<double?>(json['frequencyPenalty']),
      worldbookIdsJson: serializer.fromJson<String?>(json['worldbookIdsJson']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      lastMessageAt: serializer.fromJson<int>(json['lastMessageAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'characterId': serializer.toJson<String>(characterId),
      'worldId': serializer.toJson<String?>(worldId),
      'adaptationId': serializer.toJson<String?>(adaptationId),
      'title': serializer.toJson<String?>(title),
      'persona': serializer.toJson<String?>(persona),
      'memoryEnabled': serializer.toJson<bool>(memoryEnabled),
      'contextWindowLimit': serializer.toJson<String?>(contextWindowLimit),
      'providerId': serializer.toJson<String?>(providerId),
      'temperature': serializer.toJson<double?>(temperature),
      'topP': serializer.toJson<double?>(topP),
      'maxTokens': serializer.toJson<int?>(maxTokens),
      'presencePenalty': serializer.toJson<double?>(presencePenalty),
      'frequencyPenalty': serializer.toJson<double?>(frequencyPenalty),
      'worldbookIdsJson': serializer.toJson<String?>(worldbookIdsJson),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'lastMessageAt': serializer.toJson<int>(lastMessageAt),
    };
  }

  Session copyWith({
    String? id,
    String? characterId,
    Value<String?> worldId = const Value.absent(),
    Value<String?> adaptationId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> persona = const Value.absent(),
    bool? memoryEnabled,
    Value<String?> contextWindowLimit = const Value.absent(),
    Value<String?> providerId = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> topP = const Value.absent(),
    Value<int?> maxTokens = const Value.absent(),
    Value<double?> presencePenalty = const Value.absent(),
    Value<double?> frequencyPenalty = const Value.absent(),
    Value<String?> worldbookIdsJson = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? lastMessageAt,
  }) => Session(
    id: id ?? this.id,
    characterId: characterId ?? this.characterId,
    worldId: worldId.present ? worldId.value : this.worldId,
    adaptationId: adaptationId.present ? adaptationId.value : this.adaptationId,
    title: title.present ? title.value : this.title,
    persona: persona.present ? persona.value : this.persona,
    memoryEnabled: memoryEnabled ?? this.memoryEnabled,
    contextWindowLimit: contextWindowLimit.present
        ? contextWindowLimit.value
        : this.contextWindowLimit,
    providerId: providerId.present ? providerId.value : this.providerId,
    temperature: temperature.present ? temperature.value : this.temperature,
    topP: topP.present ? topP.value : this.topP,
    maxTokens: maxTokens.present ? maxTokens.value : this.maxTokens,
    presencePenalty: presencePenalty.present
        ? presencePenalty.value
        : this.presencePenalty,
    frequencyPenalty: frequencyPenalty.present
        ? frequencyPenalty.value
        : this.frequencyPenalty,
    worldbookIdsJson: worldbookIdsJson.present
        ? worldbookIdsJson.value
        : this.worldbookIdsJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      adaptationId: data.adaptationId.present
          ? data.adaptationId.value
          : this.adaptationId,
      title: data.title.present ? data.title.value : this.title,
      persona: data.persona.present ? data.persona.value : this.persona,
      memoryEnabled: data.memoryEnabled.present
          ? data.memoryEnabled.value
          : this.memoryEnabled,
      contextWindowLimit: data.contextWindowLimit.present
          ? data.contextWindowLimit.value
          : this.contextWindowLimit,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      topP: data.topP.present ? data.topP.value : this.topP,
      maxTokens: data.maxTokens.present ? data.maxTokens.value : this.maxTokens,
      presencePenalty: data.presencePenalty.present
          ? data.presencePenalty.value
          : this.presencePenalty,
      frequencyPenalty: data.frequencyPenalty.present
          ? data.frequencyPenalty.value
          : this.frequencyPenalty,
      worldbookIdsJson: data.worldbookIdsJson.present
          ? data.worldbookIdsJson.value
          : this.worldbookIdsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('adaptationId: $adaptationId, ')
          ..write('title: $title, ')
          ..write('persona: $persona, ')
          ..write('memoryEnabled: $memoryEnabled, ')
          ..write('contextWindowLimit: $contextWindowLimit, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('worldbookIdsJson: $worldbookIdsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessageAt: $lastMessageAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    characterId,
    worldId,
    adaptationId,
    title,
    persona,
    memoryEnabled,
    contextWindowLimit,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    worldbookIdsJson,
    createdAt,
    updatedAt,
    lastMessageAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.adaptationId == this.adaptationId &&
          other.title == this.title &&
          other.persona == this.persona &&
          other.memoryEnabled == this.memoryEnabled &&
          other.contextWindowLimit == this.contextWindowLimit &&
          other.providerId == this.providerId &&
          other.temperature == this.temperature &&
          other.topP == this.topP &&
          other.maxTokens == this.maxTokens &&
          other.presencePenalty == this.presencePenalty &&
          other.frequencyPenalty == this.frequencyPenalty &&
          other.worldbookIdsJson == this.worldbookIdsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastMessageAt == this.lastMessageAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<String> id;
  final Value<String> characterId;
  final Value<String?> worldId;
  final Value<String?> adaptationId;
  final Value<String?> title;
  final Value<String?> persona;
  final Value<bool> memoryEnabled;
  final Value<String?> contextWindowLimit;
  final Value<String?> providerId;
  final Value<double?> temperature;
  final Value<double?> topP;
  final Value<int?> maxTokens;
  final Value<double?> presencePenalty;
  final Value<double?> frequencyPenalty;
  final Value<String?> worldbookIdsJson;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> lastMessageAt;
  final Value<int> rowid;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.adaptationId = const Value.absent(),
    this.title = const Value.absent(),
    this.persona = const Value.absent(),
    this.memoryEnabled = const Value.absent(),
    this.contextWindowLimit = const Value.absent(),
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    this.worldbookIdsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionsCompanion.insert({
    required String id,
    required String characterId,
    this.worldId = const Value.absent(),
    this.adaptationId = const Value.absent(),
    this.title = const Value.absent(),
    this.persona = const Value.absent(),
    this.memoryEnabled = const Value.absent(),
    this.contextWindowLimit = const Value.absent(),
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    this.worldbookIdsJson = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    required int lastMessageAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       characterId = Value(characterId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastMessageAt = Value(lastMessageAt);
  static Insertable<Session> custom({
    Expression<String>? id,
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? adaptationId,
    Expression<String>? title,
    Expression<String>? persona,
    Expression<bool>? memoryEnabled,
    Expression<String>? contextWindowLimit,
    Expression<String>? providerId,
    Expression<double>? temperature,
    Expression<double>? topP,
    Expression<int>? maxTokens,
    Expression<double>? presencePenalty,
    Expression<double>? frequencyPenalty,
    Expression<String>? worldbookIdsJson,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? lastMessageAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (adaptationId != null) 'adaptation_id': adaptationId,
      if (title != null) 'title': title,
      if (persona != null) 'persona': persona,
      if (memoryEnabled != null) 'memory_enabled': memoryEnabled,
      if (contextWindowLimit != null)
        'context_window_limit': contextWindowLimit,
      if (providerId != null) 'provider_id': providerId,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (presencePenalty != null) 'presence_penalty': presencePenalty,
      if (frequencyPenalty != null) 'frequency_penalty': frequencyPenalty,
      if (worldbookIdsJson != null) 'worldbook_ids_json': worldbookIdsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? characterId,
    Value<String?>? worldId,
    Value<String?>? adaptationId,
    Value<String?>? title,
    Value<String?>? persona,
    Value<bool>? memoryEnabled,
    Value<String?>? contextWindowLimit,
    Value<String?>? providerId,
    Value<double?>? temperature,
    Value<double?>? topP,
    Value<int?>? maxTokens,
    Value<double?>? presencePenalty,
    Value<double?>? frequencyPenalty,
    Value<String?>? worldbookIdsJson,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? lastMessageAt,
    Value<int>? rowid,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      adaptationId: adaptationId ?? this.adaptationId,
      title: title ?? this.title,
      persona: persona ?? this.persona,
      memoryEnabled: memoryEnabled ?? this.memoryEnabled,
      contextWindowLimit: contextWindowLimit ?? this.contextWindowLimit,
      providerId: providerId ?? this.providerId,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      maxTokens: maxTokens ?? this.maxTokens,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      worldbookIdsJson: worldbookIdsJson ?? this.worldbookIdsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (adaptationId.present) {
      map['adaptation_id'] = Variable<String>(adaptationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (persona.present) {
      map['persona'] = Variable<String>(persona.value);
    }
    if (memoryEnabled.present) {
      map['memory_enabled'] = Variable<bool>(memoryEnabled.value);
    }
    if (contextWindowLimit.present) {
      map['context_window_limit'] = Variable<String>(contextWindowLimit.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (topP.present) {
      map['top_p'] = Variable<double>(topP.value);
    }
    if (maxTokens.present) {
      map['max_tokens'] = Variable<int>(maxTokens.value);
    }
    if (presencePenalty.present) {
      map['presence_penalty'] = Variable<double>(presencePenalty.value);
    }
    if (frequencyPenalty.present) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty.value);
    }
    if (worldbookIdsJson.present) {
      map['worldbook_ids_json'] = Variable<String>(worldbookIdsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<int>(lastMessageAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('adaptationId: $adaptationId, ')
          ..write('title: $title, ')
          ..write('persona: $persona, ')
          ..write('memoryEnabled: $memoryEnabled, ')
          ..write('contextWindowLimit: $contextWindowLimit, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('worldbookIdsJson: $worldbookIdsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visibleToAiMeta = const VerificationMeta(
    'visibleToAi',
  );
  @override
  late final GeneratedColumn<bool> visibleToAi = GeneratedColumn<bool>(
    'visible_to_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("visible_to_ai" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    role,
    content,
    orderIndex,
    timestamp,
    metadata,
    type,
    visibleToAi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('visible_to_ai')) {
      context.handle(
        _visibleToAiMeta,
        visibleToAi.isAcceptableOrUnknown(
          data['visible_to_ai']!,
          _visibleToAiMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      visibleToAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}visible_to_ai'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final String id;
  final String sessionId;

  /// user / assistant / system / npc / tool。
  final String role;
  final String content;

  /// 会话内递增序号。
  final int orderIndex;
  final int timestamp;

  /// JSON：token 数、finishReason、模型名等。
  final String metadata;

  /// 指令消息类型：null=普通消息，'command'=用户指令，'command_reply'=App 回复。
  final String? type;

  /// 是否进入 AI Prompt。指令消息为 false，不进下一轮上下文。
  final bool visibleToAi;
  const Message({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.orderIndex,
    required this.timestamp,
    required this.metadata,
    this.type,
    required this.visibleToAi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['order_index'] = Variable<int>(orderIndex);
    map['timestamp'] = Variable<int>(timestamp);
    map['metadata'] = Variable<String>(metadata);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['visible_to_ai'] = Variable<bool>(visibleToAi);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      role: Value(role),
      content: Value(content),
      orderIndex: Value(orderIndex),
      timestamp: Value(timestamp),
      metadata: Value(metadata),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      visibleToAi: Value(visibleToAi),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      metadata: serializer.fromJson<String>(json['metadata']),
      type: serializer.fromJson<String?>(json['type']),
      visibleToAi: serializer.fromJson<bool>(json['visibleToAi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'timestamp': serializer.toJson<int>(timestamp),
      'metadata': serializer.toJson<String>(metadata),
      'type': serializer.toJson<String?>(type),
      'visibleToAi': serializer.toJson<bool>(visibleToAi),
    };
  }

  Message copyWith({
    String? id,
    String? sessionId,
    String? role,
    String? content,
    int? orderIndex,
    int? timestamp,
    String? metadata,
    Value<String?> type = const Value.absent(),
    bool? visibleToAi,
  }) => Message(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    role: role ?? this.role,
    content: content ?? this.content,
    orderIndex: orderIndex ?? this.orderIndex,
    timestamp: timestamp ?? this.timestamp,
    metadata: metadata ?? this.metadata,
    type: type.present ? type.value : this.type,
    visibleToAi: visibleToAi ?? this.visibleToAi,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      type: data.type.present ? data.type.value : this.type,
      visibleToAi: data.visibleToAi.present
          ? data.visibleToAi.value
          : this.visibleToAi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('visibleToAi: $visibleToAi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    role,
    content,
    orderIndex,
    timestamp,
    metadata,
    type,
    visibleToAi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.role == this.role &&
          other.content == this.content &&
          other.orderIndex == this.orderIndex &&
          other.timestamp == this.timestamp &&
          other.metadata == this.metadata &&
          other.type == this.type &&
          other.visibleToAi == this.visibleToAi);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> role;
  final Value<String> content;
  final Value<int> orderIndex;
  final Value<int> timestamp;
  final Value<String> metadata;
  final Value<String?> type;
  final Value<bool> visibleToAi;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.metadata = const Value.absent(),
    this.type = const Value.absent(),
    this.visibleToAi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String sessionId,
    required String role,
    required String content,
    required int orderIndex,
    required int timestamp,
    this.metadata = const Value.absent(),
    this.type = const Value.absent(),
    this.visibleToAi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       role = Value(role),
       content = Value(content),
       orderIndex = Value(orderIndex),
       timestamp = Value(timestamp);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<int>? orderIndex,
    Expression<int>? timestamp,
    Expression<String>? metadata,
    Expression<String>? type,
    Expression<bool>? visibleToAi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (orderIndex != null) 'order_index': orderIndex,
      if (timestamp != null) 'timestamp': timestamp,
      if (metadata != null) 'metadata': metadata,
      if (type != null) 'type': type,
      if (visibleToAi != null) 'visible_to_ai': visibleToAi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? role,
    Value<String>? content,
    Value<int>? orderIndex,
    Value<int>? timestamp,
    Value<String>? metadata,
    Value<String?>? type,
    Value<bool>? visibleToAi,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      type: type ?? this.type,
      visibleToAi: visibleToAi ?? this.visibleToAi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (visibleToAi.present) {
      map['visible_to_ai'] = Variable<bool>(visibleToAi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('timestamp: $timestamp, ')
          ..write('metadata: $metadata, ')
          ..write('type: $type, ')
          ..write('visibleToAi: $visibleToAi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionStatesTable extends SessionStates
    with TableInfo<$SessionStatesTable, SessionState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stateJsonMeta = const VerificationMeta(
    'stateJson',
  );
  @override
  late final GeneratedColumn<String> stateJson = GeneratedColumn<String>(
    'state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _summaryTextMeta = const VerificationMeta(
    'summaryText',
  );
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
    'summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryIndexMeta = const VerificationMeta(
    'summaryIndex',
  );
  @override
  late final GeneratedColumn<int> summaryIndex = GeneratedColumn<int>(
    'summary_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    stateJson,
    summaryText,
    summaryIndex,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('state_json')) {
      context.handle(
        _stateJsonMeta,
        stateJson.isAcceptableOrUnknown(data['state_json']!, _stateJsonMeta),
      );
    }
    if (data.containsKey('summary_text')) {
      context.handle(
        _summaryTextMeta,
        summaryText.isAcceptableOrUnknown(
          data['summary_text']!,
          _summaryTextMeta,
        ),
      );
    }
    if (data.containsKey('summary_index')) {
      context.handle(
        _summaryIndexMeta,
        summaryIndex.isAcceptableOrUnknown(
          data['summary_index']!,
          _summaryIndexMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  SessionState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionState(
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      stateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_json'],
      )!,
      summaryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_text'],
      )!,
      summaryIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}summary_index'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionStatesTable createAlias(String alias) {
    return $SessionStatesTable(attachedDatabase, alias);
  }
}

class SessionState extends DataClass implements Insertable<SessionState> {
  final String sessionId;
  final String stateJson;
  final String summaryText;
  final int summaryIndex;
  final int updatedAt;
  const SessionState({
    required this.sessionId,
    required this.stateJson,
    required this.summaryText,
    required this.summaryIndex,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['state_json'] = Variable<String>(stateJson);
    map['summary_text'] = Variable<String>(summaryText);
    map['summary_index'] = Variable<int>(summaryIndex);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SessionStatesCompanion toCompanion(bool nullToAbsent) {
    return SessionStatesCompanion(
      sessionId: Value(sessionId),
      stateJson: Value(stateJson),
      summaryText: Value(summaryText),
      summaryIndex: Value(summaryIndex),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionState(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      stateJson: serializer.fromJson<String>(json['stateJson']),
      summaryText: serializer.fromJson<String>(json['summaryText']),
      summaryIndex: serializer.fromJson<int>(json['summaryIndex']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'stateJson': serializer.toJson<String>(stateJson),
      'summaryText': serializer.toJson<String>(summaryText),
      'summaryIndex': serializer.toJson<int>(summaryIndex),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SessionState copyWith({
    String? sessionId,
    String? stateJson,
    String? summaryText,
    int? summaryIndex,
    int? updatedAt,
  }) => SessionState(
    sessionId: sessionId ?? this.sessionId,
    stateJson: stateJson ?? this.stateJson,
    summaryText: summaryText ?? this.summaryText,
    summaryIndex: summaryIndex ?? this.summaryIndex,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SessionState copyWithCompanion(SessionStatesCompanion data) {
    return SessionState(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      stateJson: data.stateJson.present ? data.stateJson.value : this.stateJson,
      summaryText: data.summaryText.present
          ? data.summaryText.value
          : this.summaryText,
      summaryIndex: data.summaryIndex.present
          ? data.summaryIndex.value
          : this.summaryIndex,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionState(')
          ..write('sessionId: $sessionId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('summaryIndex: $summaryIndex, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, stateJson, summaryText, summaryIndex, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionState &&
          other.sessionId == this.sessionId &&
          other.stateJson == this.stateJson &&
          other.summaryText == this.summaryText &&
          other.summaryIndex == this.summaryIndex &&
          other.updatedAt == this.updatedAt);
}

class SessionStatesCompanion extends UpdateCompanion<SessionState> {
  final Value<String> sessionId;
  final Value<String> stateJson;
  final Value<String> summaryText;
  final Value<int> summaryIndex;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SessionStatesCompanion({
    this.sessionId = const Value.absent(),
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.summaryIndex = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionStatesCompanion.insert({
    required String sessionId,
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.summaryIndex = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       updatedAt = Value(updatedAt);
  static Insertable<SessionState> custom({
    Expression<String>? sessionId,
    Expression<String>? stateJson,
    Expression<String>? summaryText,
    Expression<int>? summaryIndex,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (stateJson != null) 'state_json': stateJson,
      if (summaryText != null) 'summary_text': summaryText,
      if (summaryIndex != null) 'summary_index': summaryIndex,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionStatesCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? stateJson,
    Value<String>? summaryText,
    Value<int>? summaryIndex,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SessionStatesCompanion(
      sessionId: sessionId ?? this.sessionId,
      stateJson: stateJson ?? this.stateJson,
      summaryText: summaryText ?? this.summaryText,
      summaryIndex: summaryIndex ?? this.summaryIndex,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (stateJson.present) {
      map['state_json'] = Variable<String>(stateJson.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (summaryIndex.present) {
      map['summary_index'] = Variable<int>(summaryIndex.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionStatesCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('summaryIndex: $summaryIndex, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterRelationsTable extends CharacterRelations
    with TableInfo<$CharacterRelationsTable, CharacterRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _relationJsonMeta = const VerificationMeta(
    'relationJson',
  );
  @override
  late final GeneratedColumn<String> relationJson = GeneratedColumn<String>(
    'relation_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    characterId,
    worldId,
    relationJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('relation_json')) {
      context.handle(
        _relationJsonMeta,
        relationJson.isAcceptableOrUnknown(
          data['relation_json']!,
          _relationJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId, worldId};
  @override
  CharacterRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterRelation(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      relationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharacterRelationsTable createAlias(String alias) {
    return $CharacterRelationsTable(attachedDatabase, alias);
  }
}

class CharacterRelation extends DataClass
    implements Insertable<CharacterRelation> {
  final String characterId;
  final String worldId;
  final String relationJson;
  final int updatedAt;
  const CharacterRelation({
    required this.characterId,
    required this.worldId,
    required this.relationJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    map['world_id'] = Variable<String>(worldId);
    map['relation_json'] = Variable<String>(relationJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CharacterRelationsCompanion toCompanion(bool nullToAbsent) {
    return CharacterRelationsCompanion(
      characterId: Value(characterId),
      worldId: Value(worldId),
      relationJson: Value(relationJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CharacterRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterRelation(
      characterId: serializer.fromJson<String>(json['characterId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      relationJson: serializer.fromJson<String>(json['relationJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'worldId': serializer.toJson<String>(worldId),
      'relationJson': serializer.toJson<String>(relationJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CharacterRelation copyWith({
    String? characterId,
    String? worldId,
    String? relationJson,
    int? updatedAt,
  }) => CharacterRelation(
    characterId: characterId ?? this.characterId,
    worldId: worldId ?? this.worldId,
    relationJson: relationJson ?? this.relationJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CharacterRelation copyWithCompanion(CharacterRelationsCompanion data) {
    return CharacterRelation(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      relationJson: data.relationJson.present
          ? data.relationJson.value
          : this.relationJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRelation(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('relationJson: $relationJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(characterId, worldId, relationJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterRelation &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.relationJson == this.relationJson &&
          other.updatedAt == this.updatedAt);
}

class CharacterRelationsCompanion extends UpdateCompanion<CharacterRelation> {
  final Value<String> characterId;
  final Value<String> worldId;
  final Value<String> relationJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CharacterRelationsCompanion({
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.relationJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterRelationsCompanion.insert({
    required String characterId,
    this.worldId = const Value.absent(),
    this.relationJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterRelation> custom({
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? relationJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (relationJson != null) 'relation_json': relationJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterRelationsCompanion copyWith({
    Value<String>? characterId,
    Value<String>? worldId,
    Value<String>? relationJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CharacterRelationsCompanion(
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      relationJson: relationJson ?? this.relationJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (relationJson.present) {
      map['relation_json'] = Variable<String>(relationJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterRelationsCompanion(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('relationJson: $relationJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterAffinitiesTable extends CharacterAffinities
    with TableInfo<$CharacterAffinitiesTable, CharacterAffinity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterAffinitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _affinityJsonMeta = const VerificationMeta(
    'affinityJson',
  );
  @override
  late final GeneratedColumn<String> affinityJson = GeneratedColumn<String>(
    'affinity_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    characterId,
    worldId,
    affinityJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_affinities';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterAffinity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('affinity_json')) {
      context.handle(
        _affinityJsonMeta,
        affinityJson.isAcceptableOrUnknown(
          data['affinity_json']!,
          _affinityJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId, worldId};
  @override
  CharacterAffinity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterAffinity(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      affinityJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}affinity_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharacterAffinitiesTable createAlias(String alias) {
    return $CharacterAffinitiesTable(attachedDatabase, alias);
  }
}

class CharacterAffinity extends DataClass
    implements Insertable<CharacterAffinity> {
  final String characterId;
  final String worldId;
  final String affinityJson;
  final int updatedAt;
  const CharacterAffinity({
    required this.characterId,
    required this.worldId,
    required this.affinityJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    map['world_id'] = Variable<String>(worldId);
    map['affinity_json'] = Variable<String>(affinityJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CharacterAffinitiesCompanion toCompanion(bool nullToAbsent) {
    return CharacterAffinitiesCompanion(
      characterId: Value(characterId),
      worldId: Value(worldId),
      affinityJson: Value(affinityJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CharacterAffinity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterAffinity(
      characterId: serializer.fromJson<String>(json['characterId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      affinityJson: serializer.fromJson<String>(json['affinityJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'worldId': serializer.toJson<String>(worldId),
      'affinityJson': serializer.toJson<String>(affinityJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CharacterAffinity copyWith({
    String? characterId,
    String? worldId,
    String? affinityJson,
    int? updatedAt,
  }) => CharacterAffinity(
    characterId: characterId ?? this.characterId,
    worldId: worldId ?? this.worldId,
    affinityJson: affinityJson ?? this.affinityJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CharacterAffinity copyWithCompanion(CharacterAffinitiesCompanion data) {
    return CharacterAffinity(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      affinityJson: data.affinityJson.present
          ? data.affinityJson.value
          : this.affinityJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAffinity(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('affinityJson: $affinityJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(characterId, worldId, affinityJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterAffinity &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.affinityJson == this.affinityJson &&
          other.updatedAt == this.updatedAt);
}

class CharacterAffinitiesCompanion extends UpdateCompanion<CharacterAffinity> {
  final Value<String> characterId;
  final Value<String> worldId;
  final Value<String> affinityJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CharacterAffinitiesCompanion({
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.affinityJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterAffinitiesCompanion.insert({
    required String characterId,
    this.worldId = const Value.absent(),
    this.affinityJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterAffinity> custom({
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? affinityJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (affinityJson != null) 'affinity_json': affinityJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterAffinitiesCompanion copyWith({
    Value<String>? characterId,
    Value<String>? worldId,
    Value<String>? affinityJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CharacterAffinitiesCompanion(
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      affinityJson: affinityJson ?? this.affinityJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (affinityJson.present) {
      map['affinity_json'] = Variable<String>(affinityJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterAffinitiesCompanion(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('affinityJson: $affinityJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterMemoriesTable extends CharacterMemories
    with TableInfo<$CharacterMemoriesTable, CharacterMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _stateJsonMeta = const VerificationMeta(
    'stateJson',
  );
  @override
  late final GeneratedColumn<String> stateJson = GeneratedColumn<String>(
    'state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _summaryTextMeta = const VerificationMeta(
    'summaryText',
  );
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
    'summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    characterId,
    worldId,
    stateJson,
    summaryText,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('state_json')) {
      context.handle(
        _stateJsonMeta,
        stateJson.isAcceptableOrUnknown(data['state_json']!, _stateJsonMeta),
      );
    }
    if (data.containsKey('summary_text')) {
      context.handle(
        _summaryTextMeta,
        summaryText.isAcceptableOrUnknown(
          data['summary_text']!,
          _summaryTextMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId, worldId};
  @override
  CharacterMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterMemory(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      stateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_json'],
      )!,
      summaryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_text'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CharacterMemoriesTable createAlias(String alias) {
    return $CharacterMemoriesTable(attachedDatabase, alias);
  }
}

class CharacterMemory extends DataClass implements Insertable<CharacterMemory> {
  final String characterId;
  final String worldId;
  final String stateJson;
  final String summaryText;
  final int updatedAt;
  const CharacterMemory({
    required this.characterId,
    required this.worldId,
    required this.stateJson,
    required this.summaryText,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    map['world_id'] = Variable<String>(worldId);
    map['state_json'] = Variable<String>(stateJson);
    map['summary_text'] = Variable<String>(summaryText);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  CharacterMemoriesCompanion toCompanion(bool nullToAbsent) {
    return CharacterMemoriesCompanion(
      characterId: Value(characterId),
      worldId: Value(worldId),
      stateJson: Value(stateJson),
      summaryText: Value(summaryText),
      updatedAt: Value(updatedAt),
    );
  }

  factory CharacterMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterMemory(
      characterId: serializer.fromJson<String>(json['characterId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      stateJson: serializer.fromJson<String>(json['stateJson']),
      summaryText: serializer.fromJson<String>(json['summaryText']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'worldId': serializer.toJson<String>(worldId),
      'stateJson': serializer.toJson<String>(stateJson),
      'summaryText': serializer.toJson<String>(summaryText),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  CharacterMemory copyWith({
    String? characterId,
    String? worldId,
    String? stateJson,
    String? summaryText,
    int? updatedAt,
  }) => CharacterMemory(
    characterId: characterId ?? this.characterId,
    worldId: worldId ?? this.worldId,
    stateJson: stateJson ?? this.stateJson,
    summaryText: summaryText ?? this.summaryText,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CharacterMemory copyWithCompanion(CharacterMemoriesCompanion data) {
    return CharacterMemory(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      stateJson: data.stateJson.present ? data.stateJson.value : this.stateJson,
      summaryText: data.summaryText.present
          ? data.summaryText.value
          : this.summaryText,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterMemory(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(characterId, worldId, stateJson, summaryText, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterMemory &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.stateJson == this.stateJson &&
          other.summaryText == this.summaryText &&
          other.updatedAt == this.updatedAt);
}

class CharacterMemoriesCompanion extends UpdateCompanion<CharacterMemory> {
  final Value<String> characterId;
  final Value<String> worldId;
  final Value<String> stateJson;
  final Value<String> summaryText;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const CharacterMemoriesCompanion({
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterMemoriesCompanion.insert({
    required String characterId,
    this.worldId = const Value.absent(),
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId),
       updatedAt = Value(updatedAt);
  static Insertable<CharacterMemory> custom({
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? stateJson,
    Expression<String>? summaryText,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (stateJson != null) 'state_json': stateJson,
      if (summaryText != null) 'summary_text': summaryText,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterMemoriesCompanion copyWith({
    Value<String>? characterId,
    Value<String>? worldId,
    Value<String>? stateJson,
    Value<String>? summaryText,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return CharacterMemoriesCompanion(
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      stateJson: stateJson ?? this.stateJson,
      summaryText: summaryText ?? this.summaryText,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (stateJson.present) {
      map['state_json'] = Variable<String>(stateJson.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterMemoriesCompanion(')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProviderConfigsTable extends ProviderConfigs
    with TableInfo<$ProviderConfigsTable, ProviderConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apiKeyRefMeta = const VerificationMeta(
    'apiKeyRef',
  );
  @override
  late final GeneratedColumn<String> apiKeyRef = GeneratedColumn<String>(
    'api_key_ref',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _extraParamsJsonMeta = const VerificationMeta(
    'extraParamsJson',
  );
  @override
  late final GeneratedColumn<String> extraParamsJson = GeneratedColumn<String>(
    'extra_params_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _memoryModelMeta = const VerificationMeta(
    'memoryModel',
  );
  @override
  late final GeneratedColumn<String> memoryModel = GeneratedColumn<String>(
    'memory_model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contextWindowLimitMeta =
      const VerificationMeta('contextWindowLimit');
  @override
  late final GeneratedColumn<int> contextWindowLimit = GeneratedColumn<int>(
    'context_window_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    baseUrl,
    model,
    apiKeyRef,
    extraParamsJson,
    memoryModel,
    contextWindowLimit,
    isDefault,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('api_key_ref')) {
      context.handle(
        _apiKeyRefMeta,
        apiKeyRef.isAcceptableOrUnknown(data['api_key_ref']!, _apiKeyRefMeta),
      );
    }
    if (data.containsKey('extra_params_json')) {
      context.handle(
        _extraParamsJsonMeta,
        extraParamsJson.isAcceptableOrUnknown(
          data['extra_params_json']!,
          _extraParamsJsonMeta,
        ),
      );
    }
    if (data.containsKey('memory_model')) {
      context.handle(
        _memoryModelMeta,
        memoryModel.isAcceptableOrUnknown(
          data['memory_model']!,
          _memoryModelMeta,
        ),
      );
    }
    if (data.containsKey('context_window_limit')) {
      context.handle(
        _contextWindowLimitMeta,
        contextWindowLimit.isAcceptableOrUnknown(
          data['context_window_limit']!,
          _contextWindowLimitMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderConfig(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      apiKeyRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_key_ref'],
      )!,
      extraParamsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_params_json'],
      )!,
      memoryModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memory_model'],
      ),
      contextWindowLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}context_window_limit'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProviderConfigsTable createAlias(String alias) {
    return $ProviderConfigsTable(attachedDatabase, alias);
  }
}

class ProviderConfig extends DataClass implements Insertable<ProviderConfig> {
  final String id;
  final String name;

  /// openai / anthropic。
  final String type;
  final String baseUrl;
  final String model;

  /// 指向 flutter_secure_storage 的键名（如 `llm_api_key_<id>`）。
  final String apiKeyRef;
  final String extraParamsJson;

  /// 记忆抽取/摘要用的模型名（可选，留空则用 [model]；用于「便宜模型」）。
  final String? memoryModel;

  /// 模型上下文窗口上限（token 数），用于实时 token 显示；null = 用默认 32000。
  final int? contextWindowLimit;
  final bool isDefault;
  final int createdAt;
  final int updatedAt;
  const ProviderConfig({
    required this.id,
    required this.name,
    required this.type,
    required this.baseUrl,
    required this.model,
    required this.apiKeyRef,
    required this.extraParamsJson,
    this.memoryModel,
    this.contextWindowLimit,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['base_url'] = Variable<String>(baseUrl);
    map['model'] = Variable<String>(model);
    map['api_key_ref'] = Variable<String>(apiKeyRef);
    map['extra_params_json'] = Variable<String>(extraParamsJson);
    if (!nullToAbsent || memoryModel != null) {
      map['memory_model'] = Variable<String>(memoryModel);
    }
    if (!nullToAbsent || contextWindowLimit != null) {
      map['context_window_limit'] = Variable<int>(contextWindowLimit);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ProviderConfigsCompanion toCompanion(bool nullToAbsent) {
    return ProviderConfigsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      baseUrl: Value(baseUrl),
      model: Value(model),
      apiKeyRef: Value(apiKeyRef),
      extraParamsJson: Value(extraParamsJson),
      memoryModel: memoryModel == null && nullToAbsent
          ? const Value.absent()
          : Value(memoryModel),
      contextWindowLimit: contextWindowLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(contextWindowLimit),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProviderConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderConfig(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      model: serializer.fromJson<String>(json['model']),
      apiKeyRef: serializer.fromJson<String>(json['apiKeyRef']),
      extraParamsJson: serializer.fromJson<String>(json['extraParamsJson']),
      memoryModel: serializer.fromJson<String?>(json['memoryModel']),
      contextWindowLimit: serializer.fromJson<int?>(json['contextWindowLimit']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'model': serializer.toJson<String>(model),
      'apiKeyRef': serializer.toJson<String>(apiKeyRef),
      'extraParamsJson': serializer.toJson<String>(extraParamsJson),
      'memoryModel': serializer.toJson<String?>(memoryModel),
      'contextWindowLimit': serializer.toJson<int?>(contextWindowLimit),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ProviderConfig copyWith({
    String? id,
    String? name,
    String? type,
    String? baseUrl,
    String? model,
    String? apiKeyRef,
    String? extraParamsJson,
    Value<String?> memoryModel = const Value.absent(),
    Value<int?> contextWindowLimit = const Value.absent(),
    bool? isDefault,
    int? createdAt,
    int? updatedAt,
  }) => ProviderConfig(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    baseUrl: baseUrl ?? this.baseUrl,
    model: model ?? this.model,
    apiKeyRef: apiKeyRef ?? this.apiKeyRef,
    extraParamsJson: extraParamsJson ?? this.extraParamsJson,
    memoryModel: memoryModel.present ? memoryModel.value : this.memoryModel,
    contextWindowLimit: contextWindowLimit.present
        ? contextWindowLimit.value
        : this.contextWindowLimit,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProviderConfig copyWithCompanion(ProviderConfigsCompanion data) {
    return ProviderConfig(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      model: data.model.present ? data.model.value : this.model,
      apiKeyRef: data.apiKeyRef.present ? data.apiKeyRef.value : this.apiKeyRef,
      extraParamsJson: data.extraParamsJson.present
          ? data.extraParamsJson.value
          : this.extraParamsJson,
      memoryModel: data.memoryModel.present
          ? data.memoryModel.value
          : this.memoryModel,
      contextWindowLimit: data.contextWindowLimit.present
          ? data.contextWindowLimit.value
          : this.contextWindowLimit,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderConfig(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('model: $model, ')
          ..write('apiKeyRef: $apiKeyRef, ')
          ..write('extraParamsJson: $extraParamsJson, ')
          ..write('memoryModel: $memoryModel, ')
          ..write('contextWindowLimit: $contextWindowLimit, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    baseUrl,
    model,
    apiKeyRef,
    extraParamsJson,
    memoryModel,
    contextWindowLimit,
    isDefault,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderConfig &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.baseUrl == this.baseUrl &&
          other.model == this.model &&
          other.apiKeyRef == this.apiKeyRef &&
          other.extraParamsJson == this.extraParamsJson &&
          other.memoryModel == this.memoryModel &&
          other.contextWindowLimit == this.contextWindowLimit &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProviderConfigsCompanion extends UpdateCompanion<ProviderConfig> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> baseUrl;
  final Value<String> model;
  final Value<String> apiKeyRef;
  final Value<String> extraParamsJson;
  final Value<String?> memoryModel;
  final Value<int?> contextWindowLimit;
  final Value<bool> isDefault;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ProviderConfigsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.model = const Value.absent(),
    this.apiKeyRef = const Value.absent(),
    this.extraParamsJson = const Value.absent(),
    this.memoryModel = const Value.absent(),
    this.contextWindowLimit = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProviderConfigsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String baseUrl,
    required String model,
    this.apiKeyRef = const Value.absent(),
    this.extraParamsJson = const Value.absent(),
    this.memoryModel = const Value.absent(),
    this.contextWindowLimit = const Value.absent(),
    this.isDefault = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       baseUrl = Value(baseUrl),
       model = Value(model),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProviderConfig> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? baseUrl,
    Expression<String>? model,
    Expression<String>? apiKeyRef,
    Expression<String>? extraParamsJson,
    Expression<String>? memoryModel,
    Expression<int>? contextWindowLimit,
    Expression<bool>? isDefault,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (baseUrl != null) 'base_url': baseUrl,
      if (model != null) 'model': model,
      if (apiKeyRef != null) 'api_key_ref': apiKeyRef,
      if (extraParamsJson != null) 'extra_params_json': extraParamsJson,
      if (memoryModel != null) 'memory_model': memoryModel,
      if (contextWindowLimit != null)
        'context_window_limit': contextWindowLimit,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProviderConfigsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? baseUrl,
    Value<String>? model,
    Value<String>? apiKeyRef,
    Value<String>? extraParamsJson,
    Value<String?>? memoryModel,
    Value<int?>? contextWindowLimit,
    Value<bool>? isDefault,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProviderConfigsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      baseUrl: baseUrl ?? this.baseUrl,
      model: model ?? this.model,
      apiKeyRef: apiKeyRef ?? this.apiKeyRef,
      extraParamsJson: extraParamsJson ?? this.extraParamsJson,
      memoryModel: memoryModel ?? this.memoryModel,
      contextWindowLimit: contextWindowLimit ?? this.contextWindowLimit,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (apiKeyRef.present) {
      map['api_key_ref'] = Variable<String>(apiKeyRef.value);
    }
    if (extraParamsJson.present) {
      map['extra_params_json'] = Variable<String>(extraParamsJson.value);
    }
    if (memoryModel.present) {
      map['memory_model'] = Variable<String>(memoryModel.value);
    }
    if (contextWindowLimit.present) {
      map['context_window_limit'] = Variable<int>(contextWindowLimit.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderConfigsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('model: $model, ')
          ..write('apiKeyRef: $apiKeyRef, ')
          ..write('extraParamsJson: $extraParamsJson, ')
          ..write('memoryModel: $memoryModel, ')
          ..write('contextWindowLimit: $contextWindowLimit, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresetsTable extends Presets with TableInfo<$PresetsTable, Preset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topPMeta = const VerificationMeta('topP');
  @override
  late final GeneratedColumn<double> topP = GeneratedColumn<double>(
    'top_p',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxTokensMeta = const VerificationMeta(
    'maxTokens',
  );
  @override
  late final GeneratedColumn<int> maxTokens = GeneratedColumn<int>(
    'max_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presencePenaltyMeta = const VerificationMeta(
    'presencePenalty',
  );
  @override
  late final GeneratedColumn<double> presencePenalty = GeneratedColumn<double>(
    'presence_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyPenaltyMeta = const VerificationMeta(
    'frequencyPenalty',
  );
  @override
  late final GeneratedColumn<double> frequencyPenalty = GeneratedColumn<double>(
    'frequency_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('top_p')) {
      context.handle(
        _topPMeta,
        topP.isAcceptableOrUnknown(data['top_p']!, _topPMeta),
      );
    }
    if (data.containsKey('max_tokens')) {
      context.handle(
        _maxTokensMeta,
        maxTokens.isAcceptableOrUnknown(data['max_tokens']!, _maxTokensMeta),
      );
    }
    if (data.containsKey('presence_penalty')) {
      context.handle(
        _presencePenaltyMeta,
        presencePenalty.isAcceptableOrUnknown(
          data['presence_penalty']!,
          _presencePenaltyMeta,
        ),
      );
    }
    if (data.containsKey('frequency_penalty')) {
      context.handle(
        _frequencyPenaltyMeta,
        frequencyPenalty.isAcceptableOrUnknown(
          data['frequency_penalty']!,
          _frequencyPenaltyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      topP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_p'],
      ),
      maxTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_tokens'],
      ),
      presencePenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}presence_penalty'],
      ),
      frequencyPenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frequency_penalty'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PresetsTable createAlias(String alias) {
    return $PresetsTable(attachedDatabase, alias);
  }
}

class Preset extends DataClass implements Insertable<Preset> {
  final String id;
  final String name;

  /// 指向 [ProviderConfigs].id，可空（空 = 用全局默认 provider）。
  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final int createdAt;
  final int updatedAt;
  const Preset({
    required this.id,
    required this.name,
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || providerId != null) {
      map['provider_id'] = Variable<String>(providerId);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || topP != null) {
      map['top_p'] = Variable<double>(topP);
    }
    if (!nullToAbsent || maxTokens != null) {
      map['max_tokens'] = Variable<int>(maxTokens);
    }
    if (!nullToAbsent || presencePenalty != null) {
      map['presence_penalty'] = Variable<double>(presencePenalty);
    }
    if (!nullToAbsent || frequencyPenalty != null) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PresetsCompanion toCompanion(bool nullToAbsent) {
    return PresetsCompanion(
      id: Value(id),
      name: Value(name),
      providerId: providerId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerId),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      topP: topP == null && nullToAbsent ? const Value.absent() : Value(topP),
      maxTokens: maxTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTokens),
      presencePenalty: presencePenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(presencePenalty),
      frequencyPenalty: frequencyPenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyPenalty),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Preset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      providerId: serializer.fromJson<String?>(json['providerId']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      topP: serializer.fromJson<double?>(json['topP']),
      maxTokens: serializer.fromJson<int?>(json['maxTokens']),
      presencePenalty: serializer.fromJson<double?>(json['presencePenalty']),
      frequencyPenalty: serializer.fromJson<double?>(json['frequencyPenalty']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'providerId': serializer.toJson<String?>(providerId),
      'temperature': serializer.toJson<double?>(temperature),
      'topP': serializer.toJson<double?>(topP),
      'maxTokens': serializer.toJson<int?>(maxTokens),
      'presencePenalty': serializer.toJson<double?>(presencePenalty),
      'frequencyPenalty': serializer.toJson<double?>(frequencyPenalty),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Preset copyWith({
    String? id,
    String? name,
    Value<String?> providerId = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> topP = const Value.absent(),
    Value<int?> maxTokens = const Value.absent(),
    Value<double?> presencePenalty = const Value.absent(),
    Value<double?> frequencyPenalty = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Preset(
    id: id ?? this.id,
    name: name ?? this.name,
    providerId: providerId.present ? providerId.value : this.providerId,
    temperature: temperature.present ? temperature.value : this.temperature,
    topP: topP.present ? topP.value : this.topP,
    maxTokens: maxTokens.present ? maxTokens.value : this.maxTokens,
    presencePenalty: presencePenalty.present
        ? presencePenalty.value
        : this.presencePenalty,
    frequencyPenalty: frequencyPenalty.present
        ? frequencyPenalty.value
        : this.frequencyPenalty,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Preset copyWithCompanion(PresetsCompanion data) {
    return Preset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      topP: data.topP.present ? data.topP.value : this.topP,
      maxTokens: data.maxTokens.present ? data.maxTokens.value : this.maxTokens,
      presencePenalty: data.presencePenalty.present
          ? data.presencePenalty.value
          : this.presencePenalty,
      frequencyPenalty: data.frequencyPenalty.present
          ? data.frequencyPenalty.value
          : this.frequencyPenalty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preset &&
          other.id == this.id &&
          other.name == this.name &&
          other.providerId == this.providerId &&
          other.temperature == this.temperature &&
          other.topP == this.topP &&
          other.maxTokens == this.maxTokens &&
          other.presencePenalty == this.presencePenalty &&
          other.frequencyPenalty == this.frequencyPenalty &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PresetsCompanion extends UpdateCompanion<Preset> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> providerId;
  final Value<double?> temperature;
  final Value<double?> topP;
  final Value<int?> maxTokens;
  final Value<double?> presencePenalty;
  final Value<double?> frequencyPenalty;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresetsCompanion.insert({
    required String id,
    required String name,
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Preset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? providerId,
    Expression<double>? temperature,
    Expression<double>? topP,
    Expression<int>? maxTokens,
    Expression<double>? presencePenalty,
    Expression<double>? frequencyPenalty,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (providerId != null) 'provider_id': providerId,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (presencePenalty != null) 'presence_penalty': presencePenalty,
      if (frequencyPenalty != null) 'frequency_penalty': frequencyPenalty,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? providerId,
    Value<double?>? temperature,
    Value<double?>? topP,
    Value<int?>? maxTokens,
    Value<double?>? presencePenalty,
    Value<double?>? frequencyPenalty,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      providerId: providerId ?? this.providerId,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      maxTokens: maxTokens ?? this.maxTokens,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (topP.present) {
      map['top_p'] = Variable<double>(topP.value);
    }
    if (maxTokens.present) {
      map['max_tokens'] = Variable<int>(maxTokens.value);
    }
    if (presencePenalty.present) {
      map['presence_penalty'] = Variable<double>(presencePenalty.value);
    }
    if (frequencyPenalty.present) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupsTable extends Groups with TableInfo<$GroupsTable, Group> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speakModeMeta = const VerificationMeta(
    'speakMode',
  );
  @override
  late final GeneratedColumn<String> speakMode = GeneratedColumn<String>(
    'speak_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _memoryEnabledMeta = const VerificationMeta(
    'memoryEnabled',
  );
  @override
  late final GeneratedColumn<bool> memoryEnabled = GeneratedColumn<bool>(
    'memory_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("memory_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<String> providerId = GeneratedColumn<String>(
    'provider_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topPMeta = const VerificationMeta('topP');
  @override
  late final GeneratedColumn<double> topP = GeneratedColumn<double>(
    'top_p',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxTokensMeta = const VerificationMeta(
    'maxTokens',
  );
  @override
  late final GeneratedColumn<int> maxTokens = GeneratedColumn<int>(
    'max_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _presencePenaltyMeta = const VerificationMeta(
    'presencePenalty',
  );
  @override
  late final GeneratedColumn<double> presencePenalty = GeneratedColumn<double>(
    'presence_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyPenaltyMeta = const VerificationMeta(
    'frequencyPenalty',
  );
  @override
  late final GeneratedColumn<double> frequencyPenalty = GeneratedColumn<double>(
    'frequency_penalty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<int> lastMessageAt = GeneratedColumn<int>(
    'last_message_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    worldId,
    avatarPath,
    speakMode,
    memoryEnabled,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    createdAt,
    updatedAt,
    lastMessageAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<Group> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('speak_mode')) {
      context.handle(
        _speakModeMeta,
        speakMode.isAcceptableOrUnknown(data['speak_mode']!, _speakModeMeta),
      );
    }
    if (data.containsKey('memory_enabled')) {
      context.handle(
        _memoryEnabledMeta,
        memoryEnabled.isAcceptableOrUnknown(
          data['memory_enabled']!,
          _memoryEnabledMeta,
        ),
      );
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    }
    if (data.containsKey('top_p')) {
      context.handle(
        _topPMeta,
        topP.isAcceptableOrUnknown(data['top_p']!, _topPMeta),
      );
    }
    if (data.containsKey('max_tokens')) {
      context.handle(
        _maxTokensMeta,
        maxTokens.isAcceptableOrUnknown(data['max_tokens']!, _maxTokensMeta),
      );
    }
    if (data.containsKey('presence_penalty')) {
      context.handle(
        _presencePenaltyMeta,
        presencePenalty.isAcceptableOrUnknown(
          data['presence_penalty']!,
          _presencePenaltyMeta,
        ),
      );
    }
    if (data.containsKey('frequency_penalty')) {
      context.handle(
        _frequencyPenaltyMeta,
        frequencyPenalty.isAcceptableOrUnknown(
          data['frequency_penalty']!,
          _frequencyPenaltyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastMessageAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Group map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Group(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      ),
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      speakMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speak_mode'],
      )!,
      memoryEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}memory_enabled'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_id'],
      ),
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      ),
      topP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_p'],
      ),
      maxTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_tokens'],
      ),
      presencePenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}presence_penalty'],
      ),
      frequencyPenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frequency_penalty'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_message_at'],
      )!,
    );
  }

  @override
  $GroupsTable createAlias(String alias) {
    return $GroupsTable(attachedDatabase, alias);
  }
}

class Group extends DataClass implements Insertable<Group> {
  final String id;
  final String name;
  final String? worldId;
  final String? avatarPath;

  /// auto / turn / call。
  final String speakMode;

  /// 是否把每个角色的记忆（关系/状态/摘要/成长）代入群聊 system prompt。
  final bool memoryEnabled;

  /// 群级采样参数 + Provider（null = 用默认）。[providerId] 指向 [ProviderConfigs].id。
  final String? providerId;
  final double? temperature;
  final double? topP;
  final int? maxTokens;
  final double? presencePenalty;
  final double? frequencyPenalty;
  final int createdAt;
  final int updatedAt;
  final int lastMessageAt;
  const Group({
    required this.id,
    required this.name,
    this.worldId,
    this.avatarPath,
    required this.speakMode,
    required this.memoryEnabled,
    this.providerId,
    this.temperature,
    this.topP,
    this.maxTokens,
    this.presencePenalty,
    this.frequencyPenalty,
    required this.createdAt,
    required this.updatedAt,
    required this.lastMessageAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || worldId != null) {
      map['world_id'] = Variable<String>(worldId);
    }
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['speak_mode'] = Variable<String>(speakMode);
    map['memory_enabled'] = Variable<bool>(memoryEnabled);
    if (!nullToAbsent || providerId != null) {
      map['provider_id'] = Variable<String>(providerId);
    }
    if (!nullToAbsent || temperature != null) {
      map['temperature'] = Variable<double>(temperature);
    }
    if (!nullToAbsent || topP != null) {
      map['top_p'] = Variable<double>(topP);
    }
    if (!nullToAbsent || maxTokens != null) {
      map['max_tokens'] = Variable<int>(maxTokens);
    }
    if (!nullToAbsent || presencePenalty != null) {
      map['presence_penalty'] = Variable<double>(presencePenalty);
    }
    if (!nullToAbsent || frequencyPenalty != null) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['last_message_at'] = Variable<int>(lastMessageAt);
    return map;
  }

  GroupsCompanion toCompanion(bool nullToAbsent) {
    return GroupsCompanion(
      id: Value(id),
      name: Value(name),
      worldId: worldId == null && nullToAbsent
          ? const Value.absent()
          : Value(worldId),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      speakMode: Value(speakMode),
      memoryEnabled: Value(memoryEnabled),
      providerId: providerId == null && nullToAbsent
          ? const Value.absent()
          : Value(providerId),
      temperature: temperature == null && nullToAbsent
          ? const Value.absent()
          : Value(temperature),
      topP: topP == null && nullToAbsent ? const Value.absent() : Value(topP),
      maxTokens: maxTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(maxTokens),
      presencePenalty: presencePenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(presencePenalty),
      frequencyPenalty: frequencyPenalty == null && nullToAbsent
          ? const Value.absent()
          : Value(frequencyPenalty),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastMessageAt: Value(lastMessageAt),
    );
  }

  factory Group.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Group(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      worldId: serializer.fromJson<String?>(json['worldId']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      speakMode: serializer.fromJson<String>(json['speakMode']),
      memoryEnabled: serializer.fromJson<bool>(json['memoryEnabled']),
      providerId: serializer.fromJson<String?>(json['providerId']),
      temperature: serializer.fromJson<double?>(json['temperature']),
      topP: serializer.fromJson<double?>(json['topP']),
      maxTokens: serializer.fromJson<int?>(json['maxTokens']),
      presencePenalty: serializer.fromJson<double?>(json['presencePenalty']),
      frequencyPenalty: serializer.fromJson<double?>(json['frequencyPenalty']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      lastMessageAt: serializer.fromJson<int>(json['lastMessageAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'worldId': serializer.toJson<String?>(worldId),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'speakMode': serializer.toJson<String>(speakMode),
      'memoryEnabled': serializer.toJson<bool>(memoryEnabled),
      'providerId': serializer.toJson<String?>(providerId),
      'temperature': serializer.toJson<double?>(temperature),
      'topP': serializer.toJson<double?>(topP),
      'maxTokens': serializer.toJson<int?>(maxTokens),
      'presencePenalty': serializer.toJson<double?>(presencePenalty),
      'frequencyPenalty': serializer.toJson<double?>(frequencyPenalty),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'lastMessageAt': serializer.toJson<int>(lastMessageAt),
    };
  }

  Group copyWith({
    String? id,
    String? name,
    Value<String?> worldId = const Value.absent(),
    Value<String?> avatarPath = const Value.absent(),
    String? speakMode,
    bool? memoryEnabled,
    Value<String?> providerId = const Value.absent(),
    Value<double?> temperature = const Value.absent(),
    Value<double?> topP = const Value.absent(),
    Value<int?> maxTokens = const Value.absent(),
    Value<double?> presencePenalty = const Value.absent(),
    Value<double?> frequencyPenalty = const Value.absent(),
    int? createdAt,
    int? updatedAt,
    int? lastMessageAt,
  }) => Group(
    id: id ?? this.id,
    name: name ?? this.name,
    worldId: worldId.present ? worldId.value : this.worldId,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    speakMode: speakMode ?? this.speakMode,
    memoryEnabled: memoryEnabled ?? this.memoryEnabled,
    providerId: providerId.present ? providerId.value : this.providerId,
    temperature: temperature.present ? temperature.value : this.temperature,
    topP: topP.present ? topP.value : this.topP,
    maxTokens: maxTokens.present ? maxTokens.value : this.maxTokens,
    presencePenalty: presencePenalty.present
        ? presencePenalty.value
        : this.presencePenalty,
    frequencyPenalty: frequencyPenalty.present
        ? frequencyPenalty.value
        : this.frequencyPenalty,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
  );
  Group copyWithCompanion(GroupsCompanion data) {
    return Group(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      speakMode: data.speakMode.present ? data.speakMode.value : this.speakMode,
      memoryEnabled: data.memoryEnabled.present
          ? data.memoryEnabled.value
          : this.memoryEnabled,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      topP: data.topP.present ? data.topP.value : this.topP,
      maxTokens: data.maxTokens.present ? data.maxTokens.value : this.maxTokens,
      presencePenalty: data.presencePenalty.present
          ? data.presencePenalty.value
          : this.presencePenalty,
      frequencyPenalty: data.frequencyPenalty.present
          ? data.frequencyPenalty.value
          : this.frequencyPenalty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Group(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('worldId: $worldId, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('speakMode: $speakMode, ')
          ..write('memoryEnabled: $memoryEnabled, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessageAt: $lastMessageAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    worldId,
    avatarPath,
    speakMode,
    memoryEnabled,
    providerId,
    temperature,
    topP,
    maxTokens,
    presencePenalty,
    frequencyPenalty,
    createdAt,
    updatedAt,
    lastMessageAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Group &&
          other.id == this.id &&
          other.name == this.name &&
          other.worldId == this.worldId &&
          other.avatarPath == this.avatarPath &&
          other.speakMode == this.speakMode &&
          other.memoryEnabled == this.memoryEnabled &&
          other.providerId == this.providerId &&
          other.temperature == this.temperature &&
          other.topP == this.topP &&
          other.maxTokens == this.maxTokens &&
          other.presencePenalty == this.presencePenalty &&
          other.frequencyPenalty == this.frequencyPenalty &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastMessageAt == this.lastMessageAt);
}

class GroupsCompanion extends UpdateCompanion<Group> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> worldId;
  final Value<String?> avatarPath;
  final Value<String> speakMode;
  final Value<bool> memoryEnabled;
  final Value<String?> providerId;
  final Value<double?> temperature;
  final Value<double?> topP;
  final Value<int?> maxTokens;
  final Value<double?> presencePenalty;
  final Value<double?> frequencyPenalty;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> lastMessageAt;
  final Value<int> rowid;
  const GroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.worldId = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.speakMode = const Value.absent(),
    this.memoryEnabled = const Value.absent(),
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupsCompanion.insert({
    required String id,
    required String name,
    this.worldId = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.speakMode = const Value.absent(),
    this.memoryEnabled = const Value.absent(),
    this.providerId = const Value.absent(),
    this.temperature = const Value.absent(),
    this.topP = const Value.absent(),
    this.maxTokens = const Value.absent(),
    this.presencePenalty = const Value.absent(),
    this.frequencyPenalty = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    required int lastMessageAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       lastMessageAt = Value(lastMessageAt);
  static Insertable<Group> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? worldId,
    Expression<String>? avatarPath,
    Expression<String>? speakMode,
    Expression<bool>? memoryEnabled,
    Expression<String>? providerId,
    Expression<double>? temperature,
    Expression<double>? topP,
    Expression<int>? maxTokens,
    Expression<double>? presencePenalty,
    Expression<double>? frequencyPenalty,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? lastMessageAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (worldId != null) 'world_id': worldId,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (speakMode != null) 'speak_mode': speakMode,
      if (memoryEnabled != null) 'memory_enabled': memoryEnabled,
      if (providerId != null) 'provider_id': providerId,
      if (temperature != null) 'temperature': temperature,
      if (topP != null) 'top_p': topP,
      if (maxTokens != null) 'max_tokens': maxTokens,
      if (presencePenalty != null) 'presence_penalty': presencePenalty,
      if (frequencyPenalty != null) 'frequency_penalty': frequencyPenalty,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? worldId,
    Value<String?>? avatarPath,
    Value<String>? speakMode,
    Value<bool>? memoryEnabled,
    Value<String?>? providerId,
    Value<double?>? temperature,
    Value<double?>? topP,
    Value<int?>? maxTokens,
    Value<double?>? presencePenalty,
    Value<double?>? frequencyPenalty,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? lastMessageAt,
    Value<int>? rowid,
  }) {
    return GroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      worldId: worldId ?? this.worldId,
      avatarPath: avatarPath ?? this.avatarPath,
      speakMode: speakMode ?? this.speakMode,
      memoryEnabled: memoryEnabled ?? this.memoryEnabled,
      providerId: providerId ?? this.providerId,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      maxTokens: maxTokens ?? this.maxTokens,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (speakMode.present) {
      map['speak_mode'] = Variable<String>(speakMode.value);
    }
    if (memoryEnabled.present) {
      map['memory_enabled'] = Variable<bool>(memoryEnabled.value);
    }
    if (providerId.present) {
      map['provider_id'] = Variable<String>(providerId.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (topP.present) {
      map['top_p'] = Variable<double>(topP.value);
    }
    if (maxTokens.present) {
      map['max_tokens'] = Variable<int>(maxTokens.value);
    }
    if (presencePenalty.present) {
      map['presence_penalty'] = Variable<double>(presencePenalty.value);
    }
    if (frequencyPenalty.present) {
      map['frequency_penalty'] = Variable<double>(frequencyPenalty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<int>(lastMessageAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('worldId: $worldId, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('speakMode: $speakMode, ')
          ..write('memoryEnabled: $memoryEnabled, ')
          ..write('providerId: $providerId, ')
          ..write('temperature: $temperature, ')
          ..write('topP: $topP, ')
          ..write('maxTokens: $maxTokens, ')
          ..write('presencePenalty: $presencePenalty, ')
          ..write('frequencyPenalty: $frequencyPenalty, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMembersTable extends GroupMembers
    with TableInfo<$GroupMembersTable, GroupMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _joinOrderMeta = const VerificationMeta(
    'joinOrder',
  );
  @override
  late final GeneratedColumn<int> joinOrder = GeneratedColumn<int>(
    'join_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, groupId, characterId, joinOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('join_order')) {
      context.handle(
        _joinOrderMeta,
        joinOrder.isAcceptableOrUnknown(data['join_order']!, _joinOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_joinOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, characterId},
  ];
  @override
  GroupMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      joinOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}join_order'],
      )!,
    );
  }

  @override
  $GroupMembersTable createAlias(String alias) {
    return $GroupMembersTable(attachedDatabase, alias);
  }
}

class GroupMember extends DataClass implements Insertable<GroupMember> {
  final String id;
  final String groupId;
  final String characterId;
  final int joinOrder;
  const GroupMember({
    required this.id,
    required this.groupId,
    required this.characterId,
    required this.joinOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['character_id'] = Variable<String>(characterId);
    map['join_order'] = Variable<int>(joinOrder);
    return map;
  }

  GroupMembersCompanion toCompanion(bool nullToAbsent) {
    return GroupMembersCompanion(
      id: Value(id),
      groupId: Value(groupId),
      characterId: Value(characterId),
      joinOrder: Value(joinOrder),
    );
  }

  factory GroupMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMember(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      characterId: serializer.fromJson<String>(json['characterId']),
      joinOrder: serializer.fromJson<int>(json['joinOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'characterId': serializer.toJson<String>(characterId),
      'joinOrder': serializer.toJson<int>(joinOrder),
    };
  }

  GroupMember copyWith({
    String? id,
    String? groupId,
    String? characterId,
    int? joinOrder,
  }) => GroupMember(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    characterId: characterId ?? this.characterId,
    joinOrder: joinOrder ?? this.joinOrder,
  );
  GroupMember copyWithCompanion(GroupMembersCompanion data) {
    return GroupMember(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      joinOrder: data.joinOrder.present ? data.joinOrder.value : this.joinOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMember(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('characterId: $characterId, ')
          ..write('joinOrder: $joinOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, groupId, characterId, joinOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMember &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.characterId == this.characterId &&
          other.joinOrder == this.joinOrder);
}

class GroupMembersCompanion extends UpdateCompanion<GroupMember> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> characterId;
  final Value<int> joinOrder;
  final Value<int> rowid;
  const GroupMembersCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.characterId = const Value.absent(),
    this.joinOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMembersCompanion.insert({
    required String id,
    required String groupId,
    required String characterId,
    required int joinOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       characterId = Value(characterId),
       joinOrder = Value(joinOrder);
  static Insertable<GroupMember> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? characterId,
    Expression<int>? joinOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (characterId != null) 'character_id': characterId,
      if (joinOrder != null) 'join_order': joinOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? characterId,
    Value<int>? joinOrder,
    Value<int>? rowid,
  }) {
    return GroupMembersCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      characterId: characterId ?? this.characterId,
      joinOrder: joinOrder ?? this.joinOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (joinOrder.present) {
      map['join_order'] = Variable<int>(joinOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMembersCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('characterId: $characterId, ')
          ..write('joinOrder: $joinOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMessagesTable extends GroupMessages
    with TableInfo<$GroupMessagesTable, GroupMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _speakerCharacterIdMeta =
      const VerificationMeta('speakerCharacterId');
  @override
  late final GeneratedColumn<String> speakerCharacterId =
      GeneratedColumn<String>(
        'speaker_character_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _visibleToAiMeta = const VerificationMeta(
    'visibleToAi',
  );
  @override
  late final GeneratedColumn<bool> visibleToAi = GeneratedColumn<bool>(
    'visible_to_ai',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("visible_to_ai" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    speakerCharacterId,
    role,
    content,
    orderIndex,
    timestamp,
    type,
    visibleToAi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('speaker_character_id')) {
      context.handle(
        _speakerCharacterIdMeta,
        speakerCharacterId.isAcceptableOrUnknown(
          data['speaker_character_id']!,
          _speakerCharacterIdMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('visible_to_ai')) {
      context.handle(
        _visibleToAiMeta,
        visibleToAi.isAcceptableOrUnknown(
          data['visible_to_ai']!,
          _visibleToAiMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      speakerCharacterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker_character_id'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      visibleToAi: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}visible_to_ai'],
      )!,
    );
  }

  @override
  $GroupMessagesTable createAlias(String alias) {
    return $GroupMessagesTable(attachedDatabase, alias);
  }
}

class GroupMessage extends DataClass implements Insertable<GroupMessage> {
  final String id;
  final String groupId;
  final String? speakerCharacterId;
  final String role;
  final String content;
  final int orderIndex;
  final int timestamp;

  /// 指令消息类型：null=普通消息，'command'=用户指令，'command_reply'=App 回复。
  final String? type;

  /// 是否进入 AI Prompt。指令消息为 false。
  final bool visibleToAi;
  const GroupMessage({
    required this.id,
    required this.groupId,
    this.speakerCharacterId,
    required this.role,
    required this.content,
    required this.orderIndex,
    required this.timestamp,
    this.type,
    required this.visibleToAi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    if (!nullToAbsent || speakerCharacterId != null) {
      map['speaker_character_id'] = Variable<String>(speakerCharacterId);
    }
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['order_index'] = Variable<int>(orderIndex);
    map['timestamp'] = Variable<int>(timestamp);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['visible_to_ai'] = Variable<bool>(visibleToAi);
    return map;
  }

  GroupMessagesCompanion toCompanion(bool nullToAbsent) {
    return GroupMessagesCompanion(
      id: Value(id),
      groupId: Value(groupId),
      speakerCharacterId: speakerCharacterId == null && nullToAbsent
          ? const Value.absent()
          : Value(speakerCharacterId),
      role: Value(role),
      content: Value(content),
      orderIndex: Value(orderIndex),
      timestamp: Value(timestamp),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      visibleToAi: Value(visibleToAi),
    );
  }

  factory GroupMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMessage(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      speakerCharacterId: serializer.fromJson<String?>(
        json['speakerCharacterId'],
      ),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      type: serializer.fromJson<String?>(json['type']),
      visibleToAi: serializer.fromJson<bool>(json['visibleToAi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'speakerCharacterId': serializer.toJson<String?>(speakerCharacterId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'timestamp': serializer.toJson<int>(timestamp),
      'type': serializer.toJson<String?>(type),
      'visibleToAi': serializer.toJson<bool>(visibleToAi),
    };
  }

  GroupMessage copyWith({
    String? id,
    String? groupId,
    Value<String?> speakerCharacterId = const Value.absent(),
    String? role,
    String? content,
    int? orderIndex,
    int? timestamp,
    Value<String?> type = const Value.absent(),
    bool? visibleToAi,
  }) => GroupMessage(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    speakerCharacterId: speakerCharacterId.present
        ? speakerCharacterId.value
        : this.speakerCharacterId,
    role: role ?? this.role,
    content: content ?? this.content,
    orderIndex: orderIndex ?? this.orderIndex,
    timestamp: timestamp ?? this.timestamp,
    type: type.present ? type.value : this.type,
    visibleToAi: visibleToAi ?? this.visibleToAi,
  );
  GroupMessage copyWithCompanion(GroupMessagesCompanion data) {
    return GroupMessage(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      speakerCharacterId: data.speakerCharacterId.present
          ? data.speakerCharacterId.value
          : this.speakerCharacterId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      type: data.type.present ? data.type.value : this.type,
      visibleToAi: data.visibleToAi.present
          ? data.visibleToAi.value
          : this.visibleToAi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMessage(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('speakerCharacterId: $speakerCharacterId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('visibleToAi: $visibleToAi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupId,
    speakerCharacterId,
    role,
    content,
    orderIndex,
    timestamp,
    type,
    visibleToAi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMessage &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.speakerCharacterId == this.speakerCharacterId &&
          other.role == this.role &&
          other.content == this.content &&
          other.orderIndex == this.orderIndex &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.visibleToAi == this.visibleToAi);
}

class GroupMessagesCompanion extends UpdateCompanion<GroupMessage> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String?> speakerCharacterId;
  final Value<String> role;
  final Value<String> content;
  final Value<int> orderIndex;
  final Value<int> timestamp;
  final Value<String?> type;
  final Value<bool> visibleToAi;
  final Value<int> rowid;
  const GroupMessagesCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.speakerCharacterId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.visibleToAi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMessagesCompanion.insert({
    required String id,
    required String groupId,
    this.speakerCharacterId = const Value.absent(),
    required String role,
    required String content,
    required int orderIndex,
    required int timestamp,
    this.type = const Value.absent(),
    this.visibleToAi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       role = Value(role),
       content = Value(content),
       orderIndex = Value(orderIndex),
       timestamp = Value(timestamp);
  static Insertable<GroupMessage> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? speakerCharacterId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<int>? orderIndex,
    Expression<int>? timestamp,
    Expression<String>? type,
    Expression<bool>? visibleToAi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (speakerCharacterId != null)
        'speaker_character_id': speakerCharacterId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (orderIndex != null) 'order_index': orderIndex,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (visibleToAi != null) 'visible_to_ai': visibleToAi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String?>? speakerCharacterId,
    Value<String>? role,
    Value<String>? content,
    Value<int>? orderIndex,
    Value<int>? timestamp,
    Value<String?>? type,
    Value<bool>? visibleToAi,
    Value<int>? rowid,
  }) {
    return GroupMessagesCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      speakerCharacterId: speakerCharacterId ?? this.speakerCharacterId,
      role: role ?? this.role,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      visibleToAi: visibleToAi ?? this.visibleToAi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (speakerCharacterId.present) {
      map['speaker_character_id'] = Variable<String>(speakerCharacterId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (visibleToAi.present) {
      map['visible_to_ai'] = Variable<bool>(visibleToAi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMessagesCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('speakerCharacterId: $speakerCharacterId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('visibleToAi: $visibleToAi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PairRelationsTable extends PairRelations
    with TableInfo<$PairRelationsTable, PairRelation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PairRelationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _charAMeta = const VerificationMeta('charA');
  @override
  late final GeneratedColumn<String> charA = GeneratedColumn<String>(
    'char_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _charBMeta = const VerificationMeta('charB');
  @override
  late final GeneratedColumn<String> charB = GeneratedColumn<String>(
    'char_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relationJsonMeta = const VerificationMeta(
    'relationJson',
  );
  @override
  late final GeneratedColumn<String> relationJson = GeneratedColumn<String>(
    'relation_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupId,
    charA,
    charB,
    relationJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pair_relations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PairRelation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('char_a')) {
      context.handle(
        _charAMeta,
        charA.isAcceptableOrUnknown(data['char_a']!, _charAMeta),
      );
    } else if (isInserting) {
      context.missing(_charAMeta);
    }
    if (data.containsKey('char_b')) {
      context.handle(
        _charBMeta,
        charB.isAcceptableOrUnknown(data['char_b']!, _charBMeta),
      );
    } else if (isInserting) {
      context.missing(_charBMeta);
    }
    if (data.containsKey('relation_json')) {
      context.handle(
        _relationJsonMeta,
        relationJson.isAcceptableOrUnknown(
          data['relation_json']!,
          _relationJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {groupId, charA, charB},
  ];
  @override
  PairRelation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PairRelation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      charA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char_a'],
      )!,
      charB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}char_b'],
      )!,
      relationJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relation_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PairRelationsTable createAlias(String alias) {
    return $PairRelationsTable(attachedDatabase, alias);
  }
}

class PairRelation extends DataClass implements Insertable<PairRelation> {
  final String id;
  final String groupId;
  final String charA;
  final String charB;
  final String relationJson;
  final int updatedAt;
  const PairRelation({
    required this.id,
    required this.groupId,
    required this.charA,
    required this.charB,
    required this.relationJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    map['char_a'] = Variable<String>(charA);
    map['char_b'] = Variable<String>(charB);
    map['relation_json'] = Variable<String>(relationJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PairRelationsCompanion toCompanion(bool nullToAbsent) {
    return PairRelationsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      charA: Value(charA),
      charB: Value(charB),
      relationJson: Value(relationJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory PairRelation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PairRelation(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      charA: serializer.fromJson<String>(json['charA']),
      charB: serializer.fromJson<String>(json['charB']),
      relationJson: serializer.fromJson<String>(json['relationJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'charA': serializer.toJson<String>(charA),
      'charB': serializer.toJson<String>(charB),
      'relationJson': serializer.toJson<String>(relationJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  PairRelation copyWith({
    String? id,
    String? groupId,
    String? charA,
    String? charB,
    String? relationJson,
    int? updatedAt,
  }) => PairRelation(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    charA: charA ?? this.charA,
    charB: charB ?? this.charB,
    relationJson: relationJson ?? this.relationJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PairRelation copyWithCompanion(PairRelationsCompanion data) {
    return PairRelation(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      charA: data.charA.present ? data.charA.value : this.charA,
      charB: data.charB.present ? data.charB.value : this.charB,
      relationJson: data.relationJson.present
          ? data.relationJson.value
          : this.relationJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PairRelation(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('charA: $charA, ')
          ..write('charB: $charB, ')
          ..write('relationJson: $relationJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, groupId, charA, charB, relationJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PairRelation &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.charA == this.charA &&
          other.charB == this.charB &&
          other.relationJson == this.relationJson &&
          other.updatedAt == this.updatedAt);
}

class PairRelationsCompanion extends UpdateCompanion<PairRelation> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<String> charA;
  final Value<String> charB;
  final Value<String> relationJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PairRelationsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.charA = const Value.absent(),
    this.charB = const Value.absent(),
    this.relationJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PairRelationsCompanion.insert({
    required String id,
    required String groupId,
    required String charA,
    required String charB,
    this.relationJson = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       charA = Value(charA),
       charB = Value(charB),
       updatedAt = Value(updatedAt);
  static Insertable<PairRelation> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<String>? charA,
    Expression<String>? charB,
    Expression<String>? relationJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (charA != null) 'char_a': charA,
      if (charB != null) 'char_b': charB,
      if (relationJson != null) 'relation_json': relationJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PairRelationsCompanion copyWith({
    Value<String>? id,
    Value<String>? groupId,
    Value<String>? charA,
    Value<String>? charB,
    Value<String>? relationJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PairRelationsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      charA: charA ?? this.charA,
      charB: charB ?? this.charB,
      relationJson: relationJson ?? this.relationJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (charA.present) {
      map['char_a'] = Variable<String>(charA.value);
    }
    if (charB.present) {
      map['char_b'] = Variable<String>(charB.value);
    }
    if (relationJson.present) {
      map['relation_json'] = Variable<String>(relationJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PairRelationsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('charA: $charA, ')
          ..write('charB: $charB, ')
          ..write('relationJson: $relationJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupMemoriesTable extends GroupMemories
    with TableInfo<$GroupMemoriesTable, GroupMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stateJsonMeta = const VerificationMeta(
    'stateJson',
  );
  @override
  late final GeneratedColumn<String> stateJson = GeneratedColumn<String>(
    'state_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _summaryTextMeta = const VerificationMeta(
    'summaryText',
  );
  @override
  late final GeneratedColumn<String> summaryText = GeneratedColumn<String>(
    'summary_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _summaryIndexMeta = const VerificationMeta(
    'summaryIndex',
  );
  @override
  late final GeneratedColumn<int> summaryIndex = GeneratedColumn<int>(
    'summary_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    groupId,
    stateJson,
    summaryText,
    summaryIndex,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('state_json')) {
      context.handle(
        _stateJsonMeta,
        stateJson.isAcceptableOrUnknown(data['state_json']!, _stateJsonMeta),
      );
    }
    if (data.containsKey('summary_text')) {
      context.handle(
        _summaryTextMeta,
        summaryText.isAcceptableOrUnknown(
          data['summary_text']!,
          _summaryTextMeta,
        ),
      );
    }
    if (data.containsKey('summary_index')) {
      context.handle(
        _summaryIndexMeta,
        summaryIndex.isAcceptableOrUnknown(
          data['summary_index']!,
          _summaryIndexMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId};
  @override
  GroupMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupMemory(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      stateJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state_json'],
      )!,
      summaryText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_text'],
      )!,
      summaryIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}summary_index'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GroupMemoriesTable createAlias(String alias) {
    return $GroupMemoriesTable(attachedDatabase, alias);
  }
}

class GroupMemory extends DataClass implements Insertable<GroupMemory> {
  final String groupId;
  final String stateJson;
  final String summaryText;
  final int summaryIndex;
  final int updatedAt;
  const GroupMemory({
    required this.groupId,
    required this.stateJson,
    required this.summaryText,
    required this.summaryIndex,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['state_json'] = Variable<String>(stateJson);
    map['summary_text'] = Variable<String>(summaryText);
    map['summary_index'] = Variable<int>(summaryIndex);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  GroupMemoriesCompanion toCompanion(bool nullToAbsent) {
    return GroupMemoriesCompanion(
      groupId: Value(groupId),
      stateJson: Value(stateJson),
      summaryText: Value(summaryText),
      summaryIndex: Value(summaryIndex),
      updatedAt: Value(updatedAt),
    );
  }

  factory GroupMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupMemory(
      groupId: serializer.fromJson<String>(json['groupId']),
      stateJson: serializer.fromJson<String>(json['stateJson']),
      summaryText: serializer.fromJson<String>(json['summaryText']),
      summaryIndex: serializer.fromJson<int>(json['summaryIndex']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'stateJson': serializer.toJson<String>(stateJson),
      'summaryText': serializer.toJson<String>(summaryText),
      'summaryIndex': serializer.toJson<int>(summaryIndex),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  GroupMemory copyWith({
    String? groupId,
    String? stateJson,
    String? summaryText,
    int? summaryIndex,
    int? updatedAt,
  }) => GroupMemory(
    groupId: groupId ?? this.groupId,
    stateJson: stateJson ?? this.stateJson,
    summaryText: summaryText ?? this.summaryText,
    summaryIndex: summaryIndex ?? this.summaryIndex,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GroupMemory copyWithCompanion(GroupMemoriesCompanion data) {
    return GroupMemory(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      stateJson: data.stateJson.present ? data.stateJson.value : this.stateJson,
      summaryText: data.summaryText.present
          ? data.summaryText.value
          : this.summaryText,
      summaryIndex: data.summaryIndex.present
          ? data.summaryIndex.value
          : this.summaryIndex,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupMemory(')
          ..write('groupId: $groupId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('summaryIndex: $summaryIndex, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(groupId, stateJson, summaryText, summaryIndex, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupMemory &&
          other.groupId == this.groupId &&
          other.stateJson == this.stateJson &&
          other.summaryText == this.summaryText &&
          other.summaryIndex == this.summaryIndex &&
          other.updatedAt == this.updatedAt);
}

class GroupMemoriesCompanion extends UpdateCompanion<GroupMemory> {
  final Value<String> groupId;
  final Value<String> stateJson;
  final Value<String> summaryText;
  final Value<int> summaryIndex;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const GroupMemoriesCompanion({
    this.groupId = const Value.absent(),
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.summaryIndex = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupMemoriesCompanion.insert({
    required String groupId,
    this.stateJson = const Value.absent(),
    this.summaryText = const Value.absent(),
    this.summaryIndex = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       updatedAt = Value(updatedAt);
  static Insertable<GroupMemory> custom({
    Expression<String>? groupId,
    Expression<String>? stateJson,
    Expression<String>? summaryText,
    Expression<int>? summaryIndex,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (stateJson != null) 'state_json': stateJson,
      if (summaryText != null) 'summary_text': summaryText,
      if (summaryIndex != null) 'summary_index': summaryIndex,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupMemoriesCompanion copyWith({
    Value<String>? groupId,
    Value<String>? stateJson,
    Value<String>? summaryText,
    Value<int>? summaryIndex,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return GroupMemoriesCompanion(
      groupId: groupId ?? this.groupId,
      stateJson: stateJson ?? this.stateJson,
      summaryText: summaryText ?? this.summaryText,
      summaryIndex: summaryIndex ?? this.summaryIndex,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (stateJson.present) {
      map['state_json'] = Variable<String>(stateJson.value);
    }
    if (summaryText.present) {
      map['summary_text'] = Variable<String>(summaryText.value);
    }
    if (summaryIndex.present) {
      map['summary_index'] = Variable<int>(summaryIndex.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupMemoriesCompanion(')
          ..write('groupId: $groupId, ')
          ..write('stateJson: $stateJson, ')
          ..write('summaryText: $summaryText, ')
          ..write('summaryIndex: $summaryIndex, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoriesTable extends Stories with TableInfo<$StoriesTable, Story> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentNodeIdMeta = const VerificationMeta(
    'currentNodeId',
  );
  @override
  late final GeneratedColumn<String> currentNodeId = GeneratedColumn<String>(
    'current_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    characterId,
    worldId,
    coverPath,
    currentNodeId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Story> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('current_node_id')) {
      context.handle(
        _currentNodeIdMeta,
        currentNodeId.isAcceptableOrUnknown(
          data['current_node_id']!,
          _currentNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Story map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Story(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      ),
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      currentNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_node_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StoriesTable createAlias(String alias) {
    return $StoriesTable(attachedDatabase, alias);
  }
}

class Story extends DataClass implements Insertable<Story> {
  final String id;
  final String name;
  final String description;
  final String? characterId;
  final String? worldId;
  final String? coverPath;

  /// 当前节点（自动存档位置）。
  final String? currentNodeId;
  final int createdAt;
  final int updatedAt;
  const Story({
    required this.id,
    required this.name,
    required this.description,
    this.characterId,
    this.worldId,
    this.coverPath,
    this.currentNodeId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || characterId != null) {
      map['character_id'] = Variable<String>(characterId);
    }
    if (!nullToAbsent || worldId != null) {
      map['world_id'] = Variable<String>(worldId);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || currentNodeId != null) {
      map['current_node_id'] = Variable<String>(currentNodeId);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  StoriesCompanion toCompanion(bool nullToAbsent) {
    return StoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      characterId: characterId == null && nullToAbsent
          ? const Value.absent()
          : Value(characterId),
      worldId: worldId == null && nullToAbsent
          ? const Value.absent()
          : Value(worldId),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      currentNodeId: currentNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentNodeId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Story.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Story(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      characterId: serializer.fromJson<String?>(json['characterId']),
      worldId: serializer.fromJson<String?>(json['worldId']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      currentNodeId: serializer.fromJson<String?>(json['currentNodeId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'characterId': serializer.toJson<String?>(characterId),
      'worldId': serializer.toJson<String?>(worldId),
      'coverPath': serializer.toJson<String?>(coverPath),
      'currentNodeId': serializer.toJson<String?>(currentNodeId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Story copyWith({
    String? id,
    String? name,
    String? description,
    Value<String?> characterId = const Value.absent(),
    Value<String?> worldId = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    Value<String?> currentNodeId = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Story(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    characterId: characterId.present ? characterId.value : this.characterId,
    worldId: worldId.present ? worldId.value : this.worldId,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    currentNodeId: currentNodeId.present
        ? currentNodeId.value
        : this.currentNodeId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Story copyWithCompanion(StoriesCompanion data) {
    return Story(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      currentNodeId: data.currentNodeId.present
          ? data.currentNodeId.value
          : this.currentNodeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Story(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('coverPath: $coverPath, ')
          ..write('currentNodeId: $currentNodeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    characterId,
    worldId,
    coverPath,
    currentNodeId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Story &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.characterId == this.characterId &&
          other.worldId == this.worldId &&
          other.coverPath == this.coverPath &&
          other.currentNodeId == this.currentNodeId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StoriesCompanion extends UpdateCompanion<Story> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> characterId;
  final Value<String?> worldId;
  final Value<String?> coverPath;
  final Value<String?> currentNodeId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const StoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.currentNodeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.characterId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.currentNodeId = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Story> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? characterId,
    Expression<String>? worldId,
    Expression<String>? coverPath,
    Expression<String>? currentNodeId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (characterId != null) 'character_id': characterId,
      if (worldId != null) 'world_id': worldId,
      if (coverPath != null) 'cover_path': coverPath,
      if (currentNodeId != null) 'current_node_id': currentNodeId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? characterId,
    Value<String?>? worldId,
    Value<String?>? coverPath,
    Value<String?>? currentNodeId,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      characterId: characterId ?? this.characterId,
      worldId: worldId ?? this.worldId,
      coverPath: coverPath ?? this.coverPath,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (currentNodeId.present) {
      map['current_node_id'] = Variable<String>(currentNodeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('characterId: $characterId, ')
          ..write('worldId: $worldId, ')
          ..write('coverPath: $coverPath, ')
          ..write('currentNodeId: $currentNodeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryNodesTable extends StoryNodes
    with TableInfo<$StoryNodesTable, StoryNode> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryNodesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _narrativeMeta = const VerificationMeta(
    'narrative',
  );
  @override
  late final GeneratedColumn<String> narrative = GeneratedColumn<String>(
    'narrative',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _choicesJsonMeta = const VerificationMeta(
    'choicesJson',
  );
  @override
  late final GeneratedColumn<String> choicesJson = GeneratedColumn<String>(
    'choices_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _chosenIndexMeta = const VerificationMeta(
    'chosenIndex',
  );
  @override
  late final GeneratedColumn<int> chosenIndex = GeneratedColumn<int>(
    'chosen_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _depthMeta = const VerificationMeta('depth');
  @override
  late final GeneratedColumn<int> depth = GeneratedColumn<int>(
    'depth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storyId,
    parentId,
    narrative,
    choicesJson,
    chosenIndex,
    depth,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_nodes';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryNode> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('narrative')) {
      context.handle(
        _narrativeMeta,
        narrative.isAcceptableOrUnknown(data['narrative']!, _narrativeMeta),
      );
    } else if (isInserting) {
      context.missing(_narrativeMeta);
    }
    if (data.containsKey('choices_json')) {
      context.handle(
        _choicesJsonMeta,
        choicesJson.isAcceptableOrUnknown(
          data['choices_json']!,
          _choicesJsonMeta,
        ),
      );
    }
    if (data.containsKey('chosen_index')) {
      context.handle(
        _chosenIndexMeta,
        chosenIndex.isAcceptableOrUnknown(
          data['chosen_index']!,
          _chosenIndexMeta,
        ),
      );
    }
    if (data.containsKey('depth')) {
      context.handle(
        _depthMeta,
        depth.isAcceptableOrUnknown(data['depth']!, _depthMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoryNode map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryNode(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      narrative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}narrative'],
      )!,
      choicesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}choices_json'],
      )!,
      chosenIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chosen_index'],
      ),
      depth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}depth'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoryNodesTable createAlias(String alias) {
    return $StoryNodesTable(attachedDatabase, alias);
  }
}

class StoryNode extends DataClass implements Insertable<StoryNode> {
  final String id;
  final String storyId;
  final String? parentId;
  final String narrative;
  final String choicesJson;

  /// 父节点选了哪个选项到达本节点（根节点为 null）。
  final int? chosenIndex;
  final int depth;
  final int createdAt;
  const StoryNode({
    required this.id,
    required this.storyId,
    this.parentId,
    required this.narrative,
    required this.choicesJson,
    this.chosenIndex,
    required this.depth,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['narrative'] = Variable<String>(narrative);
    map['choices_json'] = Variable<String>(choicesJson);
    if (!nullToAbsent || chosenIndex != null) {
      map['chosen_index'] = Variable<int>(chosenIndex);
    }
    map['depth'] = Variable<int>(depth);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  StoryNodesCompanion toCompanion(bool nullToAbsent) {
    return StoryNodesCompanion(
      id: Value(id),
      storyId: Value(storyId),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      narrative: Value(narrative),
      choicesJson: Value(choicesJson),
      chosenIndex: chosenIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(chosenIndex),
      depth: Value(depth),
      createdAt: Value(createdAt),
    );
  }

  factory StoryNode.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryNode(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      narrative: serializer.fromJson<String>(json['narrative']),
      choicesJson: serializer.fromJson<String>(json['choicesJson']),
      chosenIndex: serializer.fromJson<int?>(json['chosenIndex']),
      depth: serializer.fromJson<int>(json['depth']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'parentId': serializer.toJson<String?>(parentId),
      'narrative': serializer.toJson<String>(narrative),
      'choicesJson': serializer.toJson<String>(choicesJson),
      'chosenIndex': serializer.toJson<int?>(chosenIndex),
      'depth': serializer.toJson<int>(depth),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  StoryNode copyWith({
    String? id,
    String? storyId,
    Value<String?> parentId = const Value.absent(),
    String? narrative,
    String? choicesJson,
    Value<int?> chosenIndex = const Value.absent(),
    int? depth,
    int? createdAt,
  }) => StoryNode(
    id: id ?? this.id,
    storyId: storyId ?? this.storyId,
    parentId: parentId.present ? parentId.value : this.parentId,
    narrative: narrative ?? this.narrative,
    choicesJson: choicesJson ?? this.choicesJson,
    chosenIndex: chosenIndex.present ? chosenIndex.value : this.chosenIndex,
    depth: depth ?? this.depth,
    createdAt: createdAt ?? this.createdAt,
  );
  StoryNode copyWithCompanion(StoryNodesCompanion data) {
    return StoryNode(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      narrative: data.narrative.present ? data.narrative.value : this.narrative,
      choicesJson: data.choicesJson.present
          ? data.choicesJson.value
          : this.choicesJson,
      chosenIndex: data.chosenIndex.present
          ? data.chosenIndex.value
          : this.chosenIndex,
      depth: data.depth.present ? data.depth.value : this.depth,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryNode(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('parentId: $parentId, ')
          ..write('narrative: $narrative, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('chosenIndex: $chosenIndex, ')
          ..write('depth: $depth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storyId,
    parentId,
    narrative,
    choicesJson,
    chosenIndex,
    depth,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryNode &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.parentId == this.parentId &&
          other.narrative == this.narrative &&
          other.choicesJson == this.choicesJson &&
          other.chosenIndex == this.chosenIndex &&
          other.depth == this.depth &&
          other.createdAt == this.createdAt);
}

class StoryNodesCompanion extends UpdateCompanion<StoryNode> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String?> parentId;
  final Value<String> narrative;
  final Value<String> choicesJson;
  final Value<int?> chosenIndex;
  final Value<int> depth;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StoryNodesCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.parentId = const Value.absent(),
    this.narrative = const Value.absent(),
    this.choicesJson = const Value.absent(),
    this.chosenIndex = const Value.absent(),
    this.depth = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryNodesCompanion.insert({
    required String id,
    required String storyId,
    this.parentId = const Value.absent(),
    required String narrative,
    this.choicesJson = const Value.absent(),
    this.chosenIndex = const Value.absent(),
    this.depth = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storyId = Value(storyId),
       narrative = Value(narrative),
       createdAt = Value(createdAt);
  static Insertable<StoryNode> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? parentId,
    Expression<String>? narrative,
    Expression<String>? choicesJson,
    Expression<int>? chosenIndex,
    Expression<int>? depth,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (parentId != null) 'parent_id': parentId,
      if (narrative != null) 'narrative': narrative,
      if (choicesJson != null) 'choices_json': choicesJson,
      if (chosenIndex != null) 'chosen_index': chosenIndex,
      if (depth != null) 'depth': depth,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryNodesCompanion copyWith({
    Value<String>? id,
    Value<String>? storyId,
    Value<String?>? parentId,
    Value<String>? narrative,
    Value<String>? choicesJson,
    Value<int?>? chosenIndex,
    Value<int>? depth,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StoryNodesCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      parentId: parentId ?? this.parentId,
      narrative: narrative ?? this.narrative,
      choicesJson: choicesJson ?? this.choicesJson,
      chosenIndex: chosenIndex ?? this.chosenIndex,
      depth: depth ?? this.depth,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (narrative.present) {
      map['narrative'] = Variable<String>(narrative.value);
    }
    if (choicesJson.present) {
      map['choices_json'] = Variable<String>(choicesJson.value);
    }
    if (chosenIndex.present) {
      map['chosen_index'] = Variable<int>(chosenIndex.value);
    }
    if (depth.present) {
      map['depth'] = Variable<int>(depth.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryNodesCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('parentId: $parentId, ')
          ..write('narrative: $narrative, ')
          ..write('choicesJson: $choicesJson, ')
          ..write('chosenIndex: $chosenIndex, ')
          ..write('depth: $depth, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorySavesTable extends StorySaves
    with TableInfo<$StorySavesTable, StorySave> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorySavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentNodeIdMeta = const VerificationMeta(
    'currentNodeId',
  );
  @override
  late final GeneratedColumn<String> currentNodeId = GeneratedColumn<String>(
    'current_node_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isQuickMeta = const VerificationMeta(
    'isQuick',
  );
  @override
  late final GeneratedColumn<bool> isQuick = GeneratedColumn<bool>(
    'is_quick',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quick" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<int> savedAt = GeneratedColumn<int>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storyId,
    label,
    currentNodeId,
    isQuick,
    savedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_saves';
  @override
  VerificationContext validateIntegrity(
    Insertable<StorySave> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('current_node_id')) {
      context.handle(
        _currentNodeIdMeta,
        currentNodeId.isAcceptableOrUnknown(
          data['current_node_id']!,
          _currentNodeIdMeta,
        ),
      );
    }
    if (data.containsKey('is_quick')) {
      context.handle(
        _isQuickMeta,
        isQuick.isAcceptableOrUnknown(data['is_quick']!, _isQuickMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StorySave map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorySave(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      currentNodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_node_id'],
      ),
      isQuick: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quick'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $StorySavesTable createAlias(String alias) {
    return $StorySavesTable(attachedDatabase, alias);
  }
}

class StorySave extends DataClass implements Insertable<StorySave> {
  final String id;
  final String storyId;
  final String label;
  final String? currentNodeId;
  final bool isQuick;
  final int savedAt;
  const StorySave({
    required this.id,
    required this.storyId,
    required this.label,
    this.currentNodeId,
    required this.isQuick,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['story_id'] = Variable<String>(storyId);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || currentNodeId != null) {
      map['current_node_id'] = Variable<String>(currentNodeId);
    }
    map['is_quick'] = Variable<bool>(isQuick);
    map['saved_at'] = Variable<int>(savedAt);
    return map;
  }

  StorySavesCompanion toCompanion(bool nullToAbsent) {
    return StorySavesCompanion(
      id: Value(id),
      storyId: Value(storyId),
      label: Value(label),
      currentNodeId: currentNodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentNodeId),
      isQuick: Value(isQuick),
      savedAt: Value(savedAt),
    );
  }

  factory StorySave.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorySave(
      id: serializer.fromJson<String>(json['id']),
      storyId: serializer.fromJson<String>(json['storyId']),
      label: serializer.fromJson<String>(json['label']),
      currentNodeId: serializer.fromJson<String?>(json['currentNodeId']),
      isQuick: serializer.fromJson<bool>(json['isQuick']),
      savedAt: serializer.fromJson<int>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storyId': serializer.toJson<String>(storyId),
      'label': serializer.toJson<String>(label),
      'currentNodeId': serializer.toJson<String?>(currentNodeId),
      'isQuick': serializer.toJson<bool>(isQuick),
      'savedAt': serializer.toJson<int>(savedAt),
    };
  }

  StorySave copyWith({
    String? id,
    String? storyId,
    String? label,
    Value<String?> currentNodeId = const Value.absent(),
    bool? isQuick,
    int? savedAt,
  }) => StorySave(
    id: id ?? this.id,
    storyId: storyId ?? this.storyId,
    label: label ?? this.label,
    currentNodeId: currentNodeId.present
        ? currentNodeId.value
        : this.currentNodeId,
    isQuick: isQuick ?? this.isQuick,
    savedAt: savedAt ?? this.savedAt,
  );
  StorySave copyWithCompanion(StorySavesCompanion data) {
    return StorySave(
      id: data.id.present ? data.id.value : this.id,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      label: data.label.present ? data.label.value : this.label,
      currentNodeId: data.currentNodeId.present
          ? data.currentNodeId.value
          : this.currentNodeId,
      isQuick: data.isQuick.present ? data.isQuick.value : this.isQuick,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorySave(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('label: $label, ')
          ..write('currentNodeId: $currentNodeId, ')
          ..write('isQuick: $isQuick, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storyId, label, currentNodeId, isQuick, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorySave &&
          other.id == this.id &&
          other.storyId == this.storyId &&
          other.label == this.label &&
          other.currentNodeId == this.currentNodeId &&
          other.isQuick == this.isQuick &&
          other.savedAt == this.savedAt);
}

class StorySavesCompanion extends UpdateCompanion<StorySave> {
  final Value<String> id;
  final Value<String> storyId;
  final Value<String> label;
  final Value<String?> currentNodeId;
  final Value<bool> isQuick;
  final Value<int> savedAt;
  final Value<int> rowid;
  const StorySavesCompanion({
    this.id = const Value.absent(),
    this.storyId = const Value.absent(),
    this.label = const Value.absent(),
    this.currentNodeId = const Value.absent(),
    this.isQuick = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorySavesCompanion.insert({
    required String id,
    required String storyId,
    required String label,
    this.currentNodeId = const Value.absent(),
    this.isQuick = const Value.absent(),
    required int savedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storyId = Value(storyId),
       label = Value(label),
       savedAt = Value(savedAt);
  static Insertable<StorySave> custom({
    Expression<String>? id,
    Expression<String>? storyId,
    Expression<String>? label,
    Expression<String>? currentNodeId,
    Expression<bool>? isQuick,
    Expression<int>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storyId != null) 'story_id': storyId,
      if (label != null) 'label': label,
      if (currentNodeId != null) 'current_node_id': currentNodeId,
      if (isQuick != null) 'is_quick': isQuick,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorySavesCompanion copyWith({
    Value<String>? id,
    Value<String>? storyId,
    Value<String>? label,
    Value<String?>? currentNodeId,
    Value<bool>? isQuick,
    Value<int>? savedAt,
    Value<int>? rowid,
  }) {
    return StorySavesCompanion(
      id: id ?? this.id,
      storyId: storyId ?? this.storyId,
      label: label ?? this.label,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      isQuick: isQuick ?? this.isQuick,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (currentNodeId.present) {
      map['current_node_id'] = Variable<String>(currentNodeId.value);
    }
    if (isQuick.present) {
      map['is_quick'] = Variable<bool>(isQuick.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<int>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorySavesCompanion(')
          ..write('id: $id, ')
          ..write('storyId: $storyId, ')
          ..write('label: $label, ')
          ..write('currentNodeId: $currentNodeId, ')
          ..write('isQuick: $isQuick, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldbooksTable extends Worldbooks
    with TableInfo<$WorldbooksTable, Worldbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bookJsonMeta = const VerificationMeta(
    'bookJson',
  );
  @override
  late final GeneratedColumn<String> bookJson = GeneratedColumn<String>(
    'book_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{"entries":[]}'),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _sourcePathMeta = const VerificationMeta(
    'sourcePath',
  );
  @override
  late final GeneratedColumn<String> sourcePath = GeneratedColumn<String>(
    'source_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    bookJson,
    sourceType,
    sourcePath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worldbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Worldbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('book_json')) {
      context.handle(
        _bookJsonMeta,
        bookJson.isAcceptableOrUnknown(data['book_json']!, _bookJsonMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('source_path')) {
      context.handle(
        _sourcePathMeta,
        sourcePath.isAcceptableOrUnknown(data['source_path']!, _sourcePathMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Worldbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Worldbook(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      bookJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_json'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourcePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_path'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorldbooksTable createAlias(String alias) {
    return $WorldbooksTable(attachedDatabase, alias);
  }
}

class Worldbook extends DataClass implements Insertable<Worldbook> {
  final String id;
  final String name;
  final String description;

  /// normalized 世界书 JSON（entries 触发关键词，sources 仅展示）。
  final String bookJson;

  /// sillytavern / skill / manual。
  final String sourceType;
  final String? sourcePath;
  final int createdAt;
  final int updatedAt;
  const Worldbook({
    required this.id,
    required this.name,
    required this.description,
    required this.bookJson,
    required this.sourceType,
    this.sourcePath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['book_json'] = Variable<String>(bookJson);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourcePath != null) {
      map['source_path'] = Variable<String>(sourcePath);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  WorldbooksCompanion toCompanion(bool nullToAbsent) {
    return WorldbooksCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      bookJson: Value(bookJson),
      sourceType: Value(sourceType),
      sourcePath: sourcePath == null && nullToAbsent
          ? const Value.absent()
          : Value(sourcePath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Worldbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Worldbook(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      bookJson: serializer.fromJson<String>(json['bookJson']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourcePath: serializer.fromJson<String?>(json['sourcePath']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'bookJson': serializer.toJson<String>(bookJson),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourcePath': serializer.toJson<String?>(sourcePath),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Worldbook copyWith({
    String? id,
    String? name,
    String? description,
    String? bookJson,
    String? sourceType,
    Value<String?> sourcePath = const Value.absent(),
    int? createdAt,
    int? updatedAt,
  }) => Worldbook(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    bookJson: bookJson ?? this.bookJson,
    sourceType: sourceType ?? this.sourceType,
    sourcePath: sourcePath.present ? sourcePath.value : this.sourcePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Worldbook copyWithCompanion(WorldbooksCompanion data) {
    return Worldbook(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      bookJson: data.bookJson.present ? data.bookJson.value : this.bookJson,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourcePath: data.sourcePath.present
          ? data.sourcePath.value
          : this.sourcePath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Worldbook(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bookJson: $bookJson, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    bookJson,
    sourceType,
    sourcePath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Worldbook &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.bookJson == this.bookJson &&
          other.sourceType == this.sourceType &&
          other.sourcePath == this.sourcePath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorldbooksCompanion extends UpdateCompanion<Worldbook> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> bookJson;
  final Value<String> sourceType;
  final Value<String?> sourcePath;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const WorldbooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.bookJson = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourcePath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldbooksCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.bookJson = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourcePath = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Worldbook> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? bookJson,
    Expression<String>? sourceType,
    Expression<String>? sourcePath,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (bookJson != null) 'book_json': bookJson,
      if (sourceType != null) 'source_type': sourceType,
      if (sourcePath != null) 'source_path': sourcePath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldbooksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? bookJson,
    Value<String>? sourceType,
    Value<String?>? sourcePath,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorldbooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      bookJson: bookJson ?? this.bookJson,
      sourceType: sourceType ?? this.sourceType,
      sourcePath: sourcePath ?? this.sourcePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (bookJson.present) {
      map['book_json'] = Variable<String>(bookJson.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourcePath.present) {
      map['source_path'] = Variable<String>(sourcePath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldbooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('bookJson: $bookJson, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourcePath: $sourcePath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CharacterWorldbooksTable extends CharacterWorldbooks
    with TableInfo<$CharacterWorldbooksTable, CharacterWorldbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharacterWorldbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _characterIdMeta = const VerificationMeta(
    'characterId',
  );
  @override
  late final GeneratedColumn<String> characterId = GeneratedColumn<String>(
    'character_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES characters (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldbookIdMeta = const VerificationMeta(
    'worldbookId',
  );
  @override
  late final GeneratedColumn<String> worldbookId = GeneratedColumn<String>(
    'worldbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worldbooks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [characterId, worldbookId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'character_worldbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterWorldbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('character_id')) {
      context.handle(
        _characterIdMeta,
        characterId.isAcceptableOrUnknown(
          data['character_id']!,
          _characterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_characterIdMeta);
    }
    if (data.containsKey('worldbook_id')) {
      context.handle(
        _worldbookIdMeta,
        worldbookId.isAcceptableOrUnknown(
          data['worldbook_id']!,
          _worldbookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldbookIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {characterId, worldbookId};
  @override
  CharacterWorldbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterWorldbook(
      characterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}character_id'],
      )!,
      worldbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CharacterWorldbooksTable createAlias(String alias) {
    return $CharacterWorldbooksTable(attachedDatabase, alias);
  }
}

class CharacterWorldbook extends DataClass
    implements Insertable<CharacterWorldbook> {
  final String characterId;
  final String worldbookId;
  final int createdAt;
  const CharacterWorldbook({
    required this.characterId,
    required this.worldbookId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['character_id'] = Variable<String>(characterId);
    map['worldbook_id'] = Variable<String>(worldbookId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CharacterWorldbooksCompanion toCompanion(bool nullToAbsent) {
    return CharacterWorldbooksCompanion(
      characterId: Value(characterId),
      worldbookId: Value(worldbookId),
      createdAt: Value(createdAt),
    );
  }

  factory CharacterWorldbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterWorldbook(
      characterId: serializer.fromJson<String>(json['characterId']),
      worldbookId: serializer.fromJson<String>(json['worldbookId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'characterId': serializer.toJson<String>(characterId),
      'worldbookId': serializer.toJson<String>(worldbookId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CharacterWorldbook copyWith({
    String? characterId,
    String? worldbookId,
    int? createdAt,
  }) => CharacterWorldbook(
    characterId: characterId ?? this.characterId,
    worldbookId: worldbookId ?? this.worldbookId,
    createdAt: createdAt ?? this.createdAt,
  );
  CharacterWorldbook copyWithCompanion(CharacterWorldbooksCompanion data) {
    return CharacterWorldbook(
      characterId: data.characterId.present
          ? data.characterId.value
          : this.characterId,
      worldbookId: data.worldbookId.present
          ? data.worldbookId.value
          : this.worldbookId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterWorldbook(')
          ..write('characterId: $characterId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(characterId, worldbookId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterWorldbook &&
          other.characterId == this.characterId &&
          other.worldbookId == this.worldbookId &&
          other.createdAt == this.createdAt);
}

class CharacterWorldbooksCompanion extends UpdateCompanion<CharacterWorldbook> {
  final Value<String> characterId;
  final Value<String> worldbookId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const CharacterWorldbooksCompanion({
    this.characterId = const Value.absent(),
    this.worldbookId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharacterWorldbooksCompanion.insert({
    required String characterId,
    required String worldbookId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : characterId = Value(characterId),
       worldbookId = Value(worldbookId),
       createdAt = Value(createdAt);
  static Insertable<CharacterWorldbook> custom({
    Expression<String>? characterId,
    Expression<String>? worldbookId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (characterId != null) 'character_id': characterId,
      if (worldbookId != null) 'worldbook_id': worldbookId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharacterWorldbooksCompanion copyWith({
    Value<String>? characterId,
    Value<String>? worldbookId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return CharacterWorldbooksCompanion(
      characterId: characterId ?? this.characterId,
      worldbookId: worldbookId ?? this.worldbookId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (characterId.present) {
      map['character_id'] = Variable<String>(characterId.value);
    }
    if (worldbookId.present) {
      map['worldbook_id'] = Variable<String>(worldbookId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharacterWorldbooksCompanion(')
          ..write('characterId: $characterId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldWorldbooksTable extends WorldWorldbooks
    with TableInfo<$WorldWorldbooksTable, WorldWorldbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldWorldbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldbookIdMeta = const VerificationMeta(
    'worldbookId',
  );
  @override
  late final GeneratedColumn<String> worldbookId = GeneratedColumn<String>(
    'worldbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worldbooks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [worldId, worldbookId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_worldbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorldWorldbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('worldbook_id')) {
      context.handle(
        _worldbookIdMeta,
        worldbookId.isAcceptableOrUnknown(
          data['worldbook_id']!,
          _worldbookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldbookIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {worldId, worldbookId};
  @override
  WorldWorldbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldWorldbook(
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      worldbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorldWorldbooksTable createAlias(String alias) {
    return $WorldWorldbooksTable(attachedDatabase, alias);
  }
}

class WorldWorldbook extends DataClass implements Insertable<WorldWorldbook> {
  final String worldId;
  final String worldbookId;
  final int createdAt;
  const WorldWorldbook({
    required this.worldId,
    required this.worldbookId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['world_id'] = Variable<String>(worldId);
    map['worldbook_id'] = Variable<String>(worldbookId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WorldWorldbooksCompanion toCompanion(bool nullToAbsent) {
    return WorldWorldbooksCompanion(
      worldId: Value(worldId),
      worldbookId: Value(worldbookId),
      createdAt: Value(createdAt),
    );
  }

  factory WorldWorldbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldWorldbook(
      worldId: serializer.fromJson<String>(json['worldId']),
      worldbookId: serializer.fromJson<String>(json['worldbookId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'worldId': serializer.toJson<String>(worldId),
      'worldbookId': serializer.toJson<String>(worldbookId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WorldWorldbook copyWith({
    String? worldId,
    String? worldbookId,
    int? createdAt,
  }) => WorldWorldbook(
    worldId: worldId ?? this.worldId,
    worldbookId: worldbookId ?? this.worldbookId,
    createdAt: createdAt ?? this.createdAt,
  );
  WorldWorldbook copyWithCompanion(WorldWorldbooksCompanion data) {
    return WorldWorldbook(
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      worldbookId: data.worldbookId.present
          ? data.worldbookId.value
          : this.worldbookId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldWorldbook(')
          ..write('worldId: $worldId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(worldId, worldbookId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldWorldbook &&
          other.worldId == this.worldId &&
          other.worldbookId == this.worldbookId &&
          other.createdAt == this.createdAt);
}

class WorldWorldbooksCompanion extends UpdateCompanion<WorldWorldbook> {
  final Value<String> worldId;
  final Value<String> worldbookId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const WorldWorldbooksCompanion({
    this.worldId = const Value.absent(),
    this.worldbookId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldWorldbooksCompanion.insert({
    required String worldId,
    required String worldbookId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : worldId = Value(worldId),
       worldbookId = Value(worldbookId),
       createdAt = Value(createdAt);
  static Insertable<WorldWorldbook> custom({
    Expression<String>? worldId,
    Expression<String>? worldbookId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (worldId != null) 'world_id': worldId,
      if (worldbookId != null) 'worldbook_id': worldbookId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldWorldbooksCompanion copyWith({
    Value<String>? worldId,
    Value<String>? worldbookId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return WorldWorldbooksCompanion(
      worldId: worldId ?? this.worldId,
      worldbookId: worldbookId ?? this.worldbookId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (worldbookId.present) {
      map['worldbook_id'] = Variable<String>(worldbookId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldWorldbooksCompanion(')
          ..write('worldId: $worldId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupWorldbooksTable extends GroupWorldbooks
    with TableInfo<$GroupWorldbooksTable, GroupWorldbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupWorldbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldbookIdMeta = const VerificationMeta(
    'worldbookId',
  );
  @override
  late final GeneratedColumn<String> worldbookId = GeneratedColumn<String>(
    'worldbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worldbooks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, worldbookId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_worldbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupWorldbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('worldbook_id')) {
      context.handle(
        _worldbookIdMeta,
        worldbookId.isAcceptableOrUnknown(
          data['worldbook_id']!,
          _worldbookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldbookIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, worldbookId};
  @override
  GroupWorldbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupWorldbook(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      worldbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GroupWorldbooksTable createAlias(String alias) {
    return $GroupWorldbooksTable(attachedDatabase, alias);
  }
}

class GroupWorldbook extends DataClass implements Insertable<GroupWorldbook> {
  final String groupId;
  final String worldbookId;
  final int createdAt;
  const GroupWorldbook({
    required this.groupId,
    required this.worldbookId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['worldbook_id'] = Variable<String>(worldbookId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  GroupWorldbooksCompanion toCompanion(bool nullToAbsent) {
    return GroupWorldbooksCompanion(
      groupId: Value(groupId),
      worldbookId: Value(worldbookId),
      createdAt: Value(createdAt),
    );
  }

  factory GroupWorldbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupWorldbook(
      groupId: serializer.fromJson<String>(json['groupId']),
      worldbookId: serializer.fromJson<String>(json['worldbookId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'worldbookId': serializer.toJson<String>(worldbookId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  GroupWorldbook copyWith({
    String? groupId,
    String? worldbookId,
    int? createdAt,
  }) => GroupWorldbook(
    groupId: groupId ?? this.groupId,
    worldbookId: worldbookId ?? this.worldbookId,
    createdAt: createdAt ?? this.createdAt,
  );
  GroupWorldbook copyWithCompanion(GroupWorldbooksCompanion data) {
    return GroupWorldbook(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      worldbookId: data.worldbookId.present
          ? data.worldbookId.value
          : this.worldbookId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupWorldbook(')
          ..write('groupId: $groupId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, worldbookId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupWorldbook &&
          other.groupId == this.groupId &&
          other.worldbookId == this.worldbookId &&
          other.createdAt == this.createdAt);
}

class GroupWorldbooksCompanion extends UpdateCompanion<GroupWorldbook> {
  final Value<String> groupId;
  final Value<String> worldbookId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const GroupWorldbooksCompanion({
    this.groupId = const Value.absent(),
    this.worldbookId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupWorldbooksCompanion.insert({
    required String groupId,
    required String worldbookId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       worldbookId = Value(worldbookId),
       createdAt = Value(createdAt);
  static Insertable<GroupWorldbook> custom({
    Expression<String>? groupId,
    Expression<String>? worldbookId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (worldbookId != null) 'worldbook_id': worldbookId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupWorldbooksCompanion copyWith({
    Value<String>? groupId,
    Value<String>? worldbookId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return GroupWorldbooksCompanion(
      groupId: groupId ?? this.groupId,
      worldbookId: worldbookId ?? this.worldbookId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (worldbookId.present) {
      map['worldbook_id'] = Variable<String>(worldbookId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupWorldbooksCompanion(')
          ..write('groupId: $groupId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryWorldbooksTable extends StoryWorldbooks
    with TableInfo<$StoryWorldbooksTable, StoryWorldbook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryWorldbooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldbookIdMeta = const VerificationMeta(
    'worldbookId',
  );
  @override
  late final GeneratedColumn<String> worldbookId = GeneratedColumn<String>(
    'worldbook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worldbooks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [storyId, worldbookId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_worldbooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryWorldbook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('worldbook_id')) {
      context.handle(
        _worldbookIdMeta,
        worldbookId.isAcceptableOrUnknown(
          data['worldbook_id']!,
          _worldbookIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldbookIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storyId, worldbookId};
  @override
  StoryWorldbook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryWorldbook(
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      )!,
      worldbookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worldbook_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoryWorldbooksTable createAlias(String alias) {
    return $StoryWorldbooksTable(attachedDatabase, alias);
  }
}

class StoryWorldbook extends DataClass implements Insertable<StoryWorldbook> {
  final String storyId;
  final String worldbookId;
  final int createdAt;
  const StoryWorldbook({
    required this.storyId,
    required this.worldbookId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['story_id'] = Variable<String>(storyId);
    map['worldbook_id'] = Variable<String>(worldbookId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  StoryWorldbooksCompanion toCompanion(bool nullToAbsent) {
    return StoryWorldbooksCompanion(
      storyId: Value(storyId),
      worldbookId: Value(worldbookId),
      createdAt: Value(createdAt),
    );
  }

  factory StoryWorldbook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryWorldbook(
      storyId: serializer.fromJson<String>(json['storyId']),
      worldbookId: serializer.fromJson<String>(json['worldbookId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storyId': serializer.toJson<String>(storyId),
      'worldbookId': serializer.toJson<String>(worldbookId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  StoryWorldbook copyWith({
    String? storyId,
    String? worldbookId,
    int? createdAt,
  }) => StoryWorldbook(
    storyId: storyId ?? this.storyId,
    worldbookId: worldbookId ?? this.worldbookId,
    createdAt: createdAt ?? this.createdAt,
  );
  StoryWorldbook copyWithCompanion(StoryWorldbooksCompanion data) {
    return StoryWorldbook(
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      worldbookId: data.worldbookId.present
          ? data.worldbookId.value
          : this.worldbookId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryWorldbook(')
          ..write('storyId: $storyId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(storyId, worldbookId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryWorldbook &&
          other.storyId == this.storyId &&
          other.worldbookId == this.worldbookId &&
          other.createdAt == this.createdAt);
}

class StoryWorldbooksCompanion extends UpdateCompanion<StoryWorldbook> {
  final Value<String> storyId;
  final Value<String> worldbookId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StoryWorldbooksCompanion({
    this.storyId = const Value.absent(),
    this.worldbookId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryWorldbooksCompanion.insert({
    required String storyId,
    required String worldbookId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : storyId = Value(storyId),
       worldbookId = Value(worldbookId),
       createdAt = Value(createdAt);
  static Insertable<StoryWorldbook> custom({
    Expression<String>? storyId,
    Expression<String>? worldbookId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storyId != null) 'story_id': storyId,
      if (worldbookId != null) 'worldbook_id': worldbookId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryWorldbooksCompanion copyWith({
    Value<String>? storyId,
    Value<String>? worldbookId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StoryWorldbooksCompanion(
      storyId: storyId ?? this.storyId,
      worldbookId: worldbookId ?? this.worldbookId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (worldbookId.present) {
      map['worldbook_id'] = Variable<String>(worldbookId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryWorldbooksCompanion(')
          ..write('storyId: $storyId, ')
          ..write('worldbookId: $worldbookId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupWorldsTable extends GroupWorlds
    with TableInfo<$GroupWorldsTable, GroupWorld> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupWorldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "groups" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [groupId, worldId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_worlds';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupWorld> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {groupId, worldId};
  @override
  GroupWorld map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupWorld(
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GroupWorldsTable createAlias(String alias) {
    return $GroupWorldsTable(attachedDatabase, alias);
  }
}

class GroupWorld extends DataClass implements Insertable<GroupWorld> {
  final String groupId;
  final String worldId;
  final int createdAt;
  const GroupWorld({
    required this.groupId,
    required this.worldId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['group_id'] = Variable<String>(groupId);
    map['world_id'] = Variable<String>(worldId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  GroupWorldsCompanion toCompanion(bool nullToAbsent) {
    return GroupWorldsCompanion(
      groupId: Value(groupId),
      worldId: Value(worldId),
      createdAt: Value(createdAt),
    );
  }

  factory GroupWorld.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupWorld(
      groupId: serializer.fromJson<String>(json['groupId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'groupId': serializer.toJson<String>(groupId),
      'worldId': serializer.toJson<String>(worldId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  GroupWorld copyWith({String? groupId, String? worldId, int? createdAt}) =>
      GroupWorld(
        groupId: groupId ?? this.groupId,
        worldId: worldId ?? this.worldId,
        createdAt: createdAt ?? this.createdAt,
      );
  GroupWorld copyWithCompanion(GroupWorldsCompanion data) {
    return GroupWorld(
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupWorld(')
          ..write('groupId: $groupId, ')
          ..write('worldId: $worldId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(groupId, worldId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupWorld &&
          other.groupId == this.groupId &&
          other.worldId == this.worldId &&
          other.createdAt == this.createdAt);
}

class GroupWorldsCompanion extends UpdateCompanion<GroupWorld> {
  final Value<String> groupId;
  final Value<String> worldId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const GroupWorldsCompanion({
    this.groupId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupWorldsCompanion.insert({
    required String groupId,
    required String worldId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : groupId = Value(groupId),
       worldId = Value(worldId),
       createdAt = Value(createdAt);
  static Insertable<GroupWorld> custom({
    Expression<String>? groupId,
    Expression<String>? worldId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (groupId != null) 'group_id': groupId,
      if (worldId != null) 'world_id': worldId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupWorldsCompanion copyWith({
    Value<String>? groupId,
    Value<String>? worldId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return GroupWorldsCompanion(
      groupId: groupId ?? this.groupId,
      worldId: worldId ?? this.worldId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupWorldsCompanion(')
          ..write('groupId: $groupId, ')
          ..write('worldId: $worldId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryWorldsTable extends StoryWorlds
    with TableInfo<$StoryWorldsTable, StoryWorld> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryWorldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _worldIdMeta = const VerificationMeta(
    'worldId',
  );
  @override
  late final GeneratedColumn<String> worldId = GeneratedColumn<String>(
    'world_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [storyId, worldId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_worlds';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryWorld> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storyIdMeta);
    }
    if (data.containsKey('world_id')) {
      context.handle(
        _worldIdMeta,
        worldId.isAcceptableOrUnknown(data['world_id']!, _worldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_worldIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storyId, worldId};
  @override
  StoryWorld map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryWorld(
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      )!,
      worldId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoryWorldsTable createAlias(String alias) {
    return $StoryWorldsTable(attachedDatabase, alias);
  }
}

class StoryWorld extends DataClass implements Insertable<StoryWorld> {
  final String storyId;
  final String worldId;
  final int createdAt;
  const StoryWorld({
    required this.storyId,
    required this.worldId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['story_id'] = Variable<String>(storyId);
    map['world_id'] = Variable<String>(worldId);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  StoryWorldsCompanion toCompanion(bool nullToAbsent) {
    return StoryWorldsCompanion(
      storyId: Value(storyId),
      worldId: Value(worldId),
      createdAt: Value(createdAt),
    );
  }

  factory StoryWorld.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryWorld(
      storyId: serializer.fromJson<String>(json['storyId']),
      worldId: serializer.fromJson<String>(json['worldId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storyId': serializer.toJson<String>(storyId),
      'worldId': serializer.toJson<String>(worldId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  StoryWorld copyWith({String? storyId, String? worldId, int? createdAt}) =>
      StoryWorld(
        storyId: storyId ?? this.storyId,
        worldId: worldId ?? this.worldId,
        createdAt: createdAt ?? this.createdAt,
      );
  StoryWorld copyWithCompanion(StoryWorldsCompanion data) {
    return StoryWorld(
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      worldId: data.worldId.present ? data.worldId.value : this.worldId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryWorld(')
          ..write('storyId: $storyId, ')
          ..write('worldId: $worldId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(storyId, worldId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryWorld &&
          other.storyId == this.storyId &&
          other.worldId == this.worldId &&
          other.createdAt == this.createdAt);
}

class StoryWorldsCompanion extends UpdateCompanion<StoryWorld> {
  final Value<String> storyId;
  final Value<String> worldId;
  final Value<int> createdAt;
  final Value<int> rowid;
  const StoryWorldsCompanion({
    this.storyId = const Value.absent(),
    this.worldId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryWorldsCompanion.insert({
    required String storyId,
    required String worldId,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : storyId = Value(storyId),
       worldId = Value(worldId),
       createdAt = Value(createdAt);
  static Insertable<StoryWorld> custom({
    Expression<String>? storyId,
    Expression<String>? worldId,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storyId != null) 'story_id': storyId,
      if (worldId != null) 'world_id': worldId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryWorldsCompanion copyWith({
    Value<String>? storyId,
    Value<String>? worldId,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return StoryWorldsCompanion(
      storyId: storyId ?? this.storyId,
      worldId: worldId ?? this.worldId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (worldId.present) {
      map['world_id'] = Variable<String>(worldId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoryWorldsCompanion(')
          ..write('storyId: $storyId, ')
          ..write('worldId: $worldId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharactersTable characters = $CharactersTable(this);
  late final $CharacterAdaptationsTable characterAdaptations =
      $CharacterAdaptationsTable(this);
  late final $WorldsTable worlds = $WorldsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SessionStatesTable sessionStates = $SessionStatesTable(this);
  late final $CharacterRelationsTable characterRelations =
      $CharacterRelationsTable(this);
  late final $CharacterAffinitiesTable characterAffinities =
      $CharacterAffinitiesTable(this);
  late final $CharacterMemoriesTable characterMemories =
      $CharacterMemoriesTable(this);
  late final $ProviderConfigsTable providerConfigs = $ProviderConfigsTable(
    this,
  );
  late final $PresetsTable presets = $PresetsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $GroupsTable groups = $GroupsTable(this);
  late final $GroupMembersTable groupMembers = $GroupMembersTable(this);
  late final $GroupMessagesTable groupMessages = $GroupMessagesTable(this);
  late final $PairRelationsTable pairRelations = $PairRelationsTable(this);
  late final $GroupMemoriesTable groupMemories = $GroupMemoriesTable(this);
  late final $StoriesTable stories = $StoriesTable(this);
  late final $StoryNodesTable storyNodes = $StoryNodesTable(this);
  late final $StorySavesTable storySaves = $StorySavesTable(this);
  late final $WorldbooksTable worldbooks = $WorldbooksTable(this);
  late final $CharacterWorldbooksTable characterWorldbooks =
      $CharacterWorldbooksTable(this);
  late final $WorldWorldbooksTable worldWorldbooks = $WorldWorldbooksTable(
    this,
  );
  late final $GroupWorldbooksTable groupWorldbooks = $GroupWorldbooksTable(
    this,
  );
  late final $StoryWorldbooksTable storyWorldbooks = $StoryWorldbooksTable(
    this,
  );
  late final $GroupWorldsTable groupWorlds = $GroupWorldsTable(this);
  late final $StoryWorldsTable storyWorlds = $StoryWorldsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    characters,
    characterAdaptations,
    worlds,
    sessions,
    messages,
    sessionStates,
    characterRelations,
    characterAffinities,
    characterMemories,
    providerConfigs,
    presets,
    settings,
    groups,
    groupMembers,
    groupMessages,
    pairRelations,
    groupMemories,
    stories,
    storyNodes,
    storySaves,
    worldbooks,
    characterWorldbooks,
    worldWorldbooks,
    groupWorldbooks,
    storyWorldbooks,
    groupWorlds,
    storyWorlds,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_adaptations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('session_states', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_affinities', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_memories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_members', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pair_relations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_memories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_nodes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_saves', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'characters',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worldbooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('character_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worlds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('world_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worldbooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('world_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worldbooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worldbooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_worldbooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'groups',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_worlds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worlds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('group_worlds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'stories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_worlds', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worlds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('story_worlds', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CharactersTableCreateCompanionBuilder = CharactersCompanion Function({
  required String id,
  required String name,
  required String corePersonaJson,
  Value<String?> worldbookJson,
  Value<String?> avatarPath,
  Value<String> tags,
  required String sourceType,
  Value<String?> sourcePath,
  required int createdAt,
  required int updatedAt,
  Value<int?> pinnedAt,
  Value<int> rowid,
});
typedef $$CharactersTableUpdateCompanionBuilder = CharactersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> corePersonaJson,
  Value<String?> worldbookJson,
  Value<String?> avatarPath,
  Value<String> tags,
  Value<String> sourceType,
  Value<String?> sourcePath,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int?> pinnedAt,
  Value<int> rowid,
});

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, Character> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CharacterAdaptationsTable,
    List<CharacterAdaptation>
  >
  _characterAdaptationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterAdaptations,
        aliasName: 'characters__id__character_adaptations__character_id',
      );

  $$CharacterAdaptationsTableProcessedTableManager
  get characterAdaptationsRefs {
    final manager = $$CharacterAdaptationsTableTableManager(
      $_db,
      $_db.characterAdaptations,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterAdaptationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'characters__id__sessions__character_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterRelationsTable, List<CharacterRelation>>
  _characterRelationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterRelations,
        aliasName: 'characters__id__character_relations__character_id',
      );

  $$CharacterRelationsTableProcessedTableManager get characterRelationsRefs {
    final manager = $$CharacterRelationsTableTableManager(
      $_db,
      $_db.characterRelations,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterRelationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterAffinitiesTable, List<CharacterAffinity>>
  _characterAffinitiesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterAffinities,
        aliasName: 'characters__id__character_affinities__character_id',
      );

  $$CharacterAffinitiesTableProcessedTableManager get characterAffinitiesRefs {
    final manager = $$CharacterAffinitiesTableTableManager(
      $_db,
      $_db.characterAffinities,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterAffinitiesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CharacterMemoriesTable, List<CharacterMemory>>
  _characterMemoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterMemories,
        aliasName: 'characters__id__character_memories__character_id',
      );

  $$CharacterMemoriesTableProcessedTableManager get characterMemoriesRefs {
    final manager = $$CharacterMemoriesTableTableManager(
      $_db,
      $_db.characterMemories,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterMemoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
  _groupMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMembers,
    aliasName: 'characters__id__group_members__character_id',
  );

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager(
      $_db,
      $_db.groupMembers,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CharacterWorldbooksTable,
    List<CharacterWorldbook>
  >
  _characterWorldbooksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterWorldbooks,
        aliasName: 'characters__id__character_worldbooks__character_id',
      );

  $$CharacterWorldbooksTableProcessedTableManager get characterWorldbooksRefs {
    final manager = $$CharacterWorldbooksTableTableManager(
      $_db,
      $_db.characterWorldbooks,
    ).filter((f) => f.characterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get corePersonaJson => $composableBuilder(
    column: $table.corePersonaJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> characterAdaptationsRefs(
    Expression<bool> Function($$CharacterAdaptationsTableFilterComposer f) f,
  ) {
    final $$CharacterAdaptationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterAdaptations,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterAdaptationsTableFilterComposer(
            $db: $db,
            $table: $db.characterAdaptations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterRelationsRefs(
    Expression<bool> Function($$CharacterRelationsTableFilterComposer f) f,
  ) {
    final $$CharacterRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterRelations,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterRelationsTableFilterComposer(
            $db: $db,
            $table: $db.characterRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterAffinitiesRefs(
    Expression<bool> Function($$CharacterAffinitiesTableFilterComposer f) f,
  ) {
    final $$CharacterAffinitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterAffinities,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterAffinitiesTableFilterComposer(
            $db: $db,
            $table: $db.characterAffinities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterMemoriesRefs(
    Expression<bool> Function($$CharacterMemoriesTableFilterComposer f) f,
  ) {
    final $$CharacterMemoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterMemories,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterMemoriesTableFilterComposer(
            $db: $db,
            $table: $db.characterMemories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupMembersRefs(
    Expression<bool> Function($$GroupMembersTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> characterWorldbooksRefs(
    Expression<bool> Function($$CharacterWorldbooksTableFilterComposer f) f,
  ) {
    final $$CharacterWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterWorldbooks,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.characterWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get corePersonaJson => $composableBuilder(
    column: $table.corePersonaJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinnedAt => $composableBuilder(
    column: $table.pinnedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get corePersonaJson => $composableBuilder(
    column: $table.corePersonaJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  Expression<T> characterAdaptationsRefs<T extends Object>(
    Expression<T> Function($$CharacterAdaptationsTableAnnotationComposer a) f,
  ) {
    final $$CharacterAdaptationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterAdaptations,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterAdaptationsTableAnnotationComposer(
                $db: $db,
                $table: $db.characterAdaptations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterRelationsRefs<T extends Object>(
    Expression<T> Function($$CharacterRelationsTableAnnotationComposer a) f,
  ) {
    final $$CharacterRelationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterRelations,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterRelationsTableAnnotationComposer(
                $db: $db,
                $table: $db.characterRelations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterAffinitiesRefs<T extends Object>(
    Expression<T> Function($$CharacterAffinitiesTableAnnotationComposer a) f,
  ) {
    final $$CharacterAffinitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterAffinities,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterAffinitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.characterAffinities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> characterMemoriesRefs<T extends Object>(
    Expression<T> Function($$CharacterMemoriesTableAnnotationComposer a) f,
  ) {
    final $$CharacterMemoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterMemories,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterMemoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.characterMemories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> groupMembersRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.characterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> characterWorldbooksRefs<T extends Object>(
    Expression<T> Function($$CharacterWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$CharacterWorldbooksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterWorldbooks,
          getReferencedColumn: (t) => t.characterId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterWorldbooksTableAnnotationComposer(
                $db: $db,
                $table: $db.characterWorldbooks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          Character,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (Character, $$CharactersTableReferences),
          Character,
          PrefetchHooks Function({
            bool characterAdaptationsRefs,
            bool sessionsRefs,
            bool characterRelationsRefs,
            bool characterAffinitiesRefs,
            bool characterMemoriesRefs,
            bool groupMembersRefs,
            bool characterWorldbooksRefs,
          })
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> corePersonaJson = const Value.absent(),
                Value<String?> worldbookJson = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourcePath = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> pinnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                id: id,
                name: name,
                corePersonaJson: corePersonaJson,
                worldbookJson: worldbookJson,
                avatarPath: avatarPath,
                tags: tags,
                sourceType: sourceType,
                sourcePath: sourcePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                pinnedAt: pinnedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String corePersonaJson,
                Value<String?> worldbookJson = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> tags = const Value.absent(),
                required String sourceType,
                Value<String?> sourcePath = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int?> pinnedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                id: id,
                name: name,
                corePersonaJson: corePersonaJson,
                worldbookJson: worldbookJson,
                avatarPath: avatarPath,
                tags: tags,
                sourceType: sourceType,
                sourcePath: sourcePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                pinnedAt: pinnedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharactersTable, Character>(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                characterAdaptationsRefs = false,
                sessionsRefs = false,
                characterRelationsRefs = false,
                characterAffinitiesRefs = false,
                characterMemoriesRefs = false,
                groupMembersRefs = false,
                characterWorldbooksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (characterAdaptationsRefs) db.characterAdaptations,
                    if (sessionsRefs) db.sessions,
                    if (characterRelationsRefs) db.characterRelations,
                    if (characterAffinitiesRefs) db.characterAffinities,
                    if (characterMemoriesRefs) db.characterMemories,
                    if (groupMembersRefs) db.groupMembers,
                    if (characterWorldbooksRefs) db.characterWorldbooks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (characterAdaptationsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterAdaptation
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterAdaptationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterAdaptationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          Session
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterRelationsRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterRelation
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterRelationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterRelationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterAffinitiesRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterAffinity
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterAffinitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterAffinitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterMemoriesRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterMemory
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterMemoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterMemoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupMembersRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          GroupMember
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._groupMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (characterWorldbooksRefs)
                        await $_getPrefetchedData<
                          Character,
                          $CharactersTable,
                          CharacterWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$CharactersTableReferences
                              ._characterWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharactersTableReferences(
                                db,
                                table,
                                p0,
                              ).characterWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.characterId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      Character,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (Character, $$CharactersTableReferences),
      Character,
      PrefetchHooks Function({
        bool characterAdaptationsRefs,
        bool sessionsRefs,
        bool characterRelationsRefs,
        bool characterAffinitiesRefs,
        bool characterMemoriesRefs,
        bool groupMembersRefs,
        bool characterWorldbooksRefs,
      })
    >;
typedef $$CharacterAdaptationsTableCreateCompanionBuilder =
    CharacterAdaptationsCompanion Function({
      required String id,
      required String characterId,
      Value<String> worldId,
      required String adaptationJson,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CharacterAdaptationsTableUpdateCompanionBuilder =
    CharacterAdaptationsCompanion Function({
      Value<String> id,
      Value<String> characterId,
      Value<String> worldId,
      Value<String> adaptationJson,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$CharacterAdaptationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterAdaptationsTable,
          CharacterAdaptation
        > {
  $$CharacterAdaptationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_adaptations__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterAdaptationsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterAdaptationsTable> {
  $$CharacterAdaptationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adaptationJson => $composableBuilder(
    column: $table.adaptationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAdaptationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterAdaptationsTable> {
  $$CharacterAdaptationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adaptationJson => $composableBuilder(
    column: $table.adaptationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAdaptationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterAdaptationsTable> {
  $$CharacterAdaptationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get adaptationJson => $composableBuilder(
    column: $table.adaptationJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAdaptationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterAdaptationsTable,
          CharacterAdaptation,
          $$CharacterAdaptationsTableFilterComposer,
          $$CharacterAdaptationsTableOrderingComposer,
          $$CharacterAdaptationsTableAnnotationComposer,
          $$CharacterAdaptationsTableCreateCompanionBuilder,
          $$CharacterAdaptationsTableUpdateCompanionBuilder,
          (CharacterAdaptation, $$CharacterAdaptationsTableReferences),
          CharacterAdaptation,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterAdaptationsTableTableManager(
    _$AppDatabase db,
    $CharacterAdaptationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterAdaptationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterAdaptationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterAdaptationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<String> adaptationJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterAdaptationsCompanion(
                id: id,
                characterId: characterId,
                worldId: worldId,
                adaptationJson: adaptationJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String characterId,
                Value<String> worldId = const Value.absent(),
                required String adaptationJson,
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterAdaptationsCompanion.insert(
                id: id,
                characterId: characterId,
                worldId: worldId,
                adaptationJson: adaptationJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterAdaptationsTable, CharacterAdaptation>(
                    table,
                  ),
                  $$CharacterAdaptationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$CharacterAdaptationsTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$CharacterAdaptationsTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterAdaptationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterAdaptationsTable,
      CharacterAdaptation,
      $$CharacterAdaptationsTableFilterComposer,
      $$CharacterAdaptationsTableOrderingComposer,
      $$CharacterAdaptationsTableAnnotationComposer,
      $$CharacterAdaptationsTableCreateCompanionBuilder,
      $$CharacterAdaptationsTableUpdateCompanionBuilder,
      (CharacterAdaptation, $$CharacterAdaptationsTableReferences),
      CharacterAdaptation,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$WorldsTableCreateCompanionBuilder = WorldsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String> rulesJson,
  Value<String> worldbookJson,
  Value<String> initialStateJson,
  Value<String> npcPoolJson,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$WorldsTableUpdateCompanionBuilder = WorldsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> rulesJson,
  Value<String> worldbookJson,
  Value<String> initialStateJson,
  Value<String> npcPoolJson,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$WorldsTableReferences
    extends BaseReferences<_$AppDatabase, $WorldsTable, World> {
  $$WorldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorldWorldbooksTable, List<WorldWorldbook>>
  _worldWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.worldWorldbooks,
    aliasName: 'worlds__id__world_worldbooks__world_id',
  );

  $$WorldWorldbooksTableProcessedTableManager get worldWorldbooksRefs {
    final manager = $$WorldWorldbooksTableTableManager(
      $_db,
      $_db.worldWorldbooks,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _worldWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupWorldsTable, List<GroupWorld>>
  _groupWorldsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupWorlds,
    aliasName: 'worlds__id__group_worlds__world_id',
  );

  $$GroupWorldsTableProcessedTableManager get groupWorldsRefs {
    final manager = $$GroupWorldsTableTableManager(
      $_db,
      $_db.groupWorlds,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupWorldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryWorldsTable, List<StoryWorld>>
  _storyWorldsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyWorlds,
    aliasName: 'worlds__id__story_worlds__world_id',
  );

  $$StoryWorldsTableProcessedTableManager get storyWorldsRefs {
    final manager = $$StoryWorldsTableTableManager(
      $_db,
      $_db.storyWorlds,
    ).filter((f) => f.worldId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storyWorldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorldsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rulesJson => $composableBuilder(
    column: $table.rulesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get initialStateJson => $composableBuilder(
    column: $table.initialStateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get npcPoolJson => $composableBuilder(
    column: $table.npcPoolJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> worldWorldbooksRefs(
    Expression<bool> Function($$WorldWorldbooksTableFilterComposer f) f,
  ) {
    final $$WorldWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldWorldbooks,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupWorldsRefs(
    Expression<bool> Function($$GroupWorldsTableFilterComposer f) f,
  ) {
    final $$GroupWorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorlds,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldsTableFilterComposer(
            $db: $db,
            $table: $db.groupWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyWorldsRefs(
    Expression<bool> Function($$StoryWorldsTableFilterComposer f) f,
  ) {
    final $$StoryWorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorlds,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldsTableFilterComposer(
            $db: $db,
            $table: $db.storyWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rulesJson => $composableBuilder(
    column: $table.rulesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get initialStateJson => $composableBuilder(
    column: $table.initialStateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get npcPoolJson => $composableBuilder(
    column: $table.npcPoolJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rulesJson =>
      $composableBuilder(column: $table.rulesJson, builder: (column) => column);

  GeneratedColumn<String> get worldbookJson => $composableBuilder(
    column: $table.worldbookJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get initialStateJson => $composableBuilder(
    column: $table.initialStateJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get npcPoolJson => $composableBuilder(
    column: $table.npcPoolJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> worldWorldbooksRefs<T extends Object>(
    Expression<T> Function($$WorldWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$WorldWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldWorldbooks,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupWorldsRefs<T extends Object>(
    Expression<T> Function($$GroupWorldsTableAnnotationComposer a) f,
  ) {
    final $$GroupWorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorlds,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyWorldsRefs<T extends Object>(
    Expression<T> Function($$StoryWorldsTableAnnotationComposer a) f,
  ) {
    final $$StoryWorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorlds,
      getReferencedColumn: (t) => t.worldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.storyWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldsTable,
          World,
          $$WorldsTableFilterComposer,
          $$WorldsTableOrderingComposer,
          $$WorldsTableAnnotationComposer,
          $$WorldsTableCreateCompanionBuilder,
          $$WorldsTableUpdateCompanionBuilder,
          (World, $$WorldsTableReferences),
          World,
          PrefetchHooks Function({
            bool worldWorldbooksRefs,
            bool groupWorldsRefs,
            bool storyWorldsRefs,
          })
        > {
  $$WorldsTableTableManager(_$AppDatabase db, $WorldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> rulesJson = const Value.absent(),
                Value<String> worldbookJson = const Value.absent(),
                Value<String> initialStateJson = const Value.absent(),
                Value<String> npcPoolJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion(
                id: id,
                name: name,
                description: description,
                rulesJson: rulesJson,
                worldbookJson: worldbookJson,
                initialStateJson: initialStateJson,
                npcPoolJson: npcPoolJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String> rulesJson = const Value.absent(),
                Value<String> worldbookJson = const Value.absent(),
                Value<String> initialStateJson = const Value.absent(),
                Value<String> npcPoolJson = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion.insert(
                id: id,
                name: name,
                description: description,
                rulesJson: rulesJson,
                worldbookJson: worldbookJson,
                initialStateJson: initialStateJson,
                npcPoolJson: npcPoolJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldsTable, World>(table),
                  $$WorldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                worldWorldbooksRefs = false,
                groupWorldsRefs = false,
                storyWorldsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (worldWorldbooksRefs) db.worldWorldbooks,
                    if (groupWorldsRefs) db.groupWorlds,
                    if (storyWorldsRefs) db.storyWorlds,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (worldWorldbooksRefs)
                        await $_getPrefetchedData<
                          World,
                          $WorldsTable,
                          WorldWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._worldWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).worldWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupWorldsRefs)
                        await $_getPrefetchedData<
                          World,
                          $WorldsTable,
                          GroupWorld
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._groupWorldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupWorldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storyWorldsRefs)
                        await $_getPrefetchedData<
                          World,
                          $WorldsTable,
                          StoryWorld
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._storyWorldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).storyWorldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldsTable,
      World,
      $$WorldsTableFilterComposer,
      $$WorldsTableOrderingComposer,
      $$WorldsTableAnnotationComposer,
      $$WorldsTableCreateCompanionBuilder,
      $$WorldsTableUpdateCompanionBuilder,
      (World, $$WorldsTableReferences),
      World,
      PrefetchHooks Function({
        bool worldWorldbooksRefs,
        bool groupWorldsRefs,
        bool storyWorldsRefs,
      })
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  required String id,
  required String characterId,
  Value<String?> worldId,
  Value<String?> adaptationId,
  Value<String?> title,
  Value<String?> persona,
  Value<bool> memoryEnabled,
  Value<String?> contextWindowLimit,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  Value<String?> worldbookIdsJson,
  required int createdAt,
  required int updatedAt,
  required int lastMessageAt,
  Value<int> rowid,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<String> id,
  Value<String> characterId,
  Value<String?> worldId,
  Value<String?> adaptationId,
  Value<String?> title,
  Value<String?> persona,
  Value<bool> memoryEnabled,
  Value<String?> contextWindowLimit,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  Value<String?> worldbookIdsJson,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> lastMessageAt,
  Value<int> rowid,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias('sessions__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'sessions__id__messages__session_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionStatesTable, List<SessionState>>
  _sessionStatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.sessionStates,
    aliasName: 'sessions__id__session_states__session_id',
  );

  $$SessionStatesTableProcessedTableManager get sessionStatesRefs {
    final manager = $$SessionStatesTableTableManager(
      $_db,
      $_db.sessionStates,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionStatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adaptationId => $composableBuilder(
    column: $table.adaptationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get persona => $composableBuilder(
    column: $table.persona,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldbookIdsJson => $composableBuilder(
    column: $table.worldbookIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionStatesRefs(
    Expression<bool> Function($$SessionStatesTableFilterComposer f) f,
  ) {
    final $$SessionStatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionStates,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionStatesTableFilterComposer(
            $db: $db,
            $table: $db.sessionStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adaptationId => $composableBuilder(
    column: $table.adaptationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get persona => $composableBuilder(
    column: $table.persona,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldbookIdsJson => $composableBuilder(
    column: $table.worldbookIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get adaptationId => $composableBuilder(
    column: $table.adaptationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get persona =>
      $composableBuilder(column: $table.persona, builder: (column) => column);

  GeneratedColumn<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get topP =>
      $composableBuilder(column: $table.topP, builder: (column) => column);

  GeneratedColumn<int> get maxTokens =>
      $composableBuilder(column: $table.maxTokens, builder: (column) => column);

  GeneratedColumn<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get worldbookIdsJson => $composableBuilder(
    column: $table.worldbookIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionStatesRefs<T extends Object>(
    Expression<T> Function($$SessionStatesTableAnnotationComposer a) f,
  ) {
    final $$SessionStatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessionStates,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionStatesTableAnnotationComposer(
            $db: $db,
            $table: $db.sessionStates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool characterId,
            bool messagesRefs,
            bool sessionStatesRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<String?> worldId = const Value.absent(),
                Value<String?> adaptationId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> persona = const Value.absent(),
                Value<bool> memoryEnabled = const Value.absent(),
                Value<String?> contextWindowLimit = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                Value<String?> worldbookIdsJson = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> lastMessageAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                characterId: characterId,
                worldId: worldId,
                adaptationId: adaptationId,
                title: title,
                persona: persona,
                memoryEnabled: memoryEnabled,
                contextWindowLimit: contextWindowLimit,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                worldbookIdsJson: worldbookIdsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String characterId,
                Value<String?> worldId = const Value.absent(),
                Value<String?> adaptationId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> persona = const Value.absent(),
                Value<bool> memoryEnabled = const Value.absent(),
                Value<String?> contextWindowLimit = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                Value<String?> worldbookIdsJson = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                required int lastMessageAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                characterId: characterId,
                worldId: worldId,
                adaptationId: adaptationId,
                title: title,
                persona: persona,
                memoryEnabled: memoryEnabled,
                contextWindowLimit: contextWindowLimit,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                worldbookIdsJson: worldbookIdsJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                characterId = false,
                messagesRefs = false,
                sessionStatesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (messagesRefs) db.messages,
                    if (sessionStatesRefs) db.sessionStates,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (characterId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.characterId,
                            referencedTable: $$SessionsTableReferences
                                ._characterIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._characterIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (messagesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          Message
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._messagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).messagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionStatesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          SessionState
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._sessionStatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionStatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool characterId,
        bool messagesRefs,
        bool sessionStatesRefs,
      })
    >;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  required String sessionId,
  required String role,
  required String content,
  required int orderIndex,
  required int timestamp,
  Value<String> metadata,
  Value<String?> type,
  Value<bool> visibleToAi,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> role,
  Value<String> content,
  Value<int> orderIndex,
  Value<int> timestamp,
  Value<String> metadata,
  Value<String?> type,
  Value<bool> visibleToAi,
  Value<int> rowid,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('messages__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, $$MessagesTableReferences),
          Message,
          PrefetchHooks Function({bool sessionId})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<bool> visibleToAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                orderIndex: orderIndex,
                timestamp: timestamp,
                metadata: metadata,
                type: type,
                visibleToAi: visibleToAi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String role,
                required String content,
                required int orderIndex,
                required int timestamp,
                Value<String> metadata = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<bool> visibleToAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                orderIndex: orderIndex,
                timestamp: timestamp,
                metadata: metadata,
                type: type,
                visibleToAi: visibleToAi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, Message>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$MessagesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$MessagesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, $$MessagesTableReferences),
      Message,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$SessionStatesTableCreateCompanionBuilder =
    SessionStatesCompanion Function({
      required String sessionId,
      Value<String> stateJson,
      Value<String> summaryText,
      Value<int> summaryIndex,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$SessionStatesTableUpdateCompanionBuilder =
    SessionStatesCompanion Function({
      Value<String> sessionId,
      Value<String> stateJson,
      Value<String> summaryText,
      Value<int> summaryIndex,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$SessionStatesTableReferences
    extends BaseReferences<_$AppDatabase, $SessionStatesTable, SessionState> {
  $$SessionStatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('session_states__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionStatesTable> {
  $$SessionStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionStatesTable> {
  $$SessionStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionStatesTable> {
  $$SessionStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stateJson =>
      $composableBuilder(column: $table.stateJson, builder: (column) => column);

  GeneratedColumn<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionStatesTable,
          SessionState,
          $$SessionStatesTableFilterComposer,
          $$SessionStatesTableOrderingComposer,
          $$SessionStatesTableAnnotationComposer,
          $$SessionStatesTableCreateCompanionBuilder,
          $$SessionStatesTableUpdateCompanionBuilder,
          (SessionState, $$SessionStatesTableReferences),
          SessionState,
          PrefetchHooks Function({bool sessionId})
        > {
  $$SessionStatesTableTableManager(_$AppDatabase db, $SessionStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<int> summaryIndex = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SessionStatesCompanion(
                sessionId: sessionId,
                stateJson: stateJson,
                summaryText: summaryText,
                summaryIndex: summaryIndex,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<int> summaryIndex = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SessionStatesCompanion.insert(
                sessionId: sessionId,
                stateJson: stateJson,
                summaryText: summaryText,
                summaryIndex: summaryIndex,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionStatesTable, SessionState>(table),
                  $$SessionStatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$SessionStatesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$SessionStatesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionStatesTable,
      SessionState,
      $$SessionStatesTableFilterComposer,
      $$SessionStatesTableOrderingComposer,
      $$SessionStatesTableAnnotationComposer,
      $$SessionStatesTableCreateCompanionBuilder,
      $$SessionStatesTableUpdateCompanionBuilder,
      (SessionState, $$SessionStatesTableReferences),
      SessionState,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$CharacterRelationsTableCreateCompanionBuilder =
    CharacterRelationsCompanion Function({
      required String characterId,
      Value<String> worldId,
      Value<String> relationJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CharacterRelationsTableUpdateCompanionBuilder =
    CharacterRelationsCompanion Function({
      Value<String> characterId,
      Value<String> worldId,
      Value<String> relationJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$CharacterRelationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterRelationsTable,
          CharacterRelation
        > {
  $$CharacterRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_relations__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterRelationsTable> {
  $$CharacterRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterRelationsTable> {
  $$CharacterRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterRelationsTable> {
  $$CharacterRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterRelationsTable,
          CharacterRelation,
          $$CharacterRelationsTableFilterComposer,
          $$CharacterRelationsTableOrderingComposer,
          $$CharacterRelationsTableAnnotationComposer,
          $$CharacterRelationsTableCreateCompanionBuilder,
          $$CharacterRelationsTableUpdateCompanionBuilder,
          (CharacterRelation, $$CharacterRelationsTableReferences),
          CharacterRelation,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterRelationsTableTableManager(
    _$AppDatabase db,
    $CharacterRelationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterRelationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<String> relationJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterRelationsCompanion(
                characterId: characterId,
                worldId: worldId,
                relationJson: relationJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                Value<String> worldId = const Value.absent(),
                Value<String> relationJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterRelationsCompanion.insert(
                characterId: characterId,
                worldId: worldId,
                relationJson: relationJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterRelationsTable, CharacterRelation>(
                    table,
                  ),
                  $$CharacterRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$CharacterRelationsTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$CharacterRelationsTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterRelationsTable,
      CharacterRelation,
      $$CharacterRelationsTableFilterComposer,
      $$CharacterRelationsTableOrderingComposer,
      $$CharacterRelationsTableAnnotationComposer,
      $$CharacterRelationsTableCreateCompanionBuilder,
      $$CharacterRelationsTableUpdateCompanionBuilder,
      (CharacterRelation, $$CharacterRelationsTableReferences),
      CharacterRelation,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterAffinitiesTableCreateCompanionBuilder =
    CharacterAffinitiesCompanion Function({
      required String characterId,
      Value<String> worldId,
      Value<String> affinityJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CharacterAffinitiesTableUpdateCompanionBuilder =
    CharacterAffinitiesCompanion Function({
      Value<String> characterId,
      Value<String> worldId,
      Value<String> affinityJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$CharacterAffinitiesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterAffinitiesTable,
          CharacterAffinity
        > {
  $$CharacterAffinitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_affinities__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterAffinitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterAffinitiesTable> {
  $$CharacterAffinitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get affinityJson => $composableBuilder(
    column: $table.affinityJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAffinitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterAffinitiesTable> {
  $$CharacterAffinitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get affinityJson => $composableBuilder(
    column: $table.affinityJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAffinitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterAffinitiesTable> {
  $$CharacterAffinitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get affinityJson => $composableBuilder(
    column: $table.affinityJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterAffinitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterAffinitiesTable,
          CharacterAffinity,
          $$CharacterAffinitiesTableFilterComposer,
          $$CharacterAffinitiesTableOrderingComposer,
          $$CharacterAffinitiesTableAnnotationComposer,
          $$CharacterAffinitiesTableCreateCompanionBuilder,
          $$CharacterAffinitiesTableUpdateCompanionBuilder,
          (CharacterAffinity, $$CharacterAffinitiesTableReferences),
          CharacterAffinity,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterAffinitiesTableTableManager(
    _$AppDatabase db,
    $CharacterAffinitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterAffinitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterAffinitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterAffinitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<String> affinityJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterAffinitiesCompanion(
                characterId: characterId,
                worldId: worldId,
                affinityJson: affinityJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                Value<String> worldId = const Value.absent(),
                Value<String> affinityJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterAffinitiesCompanion.insert(
                characterId: characterId,
                worldId: worldId,
                affinityJson: affinityJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterAffinitiesTable, CharacterAffinity>(
                    table,
                  ),
                  $$CharacterAffinitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$CharacterAffinitiesTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$CharacterAffinitiesTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterAffinitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterAffinitiesTable,
      CharacterAffinity,
      $$CharacterAffinitiesTableFilterComposer,
      $$CharacterAffinitiesTableOrderingComposer,
      $$CharacterAffinitiesTableAnnotationComposer,
      $$CharacterAffinitiesTableCreateCompanionBuilder,
      $$CharacterAffinitiesTableUpdateCompanionBuilder,
      (CharacterAffinity, $$CharacterAffinitiesTableReferences),
      CharacterAffinity,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$CharacterMemoriesTableCreateCompanionBuilder =
    CharacterMemoriesCompanion Function({
      required String characterId,
      Value<String> worldId,
      Value<String> stateJson,
      Value<String> summaryText,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$CharacterMemoriesTableUpdateCompanionBuilder =
    CharacterMemoriesCompanion Function({
      Value<String> characterId,
      Value<String> worldId,
      Value<String> stateJson,
      Value<String> summaryText,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$CharacterMemoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterMemoriesTable,
          CharacterMemory
        > {
  $$CharacterMemoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_memories__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterMemoriesTable> {
  $$CharacterMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterMemoriesTable> {
  $$CharacterMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterMemoriesTable> {
  $$CharacterMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get stateJson =>
      $composableBuilder(column: $table.stateJson, builder: (column) => column);

  GeneratedColumn<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterMemoriesTable,
          CharacterMemory,
          $$CharacterMemoriesTableFilterComposer,
          $$CharacterMemoriesTableOrderingComposer,
          $$CharacterMemoriesTableAnnotationComposer,
          $$CharacterMemoriesTableCreateCompanionBuilder,
          $$CharacterMemoriesTableUpdateCompanionBuilder,
          (CharacterMemory, $$CharacterMemoriesTableReferences),
          CharacterMemory,
          PrefetchHooks Function({bool characterId})
        > {
  $$CharacterMemoriesTableTableManager(
    _$AppDatabase db,
    $CharacterMemoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharacterMemoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterMemoriesCompanion(
                characterId: characterId,
                worldId: worldId,
                stateJson: stateJson,
                summaryText: summaryText,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                Value<String> worldId = const Value.absent(),
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterMemoriesCompanion.insert(
                characterId: characterId,
                worldId: worldId,
                stateJson: stateJson,
                summaryText: summaryText,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterMemoriesTable, CharacterMemory>(table),
                  $$CharacterMemoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$CharacterMemoriesTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$CharacterMemoriesTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterMemoriesTable,
      CharacterMemory,
      $$CharacterMemoriesTableFilterComposer,
      $$CharacterMemoriesTableOrderingComposer,
      $$CharacterMemoriesTableAnnotationComposer,
      $$CharacterMemoriesTableCreateCompanionBuilder,
      $$CharacterMemoriesTableUpdateCompanionBuilder,
      (CharacterMemory, $$CharacterMemoriesTableReferences),
      CharacterMemory,
      PrefetchHooks Function({bool characterId})
    >;
typedef $$ProviderConfigsTableCreateCompanionBuilder =
    ProviderConfigsCompanion Function({
      required String id,
      required String name,
      required String type,
      required String baseUrl,
      required String model,
      Value<String> apiKeyRef,
      Value<String> extraParamsJson,
      Value<String?> memoryModel,
      Value<int?> contextWindowLimit,
      Value<bool> isDefault,
      required int createdAt,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ProviderConfigsTableUpdateCompanionBuilder =
    ProviderConfigsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String> baseUrl,
      Value<String> model,
      Value<String> apiKeyRef,
      Value<String> extraParamsJson,
      Value<String?> memoryModel,
      Value<int?> contextWindowLimit,
      Value<bool> isDefault,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ProviderConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTable> {
  $$ProviderConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiKeyRef => $composableBuilder(
    column: $table.apiKeyRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraParamsJson => $composableBuilder(
    column: $table.extraParamsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memoryModel => $composableBuilder(
    column: $table.memoryModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProviderConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTable> {
  $$ProviderConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiKeyRef => $composableBuilder(
    column: $table.apiKeyRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraParamsJson => $composableBuilder(
    column: $table.extraParamsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memoryModel => $composableBuilder(
    column: $table.memoryModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProviderConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderConfigsTable> {
  $$ProviderConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get apiKeyRef =>
      $composableBuilder(column: $table.apiKeyRef, builder: (column) => column);

  GeneratedColumn<String> get extraParamsJson => $composableBuilder(
    column: $table.extraParamsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get memoryModel => $composableBuilder(
    column: $table.memoryModel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contextWindowLimit => $composableBuilder(
    column: $table.contextWindowLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProviderConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProviderConfigsTable,
          ProviderConfig,
          $$ProviderConfigsTableFilterComposer,
          $$ProviderConfigsTableOrderingComposer,
          $$ProviderConfigsTableAnnotationComposer,
          $$ProviderConfigsTableCreateCompanionBuilder,
          $$ProviderConfigsTableUpdateCompanionBuilder,
          (
            ProviderConfig,
            BaseReferences<
              _$AppDatabase,
              $ProviderConfigsTable,
              ProviderConfig
            >,
          ),
          ProviderConfig,
          PrefetchHooks Function()
        > {
  $$ProviderConfigsTableTableManager(
    _$AppDatabase db,
    $ProviderConfigsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProviderConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<String> apiKeyRef = const Value.absent(),
                Value<String> extraParamsJson = const Value.absent(),
                Value<String?> memoryModel = const Value.absent(),
                Value<int?> contextWindowLimit = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProviderConfigsCompanion(
                id: id,
                name: name,
                type: type,
                baseUrl: baseUrl,
                model: model,
                apiKeyRef: apiKeyRef,
                extraParamsJson: extraParamsJson,
                memoryModel: memoryModel,
                contextWindowLimit: contextWindowLimit,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                required String baseUrl,
                required String model,
                Value<String> apiKeyRef = const Value.absent(),
                Value<String> extraParamsJson = const Value.absent(),
                Value<String?> memoryModel = const Value.absent(),
                Value<int?> contextWindowLimit = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProviderConfigsCompanion.insert(
                id: id,
                name: name,
                type: type,
                baseUrl: baseUrl,
                model: model,
                apiKeyRef: apiKeyRef,
                extraParamsJson: extraParamsJson,
                memoryModel: memoryModel,
                contextWindowLimit: contextWindowLimit,
                isDefault: isDefault,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProviderConfigsTable, ProviderConfig>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProviderConfigsTable,
                    ProviderConfig
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProviderConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProviderConfigsTable,
      ProviderConfig,
      $$ProviderConfigsTableFilterComposer,
      $$ProviderConfigsTableOrderingComposer,
      $$ProviderConfigsTableAnnotationComposer,
      $$ProviderConfigsTableCreateCompanionBuilder,
      $$ProviderConfigsTableUpdateCompanionBuilder,
      (
        ProviderConfig,
        BaseReferences<_$AppDatabase, $ProviderConfigsTable, ProviderConfig>,
      ),
      ProviderConfig,
      PrefetchHooks Function()
    >;
typedef $$PresetsTableCreateCompanionBuilder = PresetsCompanion Function({
  required String id,
  required String name,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$PresetsTableUpdateCompanionBuilder = PresetsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$PresetsTableFilterComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get topP =>
      $composableBuilder(column: $table.topP, builder: (column) => column);

  GeneratedColumn<int> get maxTokens =>
      $composableBuilder(column: $table.maxTokens, builder: (column) => column);

  GeneratedColumn<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresetsTable,
          Preset,
          $$PresetsTableFilterComposer,
          $$PresetsTableOrderingComposer,
          $$PresetsTableAnnotationComposer,
          $$PresetsTableCreateCompanionBuilder,
          $$PresetsTableUpdateCompanionBuilder,
          (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
          Preset,
          PrefetchHooks Function()
        > {
  $$PresetsTableTableManager(_$AppDatabase db, $PresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresetsCompanion(
                id: id,
                name: name,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PresetsCompanion.insert(
                id: id,
                name: name,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PresetsTable, Preset>(table),
                  BaseReferences<_$AppDatabase, $PresetsTable, Preset>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresetsTable,
      Preset,
      $$PresetsTableFilterComposer,
      $$PresetsTableOrderingComposer,
      $$PresetsTableAnnotationComposer,
      $$PresetsTableCreateCompanionBuilder,
      $$PresetsTableUpdateCompanionBuilder,
      (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
      Preset,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$GroupsTableCreateCompanionBuilder = GroupsCompanion Function({
  required String id,
  required String name,
  Value<String?> worldId,
  Value<String?> avatarPath,
  Value<String> speakMode,
  Value<bool> memoryEnabled,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  required int createdAt,
  required int updatedAt,
  required int lastMessageAt,
  Value<int> rowid,
});
typedef $$GroupsTableUpdateCompanionBuilder = GroupsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> worldId,
  Value<String?> avatarPath,
  Value<String> speakMode,
  Value<bool> memoryEnabled,
  Value<String?> providerId,
  Value<double?> temperature,
  Value<double?> topP,
  Value<int?> maxTokens,
  Value<double?> presencePenalty,
  Value<double?> frequencyPenalty,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> lastMessageAt,
  Value<int> rowid,
});

final class $$GroupsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupsTable, Group> {
  $$GroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GroupMembersTable, List<GroupMember>>
  _groupMembersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMembers,
    aliasName: 'groups__id__group_members__group_id',
  );

  $$GroupMembersTableProcessedTableManager get groupMembersRefs {
    final manager = $$GroupMembersTableTableManager(
      $_db,
      $_db.groupMembers,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMembersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupMessagesTable, List<GroupMessage>>
  _groupMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMessages,
    aliasName: 'groups__id__group_messages__group_id',
  );

  $$GroupMessagesTableProcessedTableManager get groupMessagesRefs {
    final manager = $$GroupMessagesTableTableManager(
      $_db,
      $_db.groupMessages,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PairRelationsTable, List<PairRelation>>
  _pairRelationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pairRelations,
    aliasName: 'groups__id__pair_relations__group_id',
  );

  $$PairRelationsTableProcessedTableManager get pairRelationsRefs {
    final manager = $$PairRelationsTableTableManager(
      $_db,
      $_db.pairRelations,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pairRelationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupMemoriesTable, List<GroupMemory>>
  _groupMemoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupMemories,
    aliasName: 'groups__id__group_memories__group_id',
  );

  $$GroupMemoriesTableProcessedTableManager get groupMemoriesRefs {
    final manager = $$GroupMemoriesTableTableManager(
      $_db,
      $_db.groupMemories,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupMemoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupWorldbooksTable, List<GroupWorldbook>>
  _groupWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupWorldbooks,
    aliasName: 'groups__id__group_worldbooks__group_id',
  );

  $$GroupWorldbooksTableProcessedTableManager get groupWorldbooksRefs {
    final manager = $$GroupWorldbooksTableTableManager(
      $_db,
      $_db.groupWorldbooks,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupWorldsTable, List<GroupWorld>>
  _groupWorldsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupWorlds,
    aliasName: 'groups__id__group_worlds__group_id',
  );

  $$GroupWorldsTableProcessedTableManager get groupWorldsRefs {
    final manager = $$GroupWorldsTableTableManager(
      $_db,
      $_db.groupWorlds,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_groupWorldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speakMode => $composableBuilder(
    column: $table.speakMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> groupMembersRefs(
    Expression<bool> Function($$GroupMembersTableFilterComposer f) f,
  ) {
    final $$GroupMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableFilterComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupMessagesRefs(
    Expression<bool> Function($$GroupMessagesTableFilterComposer f) f,
  ) {
    final $$GroupMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMessages,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMessagesTableFilterComposer(
            $db: $db,
            $table: $db.groupMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pairRelationsRefs(
    Expression<bool> Function($$PairRelationsTableFilterComposer f) f,
  ) {
    final $$PairRelationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairRelations,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairRelationsTableFilterComposer(
            $db: $db,
            $table: $db.pairRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupMemoriesRefs(
    Expression<bool> Function($$GroupMemoriesTableFilterComposer f) f,
  ) {
    final $$GroupMemoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMemoriesTableFilterComposer(
            $db: $db,
            $table: $db.groupMemories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupWorldbooksRefs(
    Expression<bool> Function($$GroupWorldbooksTableFilterComposer f) f,
  ) {
    final $$GroupWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorldbooks,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.groupWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupWorldsRefs(
    Expression<bool> Function($$GroupWorldsTableFilterComposer f) f,
  ) {
    final $$GroupWorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorlds,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldsTableFilterComposer(
            $db: $db,
            $table: $db.groupWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speakMode => $composableBuilder(
    column: $table.speakMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxTokens => $composableBuilder(
    column: $table.maxTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupsTable> {
  $$GroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get speakMode =>
      $composableBuilder(column: $table.speakMode, builder: (column) => column);

  GeneratedColumn<bool> get memoryEnabled => $composableBuilder(
    column: $table.memoryEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerId => $composableBuilder(
    column: $table.providerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get topP =>
      $composableBuilder(column: $table.topP, builder: (column) => column);

  GeneratedColumn<int> get maxTokens =>
      $composableBuilder(column: $table.maxTokens, builder: (column) => column);

  GeneratedColumn<double> get presencePenalty => $composableBuilder(
    column: $table.presencePenalty,
    builder: (column) => column,
  );

  GeneratedColumn<double> get frequencyPenalty => $composableBuilder(
    column: $table.frequencyPenalty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  Expression<T> groupMembersRefs<T extends Object>(
    Expression<T> Function($$GroupMembersTableAnnotationComposer a) f,
  ) {
    final $$GroupMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMembers,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupMessagesRefs<T extends Object>(
    Expression<T> Function($$GroupMessagesTableAnnotationComposer a) f,
  ) {
    final $$GroupMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMessages,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pairRelationsRefs<T extends Object>(
    Expression<T> Function($$PairRelationsTableAnnotationComposer a) f,
  ) {
    final $$PairRelationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pairRelations,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PairRelationsTableAnnotationComposer(
            $db: $db,
            $table: $db.pairRelations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupMemoriesRefs<T extends Object>(
    Expression<T> Function($$GroupMemoriesTableAnnotationComposer a) f,
  ) {
    final $$GroupMemoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupMemories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupMemoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.groupMemories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupWorldbooksRefs<T extends Object>(
    Expression<T> Function($$GroupWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$GroupWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorldbooks,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.groupWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupWorldsRefs<T extends Object>(
    Expression<T> Function($$GroupWorldsTableAnnotationComposer a) f,
  ) {
    final $$GroupWorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorlds,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.groupWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupsTable,
          Group,
          $$GroupsTableFilterComposer,
          $$GroupsTableOrderingComposer,
          $$GroupsTableAnnotationComposer,
          $$GroupsTableCreateCompanionBuilder,
          $$GroupsTableUpdateCompanionBuilder,
          (Group, $$GroupsTableReferences),
          Group,
          PrefetchHooks Function({
            bool groupMembersRefs,
            bool groupMessagesRefs,
            bool pairRelationsRefs,
            bool groupMemoriesRefs,
            bool groupWorldbooksRefs,
            bool groupWorldsRefs,
          })
        > {
  $$GroupsTableTableManager(_$AppDatabase db, $GroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> worldId = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> speakMode = const Value.absent(),
                Value<bool> memoryEnabled = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> lastMessageAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion(
                id: id,
                name: name,
                worldId: worldId,
                avatarPath: avatarPath,
                speakMode: speakMode,
                memoryEnabled: memoryEnabled,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> worldId = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> speakMode = const Value.absent(),
                Value<bool> memoryEnabled = const Value.absent(),
                Value<String?> providerId = const Value.absent(),
                Value<double?> temperature = const Value.absent(),
                Value<double?> topP = const Value.absent(),
                Value<int?> maxTokens = const Value.absent(),
                Value<double?> presencePenalty = const Value.absent(),
                Value<double?> frequencyPenalty = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                required int lastMessageAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupsCompanion.insert(
                id: id,
                name: name,
                worldId: worldId,
                avatarPath: avatarPath,
                speakMode: speakMode,
                memoryEnabled: memoryEnabled,
                providerId: providerId,
                temperature: temperature,
                topP: topP,
                maxTokens: maxTokens,
                presencePenalty: presencePenalty,
                frequencyPenalty: frequencyPenalty,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastMessageAt: lastMessageAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupsTable, Group>(table),
                  $$GroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupMembersRefs = false,
                groupMessagesRefs = false,
                pairRelationsRefs = false,
                groupMemoriesRefs = false,
                groupWorldbooksRefs = false,
                groupWorldsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (groupMembersRefs) db.groupMembers,
                    if (groupMessagesRefs) db.groupMessages,
                    if (pairRelationsRefs) db.pairRelations,
                    if (groupMemoriesRefs) db.groupMemories,
                    if (groupWorldbooksRefs) db.groupWorldbooks,
                    if (groupWorldsRefs) db.groupWorlds,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (groupMembersRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupMember
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupMembersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMembersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupMessagesRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupMessage
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pairRelationsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          PairRelation
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._pairRelationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).pairRelationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupMemoriesRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupMemory
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupMemoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupMemoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupWorldbooksRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupWorldsRefs)
                        await $_getPrefetchedData<
                          Group,
                          $GroupsTable,
                          GroupWorld
                        >(
                          currentTable: table,
                          referencedTable: $$GroupsTableReferences
                              ._groupWorldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).groupWorldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupsTable,
      Group,
      $$GroupsTableFilterComposer,
      $$GroupsTableOrderingComposer,
      $$GroupsTableAnnotationComposer,
      $$GroupsTableCreateCompanionBuilder,
      $$GroupsTableUpdateCompanionBuilder,
      (Group, $$GroupsTableReferences),
      Group,
      PrefetchHooks Function({
        bool groupMembersRefs,
        bool groupMessagesRefs,
        bool pairRelationsRefs,
        bool groupMemoriesRefs,
        bool groupWorldbooksRefs,
        bool groupWorldsRefs,
      })
    >;
typedef $$GroupMembersTableCreateCompanionBuilder =
    GroupMembersCompanion Function({
      required String id,
      required String groupId,
      required String characterId,
      required int joinOrder,
      Value<int> rowid,
    });
typedef $$GroupMembersTableUpdateCompanionBuilder =
    GroupMembersCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> characterId,
      Value<int> joinOrder,
      Value<int> rowid,
    });

final class $$GroupMembersTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMembersTable, GroupMember> {
  $$GroupMembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_members__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CharactersTable _characterIdTable(_$AppDatabase db) =>
      db.characters.createAlias('group_members__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMembersTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get joinOrder => $composableBuilder(
    column: $table.joinOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get joinOrder => $composableBuilder(
    column: $table.joinOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMembersTable> {
  $$GroupMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get joinOrder =>
      $composableBuilder(column: $table.joinOrder, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMembersTable,
          GroupMember,
          $$GroupMembersTableFilterComposer,
          $$GroupMembersTableOrderingComposer,
          $$GroupMembersTableAnnotationComposer,
          $$GroupMembersTableCreateCompanionBuilder,
          $$GroupMembersTableUpdateCompanionBuilder,
          (GroupMember, $$GroupMembersTableReferences),
          GroupMember,
          PrefetchHooks Function({bool groupId, bool characterId})
        > {
  $$GroupMembersTableTableManager(_$AppDatabase db, $GroupMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> characterId = const Value.absent(),
                Value<int> joinOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion(
                id: id,
                groupId: groupId,
                characterId: characterId,
                joinOrder: joinOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String characterId,
                required int joinOrder,
                Value<int> rowid = const Value.absent(),
              }) => GroupMembersCompanion.insert(
                id: id,
                groupId: groupId,
                characterId: characterId,
                joinOrder: joinOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupMembersTable, GroupMember>(table),
                  $$GroupMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, characterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupMembersTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupMembersTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$GroupMembersTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$GroupMembersTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMembersTable,
      GroupMember,
      $$GroupMembersTableFilterComposer,
      $$GroupMembersTableOrderingComposer,
      $$GroupMembersTableAnnotationComposer,
      $$GroupMembersTableCreateCompanionBuilder,
      $$GroupMembersTableUpdateCompanionBuilder,
      (GroupMember, $$GroupMembersTableReferences),
      GroupMember,
      PrefetchHooks Function({bool groupId, bool characterId})
    >;
typedef $$GroupMessagesTableCreateCompanionBuilder =
    GroupMessagesCompanion Function({
      required String id,
      required String groupId,
      Value<String?> speakerCharacterId,
      required String role,
      required String content,
      required int orderIndex,
      required int timestamp,
      Value<String?> type,
      Value<bool> visibleToAi,
      Value<int> rowid,
    });
typedef $$GroupMessagesTableUpdateCompanionBuilder =
    GroupMessagesCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String?> speakerCharacterId,
      Value<String> role,
      Value<String> content,
      Value<int> orderIndex,
      Value<int> timestamp,
      Value<String?> type,
      Value<bool> visibleToAi,
      Value<int> rowid,
    });

final class $$GroupMessagesTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMessagesTable, GroupMessage> {
  $$GroupMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_messages__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMessagesTable> {
  $$GroupMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speakerCharacterId => $composableBuilder(
    column: $table.speakerCharacterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMessagesTable> {
  $$GroupMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speakerCharacterId => $composableBuilder(
    column: $table.speakerCharacterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMessagesTable> {
  $$GroupMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speakerCharacterId => $composableBuilder(
    column: $table.speakerCharacterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get visibleToAi => $composableBuilder(
    column: $table.visibleToAi,
    builder: (column) => column,
  );

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMessagesTable,
          GroupMessage,
          $$GroupMessagesTableFilterComposer,
          $$GroupMessagesTableOrderingComposer,
          $$GroupMessagesTableAnnotationComposer,
          $$GroupMessagesTableCreateCompanionBuilder,
          $$GroupMessagesTableUpdateCompanionBuilder,
          (GroupMessage, $$GroupMessagesTableReferences),
          GroupMessage,
          PrefetchHooks Function({bool groupId})
        > {
  $$GroupMessagesTableTableManager(_$AppDatabase db, $GroupMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String?> speakerCharacterId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<int> timestamp = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<bool> visibleToAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMessagesCompanion(
                id: id,
                groupId: groupId,
                speakerCharacterId: speakerCharacterId,
                role: role,
                content: content,
                orderIndex: orderIndex,
                timestamp: timestamp,
                type: type,
                visibleToAi: visibleToAi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                Value<String?> speakerCharacterId = const Value.absent(),
                required String role,
                required String content,
                required int orderIndex,
                required int timestamp,
                Value<String?> type = const Value.absent(),
                Value<bool> visibleToAi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMessagesCompanion.insert(
                id: id,
                groupId: groupId,
                speakerCharacterId: speakerCharacterId,
                role: role,
                content: content,
                orderIndex: orderIndex,
                timestamp: timestamp,
                type: type,
                visibleToAi: visibleToAi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupMessagesTable, GroupMessage>(table),
                  $$GroupMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupMessagesTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupMessagesTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMessagesTable,
      GroupMessage,
      $$GroupMessagesTableFilterComposer,
      $$GroupMessagesTableOrderingComposer,
      $$GroupMessagesTableAnnotationComposer,
      $$GroupMessagesTableCreateCompanionBuilder,
      $$GroupMessagesTableUpdateCompanionBuilder,
      (GroupMessage, $$GroupMessagesTableReferences),
      GroupMessage,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$PairRelationsTableCreateCompanionBuilder =
    PairRelationsCompanion Function({
      required String id,
      required String groupId,
      required String charA,
      required String charB,
      Value<String> relationJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$PairRelationsTableUpdateCompanionBuilder =
    PairRelationsCompanion Function({
      Value<String> id,
      Value<String> groupId,
      Value<String> charA,
      Value<String> charB,
      Value<String> relationJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$PairRelationsTableReferences
    extends BaseReferences<_$AppDatabase, $PairRelationsTable, PairRelation> {
  $$PairRelationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('pair_relations__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PairRelationsTableFilterComposer
    extends Composer<_$AppDatabase, $PairRelationsTable> {
  $$PairRelationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get charA => $composableBuilder(
    column: $table.charA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get charB => $composableBuilder(
    column: $table.charB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairRelationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PairRelationsTable> {
  $$PairRelationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get charA => $composableBuilder(
    column: $table.charA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get charB => $composableBuilder(
    column: $table.charB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairRelationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PairRelationsTable> {
  $$PairRelationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get charA =>
      $composableBuilder(column: $table.charA, builder: (column) => column);

  GeneratedColumn<String> get charB =>
      $composableBuilder(column: $table.charB, builder: (column) => column);

  GeneratedColumn<String> get relationJson => $composableBuilder(
    column: $table.relationJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PairRelationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PairRelationsTable,
          PairRelation,
          $$PairRelationsTableFilterComposer,
          $$PairRelationsTableOrderingComposer,
          $$PairRelationsTableAnnotationComposer,
          $$PairRelationsTableCreateCompanionBuilder,
          $$PairRelationsTableUpdateCompanionBuilder,
          (PairRelation, $$PairRelationsTableReferences),
          PairRelation,
          PrefetchHooks Function({bool groupId})
        > {
  $$PairRelationsTableTableManager(_$AppDatabase db, $PairRelationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PairRelationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PairRelationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PairRelationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> charA = const Value.absent(),
                Value<String> charB = const Value.absent(),
                Value<String> relationJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PairRelationsCompanion(
                id: id,
                groupId: groupId,
                charA: charA,
                charB: charB,
                relationJson: relationJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String groupId,
                required String charA,
                required String charB,
                Value<String> relationJson = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PairRelationsCompanion.insert(
                id: id,
                groupId: groupId,
                charA: charA,
                charB: charB,
                relationJson: relationJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PairRelationsTable, PairRelation>(table),
                  $$PairRelationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$PairRelationsTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$PairRelationsTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PairRelationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PairRelationsTable,
      PairRelation,
      $$PairRelationsTableFilterComposer,
      $$PairRelationsTableOrderingComposer,
      $$PairRelationsTableAnnotationComposer,
      $$PairRelationsTableCreateCompanionBuilder,
      $$PairRelationsTableUpdateCompanionBuilder,
      (PairRelation, $$PairRelationsTableReferences),
      PairRelation,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$GroupMemoriesTableCreateCompanionBuilder =
    GroupMemoriesCompanion Function({
      required String groupId,
      Value<String> stateJson,
      Value<String> summaryText,
      Value<int> summaryIndex,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$GroupMemoriesTableUpdateCompanionBuilder =
    GroupMemoriesCompanion Function({
      Value<String> groupId,
      Value<String> stateJson,
      Value<String> summaryText,
      Value<int> summaryIndex,
      Value<int> updatedAt,
      Value<int> rowid,
    });

final class $$GroupMemoriesTableReferences
    extends BaseReferences<_$AppDatabase, $GroupMemoriesTable, GroupMemory> {
  $$GroupMemoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_memories__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $GroupMemoriesTable> {
  $$GroupMemoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupMemoriesTable> {
  $$GroupMemoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get stateJson => $composableBuilder(
    column: $table.stateJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupMemoriesTable> {
  $$GroupMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get stateJson =>
      $composableBuilder(column: $table.stateJson, builder: (column) => column);

  GeneratedColumn<String> get summaryText => $composableBuilder(
    column: $table.summaryText,
    builder: (column) => column,
  );

  GeneratedColumn<int> get summaryIndex => $composableBuilder(
    column: $table.summaryIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupMemoriesTable,
          GroupMemory,
          $$GroupMemoriesTableFilterComposer,
          $$GroupMemoriesTableOrderingComposer,
          $$GroupMemoriesTableAnnotationComposer,
          $$GroupMemoriesTableCreateCompanionBuilder,
          $$GroupMemoriesTableUpdateCompanionBuilder,
          (GroupMemory, $$GroupMemoriesTableReferences),
          GroupMemory,
          PrefetchHooks Function({bool groupId})
        > {
  $$GroupMemoriesTableTableManager(_$AppDatabase db, $GroupMemoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<int> summaryIndex = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupMemoriesCompanion(
                groupId: groupId,
                stateJson: stateJson,
                summaryText: summaryText,
                summaryIndex: summaryIndex,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                Value<String> stateJson = const Value.absent(),
                Value<String> summaryText = const Value.absent(),
                Value<int> summaryIndex = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupMemoriesCompanion.insert(
                groupId: groupId,
                stateJson: stateJson,
                summaryText: summaryText,
                summaryIndex: summaryIndex,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupMemoriesTable, GroupMemory>(table),
                  $$GroupMemoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupMemoriesTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupMemoriesTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupMemoriesTable,
      GroupMemory,
      $$GroupMemoriesTableFilterComposer,
      $$GroupMemoriesTableOrderingComposer,
      $$GroupMemoriesTableAnnotationComposer,
      $$GroupMemoriesTableCreateCompanionBuilder,
      $$GroupMemoriesTableUpdateCompanionBuilder,
      (GroupMemory, $$GroupMemoriesTableReferences),
      GroupMemory,
      PrefetchHooks Function({bool groupId})
    >;
typedef $$StoriesTableCreateCompanionBuilder = StoriesCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  Value<String?> characterId,
  Value<String?> worldId,
  Value<String?> coverPath,
  Value<String?> currentNodeId,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$StoriesTableUpdateCompanionBuilder = StoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String?> characterId,
  Value<String?> worldId,
  Value<String?> coverPath,
  Value<String?> currentNodeId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$StoriesTableReferences
    extends BaseReferences<_$AppDatabase, $StoriesTable, Story> {
  $$StoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StoryNodesTable, List<StoryNode>>
  _storyNodesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyNodes,
    aliasName: 'stories__id__story_nodes__story_id',
  );

  $$StoryNodesTableProcessedTableManager get storyNodesRefs {
    final manager = $$StoryNodesTableTableManager(
      $_db,
      $_db.storyNodes,
    ).filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storyNodesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StorySavesTable, List<StorySave>>
  _storySavesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storySaves,
    aliasName: 'stories__id__story_saves__story_id',
  );

  $$StorySavesTableProcessedTableManager get storySavesRefs {
    final manager = $$StorySavesTableTableManager(
      $_db,
      $_db.storySaves,
    ).filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storySavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryWorldbooksTable, List<StoryWorldbook>>
  _storyWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyWorldbooks,
    aliasName: 'stories__id__story_worldbooks__story_id',
  );

  $$StoryWorldbooksTableProcessedTableManager get storyWorldbooksRefs {
    final manager = $$StoryWorldbooksTableTableManager(
      $_db,
      $_db.storyWorldbooks,
    ).filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storyWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryWorldsTable, List<StoryWorld>>
  _storyWorldsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyWorlds,
    aliasName: 'stories__id__story_worlds__story_id',
  );

  $$StoryWorldsTableProcessedTableManager get storyWorldsRefs {
    final manager = $$StoryWorldsTableTableManager(
      $_db,
      $_db.storyWorlds,
    ).filter((f) => f.storyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_storyWorldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> storyNodesRefs(
    Expression<bool> Function($$StoryNodesTableFilterComposer f) f,
  ) {
    final $$StoryNodesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyNodes,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryNodesTableFilterComposer(
            $db: $db,
            $table: $db.storyNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storySavesRefs(
    Expression<bool> Function($$StorySavesTableFilterComposer f) f,
  ) {
    final $$StorySavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storySaves,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorySavesTableFilterComposer(
            $db: $db,
            $table: $db.storySaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyWorldbooksRefs(
    Expression<bool> Function($$StoryWorldbooksTableFilterComposer f) f,
  ) {
    final $$StoryWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorldbooks,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.storyWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyWorldsRefs(
    Expression<bool> Function($$StoryWorldsTableFilterComposer f) f,
  ) {
    final $$StoryWorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorlds,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldsTableFilterComposer(
            $db: $db,
            $table: $db.storyWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worldId => $composableBuilder(
    column: $table.worldId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoriesTable> {
  $$StoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get characterId => $composableBuilder(
    column: $table.characterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get worldId =>
      $composableBuilder(column: $table.worldId, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> storyNodesRefs<T extends Object>(
    Expression<T> Function($$StoryNodesTableAnnotationComposer a) f,
  ) {
    final $$StoryNodesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyNodes,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryNodesTableAnnotationComposer(
            $db: $db,
            $table: $db.storyNodes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storySavesRefs<T extends Object>(
    Expression<T> Function($$StorySavesTableAnnotationComposer a) f,
  ) {
    final $$StorySavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storySaves,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StorySavesTableAnnotationComposer(
            $db: $db,
            $table: $db.storySaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyWorldbooksRefs<T extends Object>(
    Expression<T> Function($$StoryWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$StoryWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorldbooks,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.storyWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyWorldsRefs<T extends Object>(
    Expression<T> Function($$StoryWorldsTableAnnotationComposer a) f,
  ) {
    final $$StoryWorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorlds,
      getReferencedColumn: (t) => t.storyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.storyWorlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoriesTable,
          Story,
          $$StoriesTableFilterComposer,
          $$StoriesTableOrderingComposer,
          $$StoriesTableAnnotationComposer,
          $$StoriesTableCreateCompanionBuilder,
          $$StoriesTableUpdateCompanionBuilder,
          (Story, $$StoriesTableReferences),
          Story,
          PrefetchHooks Function({
            bool storyNodesRefs,
            bool storySavesRefs,
            bool storyWorldbooksRefs,
            bool storyWorldsRefs,
          })
        > {
  $$StoriesTableTableManager(_$AppDatabase db, $StoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> characterId = const Value.absent(),
                Value<String?> worldId = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String?> currentNodeId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoriesCompanion(
                id: id,
                name: name,
                description: description,
                characterId: characterId,
                worldId: worldId,
                coverPath: coverPath,
                currentNodeId: currentNodeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<String?> characterId = const Value.absent(),
                Value<String?> worldId = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<String?> currentNodeId = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                characterId: characterId,
                worldId: worldId,
                coverPath: coverPath,
                currentNodeId: currentNodeId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoriesTable, Story>(table),
                  $$StoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                storyNodesRefs = false,
                storySavesRefs = false,
                storyWorldbooksRefs = false,
                storyWorldsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (storyNodesRefs) db.storyNodes,
                    if (storySavesRefs) db.storySaves,
                    if (storyWorldbooksRefs) db.storyWorldbooks,
                    if (storyWorldsRefs) db.storyWorlds,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (storyNodesRefs)
                        await $_getPrefetchedData<
                          Story,
                          $StoriesTable,
                          StoryNode
                        >(
                          currentTable: table,
                          referencedTable: $$StoriesTableReferences
                              ._storyNodesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).storyNodesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.storyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storySavesRefs)
                        await $_getPrefetchedData<
                          Story,
                          $StoriesTable,
                          StorySave
                        >(
                          currentTable: table,
                          referencedTable: $$StoriesTableReferences
                              ._storySavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).storySavesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.storyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storyWorldbooksRefs)
                        await $_getPrefetchedData<
                          Story,
                          $StoriesTable,
                          StoryWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$StoriesTableReferences
                              ._storyWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).storyWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.storyId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storyWorldsRefs)
                        await $_getPrefetchedData<
                          Story,
                          $StoriesTable,
                          StoryWorld
                        >(
                          currentTable: table,
                          referencedTable: $$StoriesTableReferences
                              ._storyWorldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).storyWorldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.storyId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoriesTable,
      Story,
      $$StoriesTableFilterComposer,
      $$StoriesTableOrderingComposer,
      $$StoriesTableAnnotationComposer,
      $$StoriesTableCreateCompanionBuilder,
      $$StoriesTableUpdateCompanionBuilder,
      (Story, $$StoriesTableReferences),
      Story,
      PrefetchHooks Function({
        bool storyNodesRefs,
        bool storySavesRefs,
        bool storyWorldbooksRefs,
        bool storyWorldsRefs,
      })
    >;
typedef $$StoryNodesTableCreateCompanionBuilder = StoryNodesCompanion Function({
  required String id,
  required String storyId,
  Value<String?> parentId,
  required String narrative,
  Value<String> choicesJson,
  Value<int?> chosenIndex,
  Value<int> depth,
  required int createdAt,
  Value<int> rowid,
});
typedef $$StoryNodesTableUpdateCompanionBuilder = StoryNodesCompanion Function({
  Value<String> id,
  Value<String> storyId,
  Value<String?> parentId,
  Value<String> narrative,
  Value<String> choicesJson,
  Value<int?> chosenIndex,
  Value<int> depth,
  Value<int> createdAt,
  Value<int> rowid,
});

final class $$StoryNodesTableReferences
    extends BaseReferences<_$AppDatabase, $StoryNodesTable, StoryNode> {
  $$StoryNodesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTable _storyIdTable(_$AppDatabase db) =>
      db.stories.createAlias('story_nodes__story_id__stories__id');

  $$StoriesTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableManager(
      $_db,
      $_db.stories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryNodesTableFilterComposer
    extends Composer<_$AppDatabase, $StoryNodesTable> {
  $$StoryNodesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get narrative => $composableBuilder(
    column: $table.narrative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chosenIndex => $composableBuilder(
    column: $table.chosenIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoriesTableFilterComposer get storyId {
    final $$StoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableFilterComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryNodesTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryNodesTable> {
  $$StoryNodesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get narrative => $composableBuilder(
    column: $table.narrative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chosenIndex => $composableBuilder(
    column: $table.chosenIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get depth => $composableBuilder(
    column: $table.depth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoriesTableOrderingComposer get storyId {
    final $$StoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableOrderingComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryNodesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryNodesTable> {
  $$StoryNodesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get narrative =>
      $composableBuilder(column: $table.narrative, builder: (column) => column);

  GeneratedColumn<String> get choicesJson => $composableBuilder(
    column: $table.choicesJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chosenIndex => $composableBuilder(
    column: $table.chosenIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get depth =>
      $composableBuilder(column: $table.depth, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StoriesTableAnnotationComposer get storyId {
    final $$StoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryNodesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryNodesTable,
          StoryNode,
          $$StoryNodesTableFilterComposer,
          $$StoryNodesTableOrderingComposer,
          $$StoryNodesTableAnnotationComposer,
          $$StoryNodesTableCreateCompanionBuilder,
          $$StoryNodesTableUpdateCompanionBuilder,
          (StoryNode, $$StoryNodesTableReferences),
          StoryNode,
          PrefetchHooks Function({bool storyId})
        > {
  $$StoryNodesTableTableManager(_$AppDatabase db, $StoryNodesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryNodesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryNodesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryNodesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storyId = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> narrative = const Value.absent(),
                Value<String> choicesJson = const Value.absent(),
                Value<int?> chosenIndex = const Value.absent(),
                Value<int> depth = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryNodesCompanion(
                id: id,
                storyId: storyId,
                parentId: parentId,
                narrative: narrative,
                choicesJson: choicesJson,
                chosenIndex: chosenIndex,
                depth: depth,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storyId,
                Value<String?> parentId = const Value.absent(),
                required String narrative,
                Value<String> choicesJson = const Value.absent(),
                Value<int?> chosenIndex = const Value.absent(),
                Value<int> depth = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryNodesCompanion.insert(
                id: id,
                storyId: storyId,
                parentId: parentId,
                narrative: narrative,
                choicesJson: choicesJson,
                chosenIndex: chosenIndex,
                depth: depth,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryNodesTable, StoryNode>(table),
                  $$StoryNodesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (storyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.storyId,
                        referencedTable: $$StoryNodesTableReferences
                            ._storyIdTable(db),
                        referencedColumn: $$StoryNodesTableReferences
                            ._storyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryNodesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryNodesTable,
      StoryNode,
      $$StoryNodesTableFilterComposer,
      $$StoryNodesTableOrderingComposer,
      $$StoryNodesTableAnnotationComposer,
      $$StoryNodesTableCreateCompanionBuilder,
      $$StoryNodesTableUpdateCompanionBuilder,
      (StoryNode, $$StoryNodesTableReferences),
      StoryNode,
      PrefetchHooks Function({bool storyId})
    >;
typedef $$StorySavesTableCreateCompanionBuilder = StorySavesCompanion Function({
  required String id,
  required String storyId,
  required String label,
  Value<String?> currentNodeId,
  Value<bool> isQuick,
  required int savedAt,
  Value<int> rowid,
});
typedef $$StorySavesTableUpdateCompanionBuilder = StorySavesCompanion Function({
  Value<String> id,
  Value<String> storyId,
  Value<String> label,
  Value<String?> currentNodeId,
  Value<bool> isQuick,
  Value<int> savedAt,
  Value<int> rowid,
});

final class $$StorySavesTableReferences
    extends BaseReferences<_$AppDatabase, $StorySavesTable, StorySave> {
  $$StorySavesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTable _storyIdTable(_$AppDatabase db) =>
      db.stories.createAlias('story_saves__story_id__stories__id');

  $$StoriesTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableManager(
      $_db,
      $_db.stories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StorySavesTableFilterComposer
    extends Composer<_$AppDatabase, $StorySavesTable> {
  $$StorySavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQuick => $composableBuilder(
    column: $table.isQuick,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoriesTableFilterComposer get storyId {
    final $$StoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableFilterComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StorySavesTableOrderingComposer
    extends Composer<_$AppDatabase, $StorySavesTable> {
  $$StorySavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQuick => $composableBuilder(
    column: $table.isQuick,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoriesTableOrderingComposer get storyId {
    final $$StoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableOrderingComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StorySavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorySavesTable> {
  $$StorySavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get currentNodeId => $composableBuilder(
    column: $table.currentNodeId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isQuick =>
      $composableBuilder(column: $table.isQuick, builder: (column) => column);

  GeneratedColumn<int> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$StoriesTableAnnotationComposer get storyId {
    final $$StoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StorySavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StorySavesTable,
          StorySave,
          $$StorySavesTableFilterComposer,
          $$StorySavesTableOrderingComposer,
          $$StorySavesTableAnnotationComposer,
          $$StorySavesTableCreateCompanionBuilder,
          $$StorySavesTableUpdateCompanionBuilder,
          (StorySave, $$StorySavesTableReferences),
          StorySave,
          PrefetchHooks Function({bool storyId})
        > {
  $$StorySavesTableTableManager(_$AppDatabase db, $StorySavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorySavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorySavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorySavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storyId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> currentNodeId = const Value.absent(),
                Value<bool> isQuick = const Value.absent(),
                Value<int> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StorySavesCompanion(
                id: id,
                storyId: storyId,
                label: label,
                currentNodeId: currentNodeId,
                isQuick: isQuick,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storyId,
                required String label,
                Value<String?> currentNodeId = const Value.absent(),
                Value<bool> isQuick = const Value.absent(),
                required int savedAt,
                Value<int> rowid = const Value.absent(),
              }) => StorySavesCompanion.insert(
                id: id,
                storyId: storyId,
                label: label,
                currentNodeId: currentNodeId,
                isQuick: isQuick,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StorySavesTable, StorySave>(table),
                  $$StorySavesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (storyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.storyId,
                        referencedTable: $$StorySavesTableReferences
                            ._storyIdTable(db),
                        referencedColumn: $$StorySavesTableReferences
                            ._storyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StorySavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StorySavesTable,
      StorySave,
      $$StorySavesTableFilterComposer,
      $$StorySavesTableOrderingComposer,
      $$StorySavesTableAnnotationComposer,
      $$StorySavesTableCreateCompanionBuilder,
      $$StorySavesTableUpdateCompanionBuilder,
      (StorySave, $$StorySavesTableReferences),
      StorySave,
      PrefetchHooks Function({bool storyId})
    >;
typedef $$WorldbooksTableCreateCompanionBuilder = WorldbooksCompanion Function({
  required String id,
  required String name,
  Value<String> description,
  Value<String> bookJson,
  Value<String> sourceType,
  Value<String?> sourcePath,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$WorldbooksTableUpdateCompanionBuilder = WorldbooksCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> description,
  Value<String> bookJson,
  Value<String> sourceType,
  Value<String?> sourcePath,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

final class $$WorldbooksTableReferences
    extends BaseReferences<_$AppDatabase, $WorldbooksTable, Worldbook> {
  $$WorldbooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CharacterWorldbooksTable,
    List<CharacterWorldbook>
  >
  _characterWorldbooksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.characterWorldbooks,
        aliasName: 'worldbooks__id__character_worldbooks__worldbook_id',
      );

  $$CharacterWorldbooksTableProcessedTableManager get characterWorldbooksRefs {
    final manager = $$CharacterWorldbooksTableTableManager(
      $_db,
      $_db.characterWorldbooks,
    ).filter((f) => f.worldbookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _characterWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WorldWorldbooksTable, List<WorldWorldbook>>
  _worldWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.worldWorldbooks,
    aliasName: 'worldbooks__id__world_worldbooks__worldbook_id',
  );

  $$WorldWorldbooksTableProcessedTableManager get worldWorldbooksRefs {
    final manager = $$WorldWorldbooksTableTableManager(
      $_db,
      $_db.worldWorldbooks,
    ).filter((f) => f.worldbookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _worldWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GroupWorldbooksTable, List<GroupWorldbook>>
  _groupWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.groupWorldbooks,
    aliasName: 'worldbooks__id__group_worldbooks__worldbook_id',
  );

  $$GroupWorldbooksTableProcessedTableManager get groupWorldbooksRefs {
    final manager = $$GroupWorldbooksTableTableManager(
      $_db,
      $_db.groupWorldbooks,
    ).filter((f) => f.worldbookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _groupWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StoryWorldbooksTable, List<StoryWorldbook>>
  _storyWorldbooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.storyWorldbooks,
    aliasName: 'worldbooks__id__story_worldbooks__worldbook_id',
  );

  $$StoryWorldbooksTableProcessedTableManager get storyWorldbooksRefs {
    final manager = $$StoryWorldbooksTableTableManager(
      $_db,
      $_db.storyWorldbooks,
    ).filter((f) => f.worldbookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storyWorldbooksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorldbooksTableFilterComposer
    extends Composer<_$AppDatabase, $WorldbooksTable> {
  $$WorldbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bookJson => $composableBuilder(
    column: $table.bookJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> characterWorldbooksRefs(
    Expression<bool> Function($$CharacterWorldbooksTableFilterComposer f) f,
  ) {
    final $$CharacterWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.characterWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharacterWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.characterWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> worldWorldbooksRefs(
    Expression<bool> Function($$WorldWorldbooksTableFilterComposer f) f,
  ) {
    final $$WorldWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> groupWorldbooksRefs(
    Expression<bool> Function($$GroupWorldbooksTableFilterComposer f) f,
  ) {
    final $$GroupWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.groupWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyWorldbooksRefs(
    Expression<bool> Function($$StoryWorldbooksTableFilterComposer f) f,
  ) {
    final $$StoryWorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.storyWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldbooksTable> {
  $$WorldbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bookJson => $composableBuilder(
    column: $table.bookJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorldbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldbooksTable> {
  $$WorldbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bookJson =>
      $composableBuilder(column: $table.bookJson, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourcePath => $composableBuilder(
    column: $table.sourcePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> characterWorldbooksRefs<T extends Object>(
    Expression<T> Function($$CharacterWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$CharacterWorldbooksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.characterWorldbooks,
          getReferencedColumn: (t) => t.worldbookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CharacterWorldbooksTableAnnotationComposer(
                $db: $db,
                $table: $db.characterWorldbooks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> worldWorldbooksRefs<T extends Object>(
    Expression<T> Function($$WorldWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$WorldWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.worldWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> groupWorldbooksRefs<T extends Object>(
    Expression<T> Function($$GroupWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$GroupWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.groupWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.groupWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyWorldbooksRefs<T extends Object>(
    Expression<T> Function($$StoryWorldbooksTableAnnotationComposer a) f,
  ) {
    final $$StoryWorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.storyWorldbooks,
      getReferencedColumn: (t) => t.worldbookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoryWorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.storyWorldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorldbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldbooksTable,
          Worldbook,
          $$WorldbooksTableFilterComposer,
          $$WorldbooksTableOrderingComposer,
          $$WorldbooksTableAnnotationComposer,
          $$WorldbooksTableCreateCompanionBuilder,
          $$WorldbooksTableUpdateCompanionBuilder,
          (Worldbook, $$WorldbooksTableReferences),
          Worldbook,
          PrefetchHooks Function({
            bool characterWorldbooksRefs,
            bool worldWorldbooksRefs,
            bool groupWorldbooksRefs,
            bool storyWorldbooksRefs,
          })
        > {
  $$WorldbooksTableTableManager(_$AppDatabase db, $WorldbooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldbooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldbooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> bookJson = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourcePath = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldbooksCompanion(
                id: id,
                name: name,
                description: description,
                bookJson: bookJson,
                sourceType: sourceType,
                sourcePath: sourcePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                Value<String> bookJson = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourcePath = const Value.absent(),
                required int createdAt,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldbooksCompanion.insert(
                id: id,
                name: name,
                description: description,
                bookJson: bookJson,
                sourceType: sourceType,
                sourcePath: sourcePath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldbooksTable, Worldbook>(table),
                  $$WorldbooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                characterWorldbooksRefs = false,
                worldWorldbooksRefs = false,
                groupWorldbooksRefs = false,
                storyWorldbooksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (characterWorldbooksRefs) db.characterWorldbooks,
                    if (worldWorldbooksRefs) db.worldWorldbooks,
                    if (groupWorldbooksRefs) db.groupWorldbooks,
                    if (storyWorldbooksRefs) db.storyWorldbooks,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (characterWorldbooksRefs)
                        await $_getPrefetchedData<
                          Worldbook,
                          $WorldbooksTable,
                          CharacterWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$WorldbooksTableReferences
                              ._characterWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldbooksTableReferences(
                                db,
                                table,
                                p0,
                              ).characterWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldbookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (worldWorldbooksRefs)
                        await $_getPrefetchedData<
                          Worldbook,
                          $WorldbooksTable,
                          WorldWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$WorldbooksTableReferences
                              ._worldWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldbooksTableReferences(
                                db,
                                table,
                                p0,
                              ).worldWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldbookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (groupWorldbooksRefs)
                        await $_getPrefetchedData<
                          Worldbook,
                          $WorldbooksTable,
                          GroupWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$WorldbooksTableReferences
                              ._groupWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldbooksTableReferences(
                                db,
                                table,
                                p0,
                              ).groupWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldbookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storyWorldbooksRefs)
                        await $_getPrefetchedData<
                          Worldbook,
                          $WorldbooksTable,
                          StoryWorldbook
                        >(
                          currentTable: table,
                          referencedTable: $$WorldbooksTableReferences
                              ._storyWorldbooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldbooksTableReferences(
                                db,
                                table,
                                p0,
                              ).storyWorldbooksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldbookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorldbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldbooksTable,
      Worldbook,
      $$WorldbooksTableFilterComposer,
      $$WorldbooksTableOrderingComposer,
      $$WorldbooksTableAnnotationComposer,
      $$WorldbooksTableCreateCompanionBuilder,
      $$WorldbooksTableUpdateCompanionBuilder,
      (Worldbook, $$WorldbooksTableReferences),
      Worldbook,
      PrefetchHooks Function({
        bool characterWorldbooksRefs,
        bool worldWorldbooksRefs,
        bool groupWorldbooksRefs,
        bool storyWorldbooksRefs,
      })
    >;
typedef $$CharacterWorldbooksTableCreateCompanionBuilder =
    CharacterWorldbooksCompanion Function({
      required String characterId,
      required String worldbookId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$CharacterWorldbooksTableUpdateCompanionBuilder =
    CharacterWorldbooksCompanion Function({
      Value<String> characterId,
      Value<String> worldbookId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$CharacterWorldbooksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CharacterWorldbooksTable,
          CharacterWorldbook
        > {
  $$CharacterWorldbooksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharactersTable _characterIdTable(_$AppDatabase db) => db.characters
      .createAlias('character_worldbooks__character_id__characters__id');

  $$CharactersTableProcessedTableManager get characterId {
    final $_column = $_itemColumn<String>('character_id')!;

    final manager = $$CharactersTableTableManager(
      $_db,
      $_db.characters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_characterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldbooksTable _worldbookIdTable(_$AppDatabase db) => db.worldbooks
      .createAlias('character_worldbooks__worldbook_id__worldbooks__id');

  $$WorldbooksTableProcessedTableManager get worldbookId {
    final $_column = $_itemColumn<String>('worldbook_id')!;

    final manager = $$WorldbooksTableTableManager(
      $_db,
      $_db.worldbooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldbookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharacterWorldbooksTableFilterComposer
    extends Composer<_$AppDatabase, $CharacterWorldbooksTable> {
  $$CharacterWorldbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CharactersTableFilterComposer get characterId {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableFilterComposer get worldbookId {
    final $$WorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterWorldbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $CharacterWorldbooksTable> {
  $$CharacterWorldbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharactersTableOrderingComposer get characterId {
    final $$CharactersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableOrderingComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableOrderingComposer get worldbookId {
    final $$WorldbooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableOrderingComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterWorldbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharacterWorldbooksTable> {
  $$CharacterWorldbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CharactersTableAnnotationComposer get characterId {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.characterId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableAnnotationComposer get worldbookId {
    final $$WorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharacterWorldbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharacterWorldbooksTable,
          CharacterWorldbook,
          $$CharacterWorldbooksTableFilterComposer,
          $$CharacterWorldbooksTableOrderingComposer,
          $$CharacterWorldbooksTableAnnotationComposer,
          $$CharacterWorldbooksTableCreateCompanionBuilder,
          $$CharacterWorldbooksTableUpdateCompanionBuilder,
          (CharacterWorldbook, $$CharacterWorldbooksTableReferences),
          CharacterWorldbook,
          PrefetchHooks Function({bool characterId, bool worldbookId})
        > {
  $$CharacterWorldbooksTableTableManager(
    _$AppDatabase db,
    $CharacterWorldbooksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharacterWorldbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharacterWorldbooksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharacterWorldbooksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> characterId = const Value.absent(),
                Value<String> worldbookId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharacterWorldbooksCompanion(
                characterId: characterId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String characterId,
                required String worldbookId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CharacterWorldbooksCompanion.insert(
                characterId: characterId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharacterWorldbooksTable, CharacterWorldbook>(
                    table,
                  ),
                  $$CharacterWorldbooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({characterId = false, worldbookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (characterId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.characterId,
                        referencedTable: $$CharacterWorldbooksTableReferences
                            ._characterIdTable(db),
                        referencedColumn: $$CharacterWorldbooksTableReferences
                            ._characterIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldbookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldbookId,
                        referencedTable: $$CharacterWorldbooksTableReferences
                            ._worldbookIdTable(db),
                        referencedColumn: $$CharacterWorldbooksTableReferences
                            ._worldbookIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CharacterWorldbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharacterWorldbooksTable,
      CharacterWorldbook,
      $$CharacterWorldbooksTableFilterComposer,
      $$CharacterWorldbooksTableOrderingComposer,
      $$CharacterWorldbooksTableAnnotationComposer,
      $$CharacterWorldbooksTableCreateCompanionBuilder,
      $$CharacterWorldbooksTableUpdateCompanionBuilder,
      (CharacterWorldbook, $$CharacterWorldbooksTableReferences),
      CharacterWorldbook,
      PrefetchHooks Function({bool characterId, bool worldbookId})
    >;
typedef $$WorldWorldbooksTableCreateCompanionBuilder =
    WorldWorldbooksCompanion Function({
      required String worldId,
      required String worldbookId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$WorldWorldbooksTableUpdateCompanionBuilder =
    WorldWorldbooksCompanion Function({
      Value<String> worldId,
      Value<String> worldbookId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$WorldWorldbooksTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorldWorldbooksTable, WorldWorldbook> {
  $$WorldWorldbooksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('world_worldbooks__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldbooksTable _worldbookIdTable(_$AppDatabase db) => db.worldbooks
      .createAlias('world_worldbooks__worldbook_id__worldbooks__id');

  $$WorldbooksTableProcessedTableManager get worldbookId {
    final $_column = $_itemColumn<String>('worldbook_id')!;

    final manager = $$WorldbooksTableTableManager(
      $_db,
      $_db.worldbooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldbookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorldWorldbooksTableFilterComposer
    extends Composer<_$AppDatabase, $WorldWorldbooksTable> {
  $$WorldWorldbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableFilterComposer get worldbookId {
    final $$WorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldWorldbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldWorldbooksTable> {
  $$WorldWorldbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableOrderingComposer get worldbookId {
    final $$WorldbooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableOrderingComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldWorldbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldWorldbooksTable> {
  $$WorldWorldbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableAnnotationComposer get worldbookId {
    final $$WorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorldWorldbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldWorldbooksTable,
          WorldWorldbook,
          $$WorldWorldbooksTableFilterComposer,
          $$WorldWorldbooksTableOrderingComposer,
          $$WorldWorldbooksTableAnnotationComposer,
          $$WorldWorldbooksTableCreateCompanionBuilder,
          $$WorldWorldbooksTableUpdateCompanionBuilder,
          (WorldWorldbook, $$WorldWorldbooksTableReferences),
          WorldWorldbook,
          PrefetchHooks Function({bool worldId, bool worldbookId})
        > {
  $$WorldWorldbooksTableTableManager(
    _$AppDatabase db,
    $WorldWorldbooksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldWorldbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldWorldbooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldWorldbooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> worldId = const Value.absent(),
                Value<String> worldbookId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldWorldbooksCompanion(
                worldId: worldId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String worldId,
                required String worldbookId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => WorldWorldbooksCompanion.insert(
                worldId: worldId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorldWorldbooksTable, WorldWorldbook>(table),
                  $$WorldWorldbooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldId = false, worldbookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$WorldWorldbooksTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$WorldWorldbooksTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldbookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldbookId,
                        referencedTable: $$WorldWorldbooksTableReferences
                            ._worldbookIdTable(db),
                        referencedColumn: $$WorldWorldbooksTableReferences
                            ._worldbookIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorldWorldbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldWorldbooksTable,
      WorldWorldbook,
      $$WorldWorldbooksTableFilterComposer,
      $$WorldWorldbooksTableOrderingComposer,
      $$WorldWorldbooksTableAnnotationComposer,
      $$WorldWorldbooksTableCreateCompanionBuilder,
      $$WorldWorldbooksTableUpdateCompanionBuilder,
      (WorldWorldbook, $$WorldWorldbooksTableReferences),
      WorldWorldbook,
      PrefetchHooks Function({bool worldId, bool worldbookId})
    >;
typedef $$GroupWorldbooksTableCreateCompanionBuilder =
    GroupWorldbooksCompanion Function({
      required String groupId,
      required String worldbookId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$GroupWorldbooksTableUpdateCompanionBuilder =
    GroupWorldbooksCompanion Function({
      Value<String> groupId,
      Value<String> worldbookId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$GroupWorldbooksTableReferences
    extends
        BaseReferences<_$AppDatabase, $GroupWorldbooksTable, GroupWorldbook> {
  $$GroupWorldbooksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_worldbooks__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldbooksTable _worldbookIdTable(_$AppDatabase db) => db.worldbooks
      .createAlias('group_worldbooks__worldbook_id__worldbooks__id');

  $$WorldbooksTableProcessedTableManager get worldbookId {
    final $_column = $_itemColumn<String>('worldbook_id')!;

    final manager = $$WorldbooksTableTableManager(
      $_db,
      $_db.worldbooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldbookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupWorldbooksTableFilterComposer
    extends Composer<_$AppDatabase, $GroupWorldbooksTable> {
  $$GroupWorldbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableFilterComposer get worldbookId {
    final $$WorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupWorldbooksTable> {
  $$GroupWorldbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableOrderingComposer get worldbookId {
    final $$WorldbooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableOrderingComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupWorldbooksTable> {
  $$GroupWorldbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableAnnotationComposer get worldbookId {
    final $$WorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupWorldbooksTable,
          GroupWorldbook,
          $$GroupWorldbooksTableFilterComposer,
          $$GroupWorldbooksTableOrderingComposer,
          $$GroupWorldbooksTableAnnotationComposer,
          $$GroupWorldbooksTableCreateCompanionBuilder,
          $$GroupWorldbooksTableUpdateCompanionBuilder,
          (GroupWorldbook, $$GroupWorldbooksTableReferences),
          GroupWorldbook,
          PrefetchHooks Function({bool groupId, bool worldbookId})
        > {
  $$GroupWorldbooksTableTableManager(
    _$AppDatabase db,
    $GroupWorldbooksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupWorldbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupWorldbooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupWorldbooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> worldbookId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupWorldbooksCompanion(
                groupId: groupId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String worldbookId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupWorldbooksCompanion.insert(
                groupId: groupId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupWorldbooksTable, GroupWorldbook>(table),
                  $$GroupWorldbooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, worldbookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupWorldbooksTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupWorldbooksTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldbookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldbookId,
                        referencedTable: $$GroupWorldbooksTableReferences
                            ._worldbookIdTable(db),
                        referencedColumn: $$GroupWorldbooksTableReferences
                            ._worldbookIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupWorldbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupWorldbooksTable,
      GroupWorldbook,
      $$GroupWorldbooksTableFilterComposer,
      $$GroupWorldbooksTableOrderingComposer,
      $$GroupWorldbooksTableAnnotationComposer,
      $$GroupWorldbooksTableCreateCompanionBuilder,
      $$GroupWorldbooksTableUpdateCompanionBuilder,
      (GroupWorldbook, $$GroupWorldbooksTableReferences),
      GroupWorldbook,
      PrefetchHooks Function({bool groupId, bool worldbookId})
    >;
typedef $$StoryWorldbooksTableCreateCompanionBuilder =
    StoryWorldbooksCompanion Function({
      required String storyId,
      required String worldbookId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$StoryWorldbooksTableUpdateCompanionBuilder =
    StoryWorldbooksCompanion Function({
      Value<String> storyId,
      Value<String> worldbookId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$StoryWorldbooksTableReferences
    extends
        BaseReferences<_$AppDatabase, $StoryWorldbooksTable, StoryWorldbook> {
  $$StoryWorldbooksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StoriesTable _storyIdTable(_$AppDatabase db) =>
      db.stories.createAlias('story_worldbooks__story_id__stories__id');

  $$StoriesTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableManager(
      $_db,
      $_db.stories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldbooksTable _worldbookIdTable(_$AppDatabase db) => db.worldbooks
      .createAlias('story_worldbooks__worldbook_id__worldbooks__id');

  $$WorldbooksTableProcessedTableManager get worldbookId {
    final $_column = $_itemColumn<String>('worldbook_id')!;

    final manager = $$WorldbooksTableTableManager(
      $_db,
      $_db.worldbooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldbookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryWorldbooksTableFilterComposer
    extends Composer<_$AppDatabase, $StoryWorldbooksTable> {
  $$StoryWorldbooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoriesTableFilterComposer get storyId {
    final $$StoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableFilterComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableFilterComposer get worldbookId {
    final $$WorldbooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableFilterComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldbooksTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryWorldbooksTable> {
  $$StoryWorldbooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoriesTableOrderingComposer get storyId {
    final $$StoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableOrderingComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableOrderingComposer get worldbookId {
    final $$WorldbooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableOrderingComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldbooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryWorldbooksTable> {
  $$StoryWorldbooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StoriesTableAnnotationComposer get storyId {
    final $$StoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldbooksTableAnnotationComposer get worldbookId {
    final $$WorldbooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldbookId,
      referencedTable: $db.worldbooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldbooksTableAnnotationComposer(
            $db: $db,
            $table: $db.worldbooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldbooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryWorldbooksTable,
          StoryWorldbook,
          $$StoryWorldbooksTableFilterComposer,
          $$StoryWorldbooksTableOrderingComposer,
          $$StoryWorldbooksTableAnnotationComposer,
          $$StoryWorldbooksTableCreateCompanionBuilder,
          $$StoryWorldbooksTableUpdateCompanionBuilder,
          (StoryWorldbook, $$StoryWorldbooksTableReferences),
          StoryWorldbook,
          PrefetchHooks Function({bool storyId, bool worldbookId})
        > {
  $$StoryWorldbooksTableTableManager(
    _$AppDatabase db,
    $StoryWorldbooksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryWorldbooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryWorldbooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryWorldbooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storyId = const Value.absent(),
                Value<String> worldbookId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryWorldbooksCompanion(
                storyId: storyId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storyId,
                required String worldbookId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryWorldbooksCompanion.insert(
                storyId: storyId,
                worldbookId: worldbookId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryWorldbooksTable, StoryWorldbook>(table),
                  $$StoryWorldbooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storyId = false, worldbookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (storyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.storyId,
                        referencedTable: $$StoryWorldbooksTableReferences
                            ._storyIdTable(db),
                        referencedColumn: $$StoryWorldbooksTableReferences
                            ._storyIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldbookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldbookId,
                        referencedTable: $$StoryWorldbooksTableReferences
                            ._worldbookIdTable(db),
                        referencedColumn: $$StoryWorldbooksTableReferences
                            ._worldbookIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryWorldbooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryWorldbooksTable,
      StoryWorldbook,
      $$StoryWorldbooksTableFilterComposer,
      $$StoryWorldbooksTableOrderingComposer,
      $$StoryWorldbooksTableAnnotationComposer,
      $$StoryWorldbooksTableCreateCompanionBuilder,
      $$StoryWorldbooksTableUpdateCompanionBuilder,
      (StoryWorldbook, $$StoryWorldbooksTableReferences),
      StoryWorldbook,
      PrefetchHooks Function({bool storyId, bool worldbookId})
    >;
typedef $$GroupWorldsTableCreateCompanionBuilder =
    GroupWorldsCompanion Function({
      required String groupId,
      required String worldId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$GroupWorldsTableUpdateCompanionBuilder =
    GroupWorldsCompanion Function({
      Value<String> groupId,
      Value<String> worldId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$GroupWorldsTableReferences
    extends BaseReferences<_$AppDatabase, $GroupWorldsTable, GroupWorld> {
  $$GroupWorldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupsTable _groupIdTable(_$AppDatabase db) =>
      db.groups.createAlias('group_worlds__group_id__groups__id');

  $$GroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$GroupsTableTableManager(
      $_db,
      $_db.groups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('group_worlds__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GroupWorldsTableFilterComposer
    extends Composer<_$AppDatabase, $GroupWorldsTable> {
  $$GroupWorldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupsTableFilterComposer get groupId {
    final $$GroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableFilterComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldsTableOrderingComposer
    extends Composer<_$AppDatabase, $GroupWorldsTable> {
  $$GroupWorldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupsTableOrderingComposer get groupId {
    final $$GroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableOrderingComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GroupWorldsTable> {
  $$GroupWorldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$GroupsTableAnnotationComposer get groupId {
    final $$GroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.groups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.groups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GroupWorldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GroupWorldsTable,
          GroupWorld,
          $$GroupWorldsTableFilterComposer,
          $$GroupWorldsTableOrderingComposer,
          $$GroupWorldsTableAnnotationComposer,
          $$GroupWorldsTableCreateCompanionBuilder,
          $$GroupWorldsTableUpdateCompanionBuilder,
          (GroupWorld, $$GroupWorldsTableReferences),
          GroupWorld,
          PrefetchHooks Function({bool groupId, bool worldId})
        > {
  $$GroupWorldsTableTableManager(_$AppDatabase db, $GroupWorldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupWorldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupWorldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupWorldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> groupId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GroupWorldsCompanion(
                groupId: groupId,
                worldId: worldId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String groupId,
                required String worldId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GroupWorldsCompanion.insert(
                groupId: groupId,
                worldId: worldId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GroupWorldsTable, GroupWorld>(table),
                  $$GroupWorldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (groupId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.groupId,
                        referencedTable: $$GroupWorldsTableReferences
                            ._groupIdTable(db),
                        referencedColumn: $$GroupWorldsTableReferences
                            ._groupIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$GroupWorldsTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$GroupWorldsTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GroupWorldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GroupWorldsTable,
      GroupWorld,
      $$GroupWorldsTableFilterComposer,
      $$GroupWorldsTableOrderingComposer,
      $$GroupWorldsTableAnnotationComposer,
      $$GroupWorldsTableCreateCompanionBuilder,
      $$GroupWorldsTableUpdateCompanionBuilder,
      (GroupWorld, $$GroupWorldsTableReferences),
      GroupWorld,
      PrefetchHooks Function({bool groupId, bool worldId})
    >;
typedef $$StoryWorldsTableCreateCompanionBuilder =
    StoryWorldsCompanion Function({
      required String storyId,
      required String worldId,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$StoryWorldsTableUpdateCompanionBuilder =
    StoryWorldsCompanion Function({
      Value<String> storyId,
      Value<String> worldId,
      Value<int> createdAt,
      Value<int> rowid,
    });

final class $$StoryWorldsTableReferences
    extends BaseReferences<_$AppDatabase, $StoryWorldsTable, StoryWorld> {
  $$StoryWorldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StoriesTable _storyIdTable(_$AppDatabase db) =>
      db.stories.createAlias('story_worlds__story_id__stories__id');

  $$StoriesTableProcessedTableManager get storyId {
    final $_column = $_itemColumn<String>('story_id')!;

    final manager = $$StoriesTableTableManager(
      $_db,
      $_db.stories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorldsTable _worldIdTable(_$AppDatabase db) =>
      db.worlds.createAlias('story_worlds__world_id__worlds__id');

  $$WorldsTableProcessedTableManager get worldId {
    final $_column = $_itemColumn<String>('world_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryWorldsTableFilterComposer
    extends Composer<_$AppDatabase, $StoryWorldsTable> {
  $$StoryWorldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StoriesTableFilterComposer get storyId {
    final $$StoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableFilterComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableFilterComposer get worldId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryWorldsTable> {
  $$StoryWorldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StoriesTableOrderingComposer get storyId {
    final $$StoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableOrderingComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableOrderingComposer get worldId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryWorldsTable> {
  $$StoryWorldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StoriesTableAnnotationComposer get storyId {
    final $$StoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.storyId,
      referencedTable: $db.stories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.stories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorldsTableAnnotationComposer get worldId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryWorldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryWorldsTable,
          StoryWorld,
          $$StoryWorldsTableFilterComposer,
          $$StoryWorldsTableOrderingComposer,
          $$StoryWorldsTableAnnotationComposer,
          $$StoryWorldsTableCreateCompanionBuilder,
          $$StoryWorldsTableUpdateCompanionBuilder,
          (StoryWorld, $$StoryWorldsTableReferences),
          StoryWorld,
          PrefetchHooks Function({bool storyId, bool worldId})
        > {
  $$StoryWorldsTableTableManager(_$AppDatabase db, $StoryWorldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryWorldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoryWorldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoryWorldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storyId = const Value.absent(),
                Value<String> worldId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryWorldsCompanion(
                storyId: storyId,
                worldId: worldId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storyId,
                required String worldId,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryWorldsCompanion.insert(
                storyId: storyId,
                worldId: worldId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoryWorldsTable, StoryWorld>(table),
                  $$StoryWorldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({storyId = false, worldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (storyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.storyId,
                        referencedTable: $$StoryWorldsTableReferences
                            ._storyIdTable(db),
                        referencedColumn: $$StoryWorldsTableReferences
                            ._storyIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (worldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.worldId,
                        referencedTable: $$StoryWorldsTableReferences
                            ._worldIdTable(db),
                        referencedColumn: $$StoryWorldsTableReferences
                            ._worldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryWorldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryWorldsTable,
      StoryWorld,
      $$StoryWorldsTableFilterComposer,
      $$StoryWorldsTableOrderingComposer,
      $$StoryWorldsTableAnnotationComposer,
      $$StoryWorldsTableCreateCompanionBuilder,
      $$StoryWorldsTableUpdateCompanionBuilder,
      (StoryWorld, $$StoryWorldsTableReferences),
      StoryWorld,
      PrefetchHooks Function({bool storyId, bool worldId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$CharacterAdaptationsTableTableManager get characterAdaptations =>
      $$CharacterAdaptationsTableTableManager(_db, _db.characterAdaptations);
  $$WorldsTableTableManager get worlds =>
      $$WorldsTableTableManager(_db, _db.worlds);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$SessionStatesTableTableManager get sessionStates =>
      $$SessionStatesTableTableManager(_db, _db.sessionStates);
  $$CharacterRelationsTableTableManager get characterRelations =>
      $$CharacterRelationsTableTableManager(_db, _db.characterRelations);
  $$CharacterAffinitiesTableTableManager get characterAffinities =>
      $$CharacterAffinitiesTableTableManager(_db, _db.characterAffinities);
  $$CharacterMemoriesTableTableManager get characterMemories =>
      $$CharacterMemoriesTableTableManager(_db, _db.characterMemories);
  $$ProviderConfigsTableTableManager get providerConfigs =>
      $$ProviderConfigsTableTableManager(_db, _db.providerConfigs);
  $$PresetsTableTableManager get presets =>
      $$PresetsTableTableManager(_db, _db.presets);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$GroupsTableTableManager get groups =>
      $$GroupsTableTableManager(_db, _db.groups);
  $$GroupMembersTableTableManager get groupMembers =>
      $$GroupMembersTableTableManager(_db, _db.groupMembers);
  $$GroupMessagesTableTableManager get groupMessages =>
      $$GroupMessagesTableTableManager(_db, _db.groupMessages);
  $$PairRelationsTableTableManager get pairRelations =>
      $$PairRelationsTableTableManager(_db, _db.pairRelations);
  $$GroupMemoriesTableTableManager get groupMemories =>
      $$GroupMemoriesTableTableManager(_db, _db.groupMemories);
  $$StoriesTableTableManager get stories =>
      $$StoriesTableTableManager(_db, _db.stories);
  $$StoryNodesTableTableManager get storyNodes =>
      $$StoryNodesTableTableManager(_db, _db.storyNodes);
  $$StorySavesTableTableManager get storySaves =>
      $$StorySavesTableTableManager(_db, _db.storySaves);
  $$WorldbooksTableTableManager get worldbooks =>
      $$WorldbooksTableTableManager(_db, _db.worldbooks);
  $$CharacterWorldbooksTableTableManager get characterWorldbooks =>
      $$CharacterWorldbooksTableTableManager(_db, _db.characterWorldbooks);
  $$WorldWorldbooksTableTableManager get worldWorldbooks =>
      $$WorldWorldbooksTableTableManager(_db, _db.worldWorldbooks);
  $$GroupWorldbooksTableTableManager get groupWorldbooks =>
      $$GroupWorldbooksTableTableManager(_db, _db.groupWorldbooks);
  $$StoryWorldbooksTableTableManager get storyWorldbooks =>
      $$StoryWorldbooksTableTableManager(_db, _db.storyWorldbooks);
  $$GroupWorldsTableTableManager get groupWorlds =>
      $$GroupWorldsTableTableManager(_db, _db.groupWorlds);
  $$StoryWorldsTableTableManager get storyWorlds =>
      $$StoryWorldsTableTableManager(_db, _db.storyWorlds);
}
