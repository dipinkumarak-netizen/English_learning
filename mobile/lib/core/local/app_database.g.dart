// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedCoursesTable extends CachedCourses
    with TableInfo<$CachedCoursesTable, CachedCourse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCoursesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isStaleMeta = const VerificationMeta(
    'isStale',
  );
  @override
  late final GeneratedColumn<bool> isStale = GeneratedColumn<bool>(
    'is_stale',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_stale" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    payload,
    contentVersion,
    cachedAt,
    isStale,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_courses';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCourse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentVersionMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    if (data.containsKey('is_stale')) {
      context.handle(
        _isStaleMeta,
        isStale.isAcceptableOrUnknown(data['is_stale']!, _isStaleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCourse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCourse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
      isStale: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_stale'],
      )!,
    );
  }

  @override
  $CachedCoursesTable createAlias(String alias) {
    return $CachedCoursesTable(attachedDatabase, alias);
  }
}

class CachedCourse extends DataClass implements Insertable<CachedCourse> {
  final String id;
  final String payload;
  final int contentVersion;
  final DateTime cachedAt;
  final bool isStale;
  const CachedCourse({
    required this.id,
    required this.payload,
    required this.contentVersion,
    required this.cachedAt,
    required this.isStale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['content_version'] = Variable<int>(contentVersion);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['is_stale'] = Variable<bool>(isStale);
    return map;
  }

  CachedCoursesCompanion toCompanion(bool nullToAbsent) {
    return CachedCoursesCompanion(
      id: Value(id),
      payload: Value(payload),
      contentVersion: Value(contentVersion),
      cachedAt: Value(cachedAt),
      isStale: Value(isStale),
    );
  }

  factory CachedCourse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCourse(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      isStale: serializer.fromJson<bool>(json['isStale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'contentVersion': serializer.toJson<int>(contentVersion),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'isStale': serializer.toJson<bool>(isStale),
    };
  }

  CachedCourse copyWith({
    String? id,
    String? payload,
    int? contentVersion,
    DateTime? cachedAt,
    bool? isStale,
  }) => CachedCourse(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    contentVersion: contentVersion ?? this.contentVersion,
    cachedAt: cachedAt ?? this.cachedAt,
    isStale: isStale ?? this.isStale,
  );
  CachedCourse copyWithCompanion(CachedCoursesCompanion data) {
    return CachedCourse(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      isStale: data.isStale.present ? data.isStale.value : this.isStale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCourse(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isStale: $isStale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, payload, contentVersion, cachedAt, isStale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCourse &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.contentVersion == this.contentVersion &&
          other.cachedAt == this.cachedAt &&
          other.isStale == this.isStale);
}

class CachedCoursesCompanion extends UpdateCompanion<CachedCourse> {
  final Value<String> id;
  final Value<String> payload;
  final Value<int> contentVersion;
  final Value<DateTime> cachedAt;
  final Value<bool> isStale;
  final Value<int> rowid;
  const CachedCoursesCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.isStale = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCoursesCompanion.insert({
    required String id,
    required String payload,
    required int contentVersion,
    required DateTime cachedAt,
    this.isStale = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       contentVersion = Value(contentVersion),
       cachedAt = Value(cachedAt);
  static Insertable<CachedCourse> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<int>? contentVersion,
    Expression<DateTime>? cachedAt,
    Expression<bool>? isStale,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (contentVersion != null) 'content_version': contentVersion,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (isStale != null) 'is_stale': isStale,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCoursesCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<int>? contentVersion,
    Value<DateTime>? cachedAt,
    Value<bool>? isStale,
    Value<int>? rowid,
  }) {
    return CachedCoursesCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      contentVersion: contentVersion ?? this.contentVersion,
      cachedAt: cachedAt ?? this.cachedAt,
      isStale: isStale ?? this.isStale,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (isStale.present) {
      map['is_stale'] = Variable<bool>(isStale.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCoursesCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isStale: $isStale, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedModulesTable extends CachedModules
    with TableInfo<$CachedModulesTable, CachedModule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedModulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, courseId, payload, contentVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_modules';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedModule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedModule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedModule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
    );
  }

  @override
  $CachedModulesTable createAlias(String alias) {
    return $CachedModulesTable(attachedDatabase, alias);
  }
}

class CachedModule extends DataClass implements Insertable<CachedModule> {
  final String id;
  final String courseId;
  final String payload;
  final int contentVersion;
  const CachedModule({
    required this.id,
    required this.courseId,
    required this.payload,
    required this.contentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['course_id'] = Variable<String>(courseId);
    map['payload'] = Variable<String>(payload);
    map['content_version'] = Variable<int>(contentVersion);
    return map;
  }

  CachedModulesCompanion toCompanion(bool nullToAbsent) {
    return CachedModulesCompanion(
      id: Value(id),
      courseId: Value(courseId),
      payload: Value(payload),
      contentVersion: Value(contentVersion),
    );
  }

  factory CachedModule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedModule(
      id: serializer.fromJson<String>(json['id']),
      courseId: serializer.fromJson<String>(json['courseId']),
      payload: serializer.fromJson<String>(json['payload']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'courseId': serializer.toJson<String>(courseId),
      'payload': serializer.toJson<String>(payload),
      'contentVersion': serializer.toJson<int>(contentVersion),
    };
  }

  CachedModule copyWith({
    String? id,
    String? courseId,
    String? payload,
    int? contentVersion,
  }) => CachedModule(
    id: id ?? this.id,
    courseId: courseId ?? this.courseId,
    payload: payload ?? this.payload,
    contentVersion: contentVersion ?? this.contentVersion,
  );
  CachedModule copyWithCompanion(CachedModulesCompanion data) {
    return CachedModule(
      id: data.id.present ? data.id.value : this.id,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      payload: data.payload.present ? data.payload.value : this.payload,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedModule(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, courseId, payload, contentVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedModule &&
          other.id == this.id &&
          other.courseId == this.courseId &&
          other.payload == this.payload &&
          other.contentVersion == this.contentVersion);
}

class CachedModulesCompanion extends UpdateCompanion<CachedModule> {
  final Value<String> id;
  final Value<String> courseId;
  final Value<String> payload;
  final Value<int> contentVersion;
  final Value<int> rowid;
  const CachedModulesCompanion({
    this.id = const Value.absent(),
    this.courseId = const Value.absent(),
    this.payload = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedModulesCompanion.insert({
    required String id,
    required String courseId,
    required String payload,
    required int contentVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       courseId = Value(courseId),
       payload = Value(payload),
       contentVersion = Value(contentVersion);
  static Insertable<CachedModule> custom({
    Expression<String>? id,
    Expression<String>? courseId,
    Expression<String>? payload,
    Expression<int>? contentVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (courseId != null) 'course_id': courseId,
      if (payload != null) 'payload': payload,
      if (contentVersion != null) 'content_version': contentVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedModulesCompanion copyWith({
    Value<String>? id,
    Value<String>? courseId,
    Value<String>? payload,
    Value<int>? contentVersion,
    Value<int>? rowid,
  }) {
    return CachedModulesCompanion(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      payload: payload ?? this.payload,
      contentVersion: contentVersion ?? this.contentVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedModulesCompanion(')
          ..write('id: $id, ')
          ..write('courseId: $courseId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedLessonsTable extends CachedLessons
    with TableInfo<$CachedLessonsTable, CachedLesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedLessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, moduleId, payload, contentVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedLesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedLesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedLesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
    );
  }

  @override
  $CachedLessonsTable createAlias(String alias) {
    return $CachedLessonsTable(attachedDatabase, alias);
  }
}

class CachedLesson extends DataClass implements Insertable<CachedLesson> {
  final String id;
  final String moduleId;
  final String payload;
  final int contentVersion;
  const CachedLesson({
    required this.id,
    required this.moduleId,
    required this.payload,
    required this.contentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['module_id'] = Variable<String>(moduleId);
    map['payload'] = Variable<String>(payload);
    map['content_version'] = Variable<int>(contentVersion);
    return map;
  }

  CachedLessonsCompanion toCompanion(bool nullToAbsent) {
    return CachedLessonsCompanion(
      id: Value(id),
      moduleId: Value(moduleId),
      payload: Value(payload),
      contentVersion: Value(contentVersion),
    );
  }

  factory CachedLesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedLesson(
      id: serializer.fromJson<String>(json['id']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      payload: serializer.fromJson<String>(json['payload']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'moduleId': serializer.toJson<String>(moduleId),
      'payload': serializer.toJson<String>(payload),
      'contentVersion': serializer.toJson<int>(contentVersion),
    };
  }

  CachedLesson copyWith({
    String? id,
    String? moduleId,
    String? payload,
    int? contentVersion,
  }) => CachedLesson(
    id: id ?? this.id,
    moduleId: moduleId ?? this.moduleId,
    payload: payload ?? this.payload,
    contentVersion: contentVersion ?? this.contentVersion,
  );
  CachedLesson copyWithCompanion(CachedLessonsCompanion data) {
    return CachedLesson(
      id: data.id.present ? data.id.value : this.id,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      payload: data.payload.present ? data.payload.value : this.payload,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedLesson(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, moduleId, payload, contentVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedLesson &&
          other.id == this.id &&
          other.moduleId == this.moduleId &&
          other.payload == this.payload &&
          other.contentVersion == this.contentVersion);
}

class CachedLessonsCompanion extends UpdateCompanion<CachedLesson> {
  final Value<String> id;
  final Value<String> moduleId;
  final Value<String> payload;
  final Value<int> contentVersion;
  final Value<int> rowid;
  const CachedLessonsCompanion({
    this.id = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.payload = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedLessonsCompanion.insert({
    required String id,
    required String moduleId,
    required String payload,
    required int contentVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       moduleId = Value(moduleId),
       payload = Value(payload),
       contentVersion = Value(contentVersion);
  static Insertable<CachedLesson> custom({
    Expression<String>? id,
    Expression<String>? moduleId,
    Expression<String>? payload,
    Expression<int>? contentVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (moduleId != null) 'module_id': moduleId,
      if (payload != null) 'payload': payload,
      if (contentVersion != null) 'content_version': contentVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedLessonsCompanion copyWith({
    Value<String>? id,
    Value<String>? moduleId,
    Value<String>? payload,
    Value<int>? contentVersion,
    Value<int>? rowid,
  }) {
    return CachedLessonsCompanion(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      payload: payload ?? this.payload,
      contentVersion: contentVersion ?? this.contentVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedLessonsCompanion(')
          ..write('id: $id, ')
          ..write('moduleId: $moduleId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedLessonStepsTable extends CachedLessonSteps
    with TableInfo<$CachedLessonStepsTable, CachedLessonStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedLessonStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentVersionMeta = const VerificationMeta(
    'contentVersion',
  );
  @override
  late final GeneratedColumn<int> contentVersion = GeneratedColumn<int>(
    'content_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, payload, contentVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_lesson_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedLessonStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('content_version')) {
      context.handle(
        _contentVersionMeta,
        contentVersion.isAcceptableOrUnknown(
          data['content_version']!,
          _contentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedLessonStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedLessonStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      contentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_version'],
      )!,
    );
  }

  @override
  $CachedLessonStepsTable createAlias(String alias) {
    return $CachedLessonStepsTable(attachedDatabase, alias);
  }
}

class CachedLessonStep extends DataClass
    implements Insertable<CachedLessonStep> {
  final String id;
  final String lessonId;
  final String payload;
  final int contentVersion;
  const CachedLessonStep({
    required this.id,
    required this.lessonId,
    required this.payload,
    required this.contentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lesson_id'] = Variable<String>(lessonId);
    map['payload'] = Variable<String>(payload);
    map['content_version'] = Variable<int>(contentVersion);
    return map;
  }

  CachedLessonStepsCompanion toCompanion(bool nullToAbsent) {
    return CachedLessonStepsCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      payload: Value(payload),
      contentVersion: Value(contentVersion),
    );
  }

  factory CachedLessonStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedLessonStep(
      id: serializer.fromJson<String>(json['id']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      payload: serializer.fromJson<String>(json['payload']),
      contentVersion: serializer.fromJson<int>(json['contentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lessonId': serializer.toJson<String>(lessonId),
      'payload': serializer.toJson<String>(payload),
      'contentVersion': serializer.toJson<int>(contentVersion),
    };
  }

  CachedLessonStep copyWith({
    String? id,
    String? lessonId,
    String? payload,
    int? contentVersion,
  }) => CachedLessonStep(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    payload: payload ?? this.payload,
    contentVersion: contentVersion ?? this.contentVersion,
  );
  CachedLessonStep copyWithCompanion(CachedLessonStepsCompanion data) {
    return CachedLessonStep(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      payload: data.payload.present ? data.payload.value : this.payload,
      contentVersion: data.contentVersion.present
          ? data.contentVersion.value
          : this.contentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedLessonStep(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, payload, contentVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedLessonStep &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.payload == this.payload &&
          other.contentVersion == this.contentVersion);
}

class CachedLessonStepsCompanion extends UpdateCompanion<CachedLessonStep> {
  final Value<String> id;
  final Value<String> lessonId;
  final Value<String> payload;
  final Value<int> contentVersion;
  final Value<int> rowid;
  const CachedLessonStepsCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.payload = const Value.absent(),
    this.contentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedLessonStepsCompanion.insert({
    required String id,
    required String lessonId,
    required String payload,
    required int contentVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lessonId = Value(lessonId),
       payload = Value(payload),
       contentVersion = Value(contentVersion);
  static Insertable<CachedLessonStep> custom({
    Expression<String>? id,
    Expression<String>? lessonId,
    Expression<String>? payload,
    Expression<int>? contentVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (payload != null) 'payload': payload,
      if (contentVersion != null) 'content_version': contentVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedLessonStepsCompanion copyWith({
    Value<String>? id,
    Value<String>? lessonId,
    Value<String>? payload,
    Value<int>? contentVersion,
    Value<int>? rowid,
  }) {
    return CachedLessonStepsCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      payload: payload ?? this.payload,
      contentVersion: contentVersion ?? this.contentVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (contentVersion.present) {
      map['content_version'] = Variable<int>(contentVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedLessonStepsCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('payload: $payload, ')
          ..write('contentVersion: $contentVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLessonProgressTable extends LocalLessonProgress
    with TableInfo<$LocalLessonProgressTable, LocalLessonProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLessonProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStepIdMeta = const VerificationMeta(
    'currentStepId',
  );
  @override
  late final GeneratedColumn<String> currentStepId = GeneratedColumn<String>(
    'current_step_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedStepIdsMeta = const VerificationMeta(
    'completedStepIds',
  );
  @override
  late final GeneratedColumn<String> completedStepIds = GeneratedColumn<String>(
    'completed_step_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<String> syncState = GeneratedColumn<String>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local-only'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    lessonId,
    currentStepId,
    completedStepIds,
    score,
    syncState,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_lesson_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLessonProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('current_step_id')) {
      context.handle(
        _currentStepIdMeta,
        currentStepId.isAcceptableOrUnknown(
          data['current_step_id']!,
          _currentStepIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_step_ids')) {
      context.handle(
        _completedStepIdsMeta,
        completedStepIds.isAcceptableOrUnknown(
          data['completed_step_ids']!,
          _completedStepIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedStepIdsMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
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
  Set<GeneratedColumn> get $primaryKey => {lessonId};
  @override
  LocalLessonProgressData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLessonProgressData(
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      currentStepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_step_id'],
      ),
      completedStepIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_step_ids'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_state'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalLessonProgressTable createAlias(String alias) {
    return $LocalLessonProgressTable(attachedDatabase, alias);
  }
}

class LocalLessonProgressData extends DataClass
    implements Insertable<LocalLessonProgressData> {
  final String lessonId;
  final String? currentStepId;
  final String completedStepIds;
  final double score;
  final String syncState;
  final DateTime updatedAt;
  const LocalLessonProgressData({
    required this.lessonId,
    this.currentStepId,
    required this.completedStepIds,
    required this.score,
    required this.syncState,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lesson_id'] = Variable<String>(lessonId);
    if (!nullToAbsent || currentStepId != null) {
      map['current_step_id'] = Variable<String>(currentStepId);
    }
    map['completed_step_ids'] = Variable<String>(completedStepIds);
    map['score'] = Variable<double>(score);
    map['sync_state'] = Variable<String>(syncState);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalLessonProgressCompanion toCompanion(bool nullToAbsent) {
    return LocalLessonProgressCompanion(
      lessonId: Value(lessonId),
      currentStepId: currentStepId == null && nullToAbsent
          ? const Value.absent()
          : Value(currentStepId),
      completedStepIds: Value(completedStepIds),
      score: Value(score),
      syncState: Value(syncState),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalLessonProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLessonProgressData(
      lessonId: serializer.fromJson<String>(json['lessonId']),
      currentStepId: serializer.fromJson<String?>(json['currentStepId']),
      completedStepIds: serializer.fromJson<String>(json['completedStepIds']),
      score: serializer.fromJson<double>(json['score']),
      syncState: serializer.fromJson<String>(json['syncState']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lessonId': serializer.toJson<String>(lessonId),
      'currentStepId': serializer.toJson<String?>(currentStepId),
      'completedStepIds': serializer.toJson<String>(completedStepIds),
      'score': serializer.toJson<double>(score),
      'syncState': serializer.toJson<String>(syncState),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalLessonProgressData copyWith({
    String? lessonId,
    Value<String?> currentStepId = const Value.absent(),
    String? completedStepIds,
    double? score,
    String? syncState,
    DateTime? updatedAt,
  }) => LocalLessonProgressData(
    lessonId: lessonId ?? this.lessonId,
    currentStepId: currentStepId.present
        ? currentStepId.value
        : this.currentStepId,
    completedStepIds: completedStepIds ?? this.completedStepIds,
    score: score ?? this.score,
    syncState: syncState ?? this.syncState,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalLessonProgressData copyWithCompanion(LocalLessonProgressCompanion data) {
    return LocalLessonProgressData(
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      currentStepId: data.currentStepId.present
          ? data.currentStepId.value
          : this.currentStepId,
      completedStepIds: data.completedStepIds.present
          ? data.completedStepIds.value
          : this.completedStepIds,
      score: data.score.present ? data.score.value : this.score,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLessonProgressData(')
          ..write('lessonId: $lessonId, ')
          ..write('currentStepId: $currentStepId, ')
          ..write('completedStepIds: $completedStepIds, ')
          ..write('score: $score, ')
          ..write('syncState: $syncState, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    lessonId,
    currentStepId,
    completedStepIds,
    score,
    syncState,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLessonProgressData &&
          other.lessonId == this.lessonId &&
          other.currentStepId == this.currentStepId &&
          other.completedStepIds == this.completedStepIds &&
          other.score == this.score &&
          other.syncState == this.syncState &&
          other.updatedAt == this.updatedAt);
}

class LocalLessonProgressCompanion
    extends UpdateCompanion<LocalLessonProgressData> {
  final Value<String> lessonId;
  final Value<String?> currentStepId;
  final Value<String> completedStepIds;
  final Value<double> score;
  final Value<String> syncState;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalLessonProgressCompanion({
    this.lessonId = const Value.absent(),
    this.currentStepId = const Value.absent(),
    this.completedStepIds = const Value.absent(),
    this.score = const Value.absent(),
    this.syncState = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLessonProgressCompanion.insert({
    required String lessonId,
    this.currentStepId = const Value.absent(),
    required String completedStepIds,
    this.score = const Value.absent(),
    this.syncState = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : lessonId = Value(lessonId),
       completedStepIds = Value(completedStepIds),
       updatedAt = Value(updatedAt);
  static Insertable<LocalLessonProgressData> custom({
    Expression<String>? lessonId,
    Expression<String>? currentStepId,
    Expression<String>? completedStepIds,
    Expression<double>? score,
    Expression<String>? syncState,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (lessonId != null) 'lesson_id': lessonId,
      if (currentStepId != null) 'current_step_id': currentStepId,
      if (completedStepIds != null) 'completed_step_ids': completedStepIds,
      if (score != null) 'score': score,
      if (syncState != null) 'sync_state': syncState,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLessonProgressCompanion copyWith({
    Value<String>? lessonId,
    Value<String?>? currentStepId,
    Value<String>? completedStepIds,
    Value<double>? score,
    Value<String>? syncState,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalLessonProgressCompanion(
      lessonId: lessonId ?? this.lessonId,
      currentStepId: currentStepId ?? this.currentStepId,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      score: score ?? this.score,
      syncState: syncState ?? this.syncState,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (currentStepId.present) {
      map['current_step_id'] = Variable<String>(currentStepId.value);
    }
    if (completedStepIds.present) {
      map['completed_step_ids'] = Variable<String>(completedStepIds.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (syncState.present) {
      map['sync_state'] = Variable<String>(syncState.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalLessonProgressCompanion(')
          ..write('lessonId: $lessonId, ')
          ..write('currentStepId: $currentStepId, ')
          ..write('completedStepIds: $completedStepIds, ')
          ..write('score: $score, ')
          ..write('syncState: $syncState, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncOperationsTable extends PendingSyncOperations
    with TableInfo<$PendingSyncOperationsTable, PendingSyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _clientOperationIdMeta = const VerificationMeta(
    'clientOperationId',
  );
  @override
  late final GeneratedColumn<String> clientOperationId =
      GeneratedColumn<String>(
        'client_operation_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _operationTypeMeta = const VerificationMeta(
    'operationType',
  );
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
    'operation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    clientOperationId,
    operationType,
    entityId,
    payload,
    createdAt,
    retryCount,
    lastError,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('client_operation_id')) {
      context.handle(
        _clientOperationIdMeta,
        clientOperationId.isAcceptableOrUnknown(
          data['client_operation_id']!,
          _clientOperationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientOperationIdMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
        _operationTypeMeta,
        operationType.isAcceptableOrUnknown(
          data['operation_type']!,
          _operationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {clientOperationId};
  @override
  PendingSyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncOperation(
      clientOperationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_operation_id'],
      )!,
      operationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $PendingSyncOperationsTable createAlias(String alias) {
    return $PendingSyncOperationsTable(attachedDatabase, alias);
  }
}

class PendingSyncOperation extends DataClass
    implements Insertable<PendingSyncOperation> {
  final String clientOperationId;
  final String operationType;
  final String entityId;
  final String payload;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  final String syncStatus;
  const PendingSyncOperation({
    required this.clientOperationId,
    required this.operationType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    required this.retryCount,
    this.lastError,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['client_operation_id'] = Variable<String>(clientOperationId);
    map['operation_type'] = Variable<String>(operationType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  PendingSyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncOperationsCompanion(
      clientOperationId: Value(clientOperationId),
      operationType: Value(operationType),
      entityId: Value(entityId),
      payload: Value(payload),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      syncStatus: Value(syncStatus),
    );
  }

  factory PendingSyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncOperation(
      clientOperationId: serializer.fromJson<String>(json['clientOperationId']),
      operationType: serializer.fromJson<String>(json['operationType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'clientOperationId': serializer.toJson<String>(clientOperationId),
      'operationType': serializer.toJson<String>(operationType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  PendingSyncOperation copyWith({
    String? clientOperationId,
    String? operationType,
    String? entityId,
    String? payload,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    String? syncStatus,
  }) => PendingSyncOperation(
    clientOperationId: clientOperationId ?? this.clientOperationId,
    operationType: operationType ?? this.operationType,
    entityId: entityId ?? this.entityId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  PendingSyncOperation copyWithCompanion(PendingSyncOperationsCompanion data) {
    return PendingSyncOperation(
      clientOperationId: data.clientOperationId.present
          ? data.clientOperationId.value
          : this.clientOperationId,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncOperation(')
          ..write('clientOperationId: $clientOperationId, ')
          ..write('operationType: $operationType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    clientOperationId,
    operationType,
    entityId,
    payload,
    createdAt,
    retryCount,
    lastError,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncOperation &&
          other.clientOperationId == this.clientOperationId &&
          other.operationType == this.operationType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.syncStatus == this.syncStatus);
}

class PendingSyncOperationsCompanion
    extends UpdateCompanion<PendingSyncOperation> {
  final Value<String> clientOperationId;
  final Value<String> operationType;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const PendingSyncOperationsCompanion({
    this.clientOperationId = const Value.absent(),
    this.operationType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingSyncOperationsCompanion.insert({
    required String clientOperationId,
    required String operationType,
    required String entityId,
    required String payload,
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : clientOperationId = Value(clientOperationId),
       operationType = Value(operationType),
       entityId = Value(entityId),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<PendingSyncOperation> custom({
    Expression<String>? clientOperationId,
    Expression<String>? operationType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (clientOperationId != null) 'client_operation_id': clientOperationId,
      if (operationType != null) 'operation_type': operationType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingSyncOperationsCompanion copyWith({
    Value<String>? clientOperationId,
    Value<String>? operationType,
    Value<String>? entityId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return PendingSyncOperationsCompanion(
      clientOperationId: clientOperationId ?? this.clientOperationId,
      operationType: operationType ?? this.operationType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (clientOperationId.present) {
      map['client_operation_id'] = Variable<String>(clientOperationId.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncOperationsCompanion(')
          ..write('clientOperationId: $clientOperationId, ')
          ..write('operationType: $operationType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheMetadataTable extends CacheMetadata
    with TableInfo<$CacheMetadataTable, CacheMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheMetadataTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheMetadataData> instance, {
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
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheMetadataData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CacheMetadataTable createAlias(String alias) {
    return $CacheMetadataTable(attachedDatabase, alias);
  }
}

class CacheMetadataData extends DataClass
    implements Insertable<CacheMetadataData> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const CacheMetadataData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CacheMetadataCompanion toCompanion(bool nullToAbsent) {
    return CacheMetadataCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory CacheMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheMetadataData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CacheMetadataData copyWith({
    String? key,
    String? value,
    DateTime? updatedAt,
  }) => CacheMetadataData(
    key: key ?? this.key,
    value: value ?? this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CacheMetadataData copyWithCompanion(CacheMetadataCompanion data) {
    return CacheMetadataData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheMetadataData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class CacheMetadataCompanion extends UpdateCompanion<CacheMetadataData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CacheMetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheMetadataCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<CacheMetadataData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheMetadataCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CacheMetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheMetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedCoursesTable cachedCourses = $CachedCoursesTable(this);
  late final $CachedModulesTable cachedModules = $CachedModulesTable(this);
  late final $CachedLessonsTable cachedLessons = $CachedLessonsTable(this);
  late final $CachedLessonStepsTable cachedLessonSteps =
      $CachedLessonStepsTable(this);
  late final $LocalLessonProgressTable localLessonProgress =
      $LocalLessonProgressTable(this);
  late final $PendingSyncOperationsTable pendingSyncOperations =
      $PendingSyncOperationsTable(this);
  late final $CacheMetadataTable cacheMetadata = $CacheMetadataTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cachedCourses,
    cachedModules,
    cachedLessons,
    cachedLessonSteps,
    localLessonProgress,
    pendingSyncOperations,
    cacheMetadata,
  ];
}

typedef $$CachedCoursesTableCreateCompanionBuilder =
    CachedCoursesCompanion Function({
      required String id,
      required String payload,
      required int contentVersion,
      required DateTime cachedAt,
      Value<bool> isStale,
      Value<int> rowid,
    });
typedef $$CachedCoursesTableUpdateCompanionBuilder =
    CachedCoursesCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<int> contentVersion,
      Value<DateTime> cachedAt,
      Value<bool> isStale,
      Value<int> rowid,
    });

class $$CachedCoursesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCoursesTable> {
  $$CachedCoursesTableFilterComposer({
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

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStale => $composableBuilder(
    column: $table.isStale,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCoursesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCoursesTable> {
  $$CachedCoursesTableOrderingComposer({
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

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStale => $composableBuilder(
    column: $table.isStale,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCoursesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCoursesTable> {
  $$CachedCoursesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<bool> get isStale =>
      $composableBuilder(column: $table.isStale, builder: (column) => column);
}

class $$CachedCoursesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCoursesTable,
          CachedCourse,
          $$CachedCoursesTableFilterComposer,
          $$CachedCoursesTableOrderingComposer,
          $$CachedCoursesTableAnnotationComposer,
          $$CachedCoursesTableCreateCompanionBuilder,
          $$CachedCoursesTableUpdateCompanionBuilder,
          (
            CachedCourse,
            BaseReferences<_$AppDatabase, $CachedCoursesTable, CachedCourse>,
          ),
          CachedCourse,
          PrefetchHooks Function()
        > {
  $$CachedCoursesTableTableManager(_$AppDatabase db, $CachedCoursesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCoursesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCoursesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedCoursesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<bool> isStale = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCoursesCompanion(
                id: id,
                payload: payload,
                contentVersion: contentVersion,
                cachedAt: cachedAt,
                isStale: isStale,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required int contentVersion,
                required DateTime cachedAt,
                Value<bool> isStale = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCoursesCompanion.insert(
                id: id,
                payload: payload,
                contentVersion: contentVersion,
                cachedAt: cachedAt,
                isStale: isStale,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCoursesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCoursesTable,
      CachedCourse,
      $$CachedCoursesTableFilterComposer,
      $$CachedCoursesTableOrderingComposer,
      $$CachedCoursesTableAnnotationComposer,
      $$CachedCoursesTableCreateCompanionBuilder,
      $$CachedCoursesTableUpdateCompanionBuilder,
      (
        CachedCourse,
        BaseReferences<_$AppDatabase, $CachedCoursesTable, CachedCourse>,
      ),
      CachedCourse,
      PrefetchHooks Function()
    >;
typedef $$CachedModulesTableCreateCompanionBuilder =
    CachedModulesCompanion Function({
      required String id,
      required String courseId,
      required String payload,
      required int contentVersion,
      Value<int> rowid,
    });
typedef $$CachedModulesTableUpdateCompanionBuilder =
    CachedModulesCompanion Function({
      Value<String> id,
      Value<String> courseId,
      Value<String> payload,
      Value<int> contentVersion,
      Value<int> rowid,
    });

class $$CachedModulesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedModulesTable> {
  $$CachedModulesTableFilterComposer({
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

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedModulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedModulesTable> {
  $$CachedModulesTableOrderingComposer({
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

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedModulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedModulesTable> {
  $$CachedModulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );
}

class $$CachedModulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedModulesTable,
          CachedModule,
          $$CachedModulesTableFilterComposer,
          $$CachedModulesTableOrderingComposer,
          $$CachedModulesTableAnnotationComposer,
          $$CachedModulesTableCreateCompanionBuilder,
          $$CachedModulesTableUpdateCompanionBuilder,
          (
            CachedModule,
            BaseReferences<_$AppDatabase, $CachedModulesTable, CachedModule>,
          ),
          CachedModule,
          PrefetchHooks Function()
        > {
  $$CachedModulesTableTableManager(_$AppDatabase db, $CachedModulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedModulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedModulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedModulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedModulesCompanion(
                id: id,
                courseId: courseId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String courseId,
                required String payload,
                required int contentVersion,
                Value<int> rowid = const Value.absent(),
              }) => CachedModulesCompanion.insert(
                id: id,
                courseId: courseId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedModulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedModulesTable,
      CachedModule,
      $$CachedModulesTableFilterComposer,
      $$CachedModulesTableOrderingComposer,
      $$CachedModulesTableAnnotationComposer,
      $$CachedModulesTableCreateCompanionBuilder,
      $$CachedModulesTableUpdateCompanionBuilder,
      (
        CachedModule,
        BaseReferences<_$AppDatabase, $CachedModulesTable, CachedModule>,
      ),
      CachedModule,
      PrefetchHooks Function()
    >;
typedef $$CachedLessonsTableCreateCompanionBuilder =
    CachedLessonsCompanion Function({
      required String id,
      required String moduleId,
      required String payload,
      required int contentVersion,
      Value<int> rowid,
    });
typedef $$CachedLessonsTableUpdateCompanionBuilder =
    CachedLessonsCompanion Function({
      Value<String> id,
      Value<String> moduleId,
      Value<String> payload,
      Value<int> contentVersion,
      Value<int> rowid,
    });

class $$CachedLessonsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedLessonsTable> {
  $$CachedLessonsTableFilterComposer({
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

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedLessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedLessonsTable> {
  $$CachedLessonsTableOrderingComposer({
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

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedLessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedLessonsTable> {
  $$CachedLessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );
}

class $$CachedLessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedLessonsTable,
          CachedLesson,
          $$CachedLessonsTableFilterComposer,
          $$CachedLessonsTableOrderingComposer,
          $$CachedLessonsTableAnnotationComposer,
          $$CachedLessonsTableCreateCompanionBuilder,
          $$CachedLessonsTableUpdateCompanionBuilder,
          (
            CachedLesson,
            BaseReferences<_$AppDatabase, $CachedLessonsTable, CachedLesson>,
          ),
          CachedLesson,
          PrefetchHooks Function()
        > {
  $$CachedLessonsTableTableManager(_$AppDatabase db, $CachedLessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedLessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedLessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedLessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedLessonsCompanion(
                id: id,
                moduleId: moduleId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String moduleId,
                required String payload,
                required int contentVersion,
                Value<int> rowid = const Value.absent(),
              }) => CachedLessonsCompanion.insert(
                id: id,
                moduleId: moduleId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedLessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedLessonsTable,
      CachedLesson,
      $$CachedLessonsTableFilterComposer,
      $$CachedLessonsTableOrderingComposer,
      $$CachedLessonsTableAnnotationComposer,
      $$CachedLessonsTableCreateCompanionBuilder,
      $$CachedLessonsTableUpdateCompanionBuilder,
      (
        CachedLesson,
        BaseReferences<_$AppDatabase, $CachedLessonsTable, CachedLesson>,
      ),
      CachedLesson,
      PrefetchHooks Function()
    >;
typedef $$CachedLessonStepsTableCreateCompanionBuilder =
    CachedLessonStepsCompanion Function({
      required String id,
      required String lessonId,
      required String payload,
      required int contentVersion,
      Value<int> rowid,
    });
typedef $$CachedLessonStepsTableUpdateCompanionBuilder =
    CachedLessonStepsCompanion Function({
      Value<String> id,
      Value<String> lessonId,
      Value<String> payload,
      Value<int> contentVersion,
      Value<int> rowid,
    });

class $$CachedLessonStepsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedLessonStepsTable> {
  $$CachedLessonStepsTableFilterComposer({
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

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedLessonStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedLessonStepsTable> {
  $$CachedLessonStepsTableOrderingComposer({
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

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedLessonStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedLessonStepsTable> {
  $$CachedLessonStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get contentVersion => $composableBuilder(
    column: $table.contentVersion,
    builder: (column) => column,
  );
}

class $$CachedLessonStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedLessonStepsTable,
          CachedLessonStep,
          $$CachedLessonStepsTableFilterComposer,
          $$CachedLessonStepsTableOrderingComposer,
          $$CachedLessonStepsTableAnnotationComposer,
          $$CachedLessonStepsTableCreateCompanionBuilder,
          $$CachedLessonStepsTableUpdateCompanionBuilder,
          (
            CachedLessonStep,
            BaseReferences<
              _$AppDatabase,
              $CachedLessonStepsTable,
              CachedLessonStep
            >,
          ),
          CachedLessonStep,
          PrefetchHooks Function()
        > {
  $$CachedLessonStepsTableTableManager(
    _$AppDatabase db,
    $CachedLessonStepsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedLessonStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedLessonStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedLessonStepsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> contentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedLessonStepsCompanion(
                id: id,
                lessonId: lessonId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lessonId,
                required String payload,
                required int contentVersion,
                Value<int> rowid = const Value.absent(),
              }) => CachedLessonStepsCompanion.insert(
                id: id,
                lessonId: lessonId,
                payload: payload,
                contentVersion: contentVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedLessonStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedLessonStepsTable,
      CachedLessonStep,
      $$CachedLessonStepsTableFilterComposer,
      $$CachedLessonStepsTableOrderingComposer,
      $$CachedLessonStepsTableAnnotationComposer,
      $$CachedLessonStepsTableCreateCompanionBuilder,
      $$CachedLessonStepsTableUpdateCompanionBuilder,
      (
        CachedLessonStep,
        BaseReferences<
          _$AppDatabase,
          $CachedLessonStepsTable,
          CachedLessonStep
        >,
      ),
      CachedLessonStep,
      PrefetchHooks Function()
    >;
typedef $$LocalLessonProgressTableCreateCompanionBuilder =
    LocalLessonProgressCompanion Function({
      required String lessonId,
      Value<String?> currentStepId,
      required String completedStepIds,
      Value<double> score,
      Value<String> syncState,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalLessonProgressTableUpdateCompanionBuilder =
    LocalLessonProgressCompanion Function({
      Value<String> lessonId,
      Value<String?> currentStepId,
      Value<String> completedStepIds,
      Value<double> score,
      Value<String> syncState,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalLessonProgressTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLessonProgressTable> {
  $$LocalLessonProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentStepId => $composableBuilder(
    column: $table.currentStepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedStepIds => $composableBuilder(
    column: $table.completedStepIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLessonProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLessonProgressTable> {
  $$LocalLessonProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentStepId => $composableBuilder(
    column: $table.currentStepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedStepIds => $composableBuilder(
    column: $table.completedStepIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLessonProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLessonProgressTable> {
  $$LocalLessonProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get currentStepId => $composableBuilder(
    column: $table.currentStepId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get completedStepIds => $composableBuilder(
    column: $table.completedStepIds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalLessonProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLessonProgressTable,
          LocalLessonProgressData,
          $$LocalLessonProgressTableFilterComposer,
          $$LocalLessonProgressTableOrderingComposer,
          $$LocalLessonProgressTableAnnotationComposer,
          $$LocalLessonProgressTableCreateCompanionBuilder,
          $$LocalLessonProgressTableUpdateCompanionBuilder,
          (
            LocalLessonProgressData,
            BaseReferences<
              _$AppDatabase,
              $LocalLessonProgressTable,
              LocalLessonProgressData
            >,
          ),
          LocalLessonProgressData,
          PrefetchHooks Function()
        > {
  $$LocalLessonProgressTableTableManager(
    _$AppDatabase db,
    $LocalLessonProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLessonProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLessonProgressTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLessonProgressTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> lessonId = const Value.absent(),
                Value<String?> currentStepId = const Value.absent(),
                Value<String> completedStepIds = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonProgressCompanion(
                lessonId: lessonId,
                currentStepId: currentStepId,
                completedStepIds: completedStepIds,
                score: score,
                syncState: syncState,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String lessonId,
                Value<String?> currentStepId = const Value.absent(),
                required String completedStepIds,
                Value<double> score = const Value.absent(),
                Value<String> syncState = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalLessonProgressCompanion.insert(
                lessonId: lessonId,
                currentStepId: currentStepId,
                completedStepIds: completedStepIds,
                score: score,
                syncState: syncState,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalLessonProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLessonProgressTable,
      LocalLessonProgressData,
      $$LocalLessonProgressTableFilterComposer,
      $$LocalLessonProgressTableOrderingComposer,
      $$LocalLessonProgressTableAnnotationComposer,
      $$LocalLessonProgressTableCreateCompanionBuilder,
      $$LocalLessonProgressTableUpdateCompanionBuilder,
      (
        LocalLessonProgressData,
        BaseReferences<
          _$AppDatabase,
          $LocalLessonProgressTable,
          LocalLessonProgressData
        >,
      ),
      LocalLessonProgressData,
      PrefetchHooks Function()
    >;
typedef $$PendingSyncOperationsTableCreateCompanionBuilder =
    PendingSyncOperationsCompanion Function({
      required String clientOperationId,
      required String operationType,
      required String entityId,
      required String payload,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$PendingSyncOperationsTableUpdateCompanionBuilder =
    PendingSyncOperationsCompanion Function({
      Value<String> clientOperationId,
      Value<String> operationType,
      Value<String> entityId,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$PendingSyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSyncOperationsTable> {
  $$PendingSyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get clientOperationId => $composableBuilder(
    column: $table.clientOperationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingSyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSyncOperationsTable> {
  $$PendingSyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get clientOperationId => $composableBuilder(
    column: $table.clientOperationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingSyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSyncOperationsTable> {
  $$PendingSyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get clientOperationId => $composableBuilder(
    column: $table.clientOperationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operationType => $composableBuilder(
    column: $table.operationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$PendingSyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSyncOperationsTable,
          PendingSyncOperation,
          $$PendingSyncOperationsTableFilterComposer,
          $$PendingSyncOperationsTableOrderingComposer,
          $$PendingSyncOperationsTableAnnotationComposer,
          $$PendingSyncOperationsTableCreateCompanionBuilder,
          $$PendingSyncOperationsTableUpdateCompanionBuilder,
          (
            PendingSyncOperation,
            BaseReferences<
              _$AppDatabase,
              $PendingSyncOperationsTable,
              PendingSyncOperation
            >,
          ),
          PendingSyncOperation,
          PrefetchHooks Function()
        > {
  $$PendingSyncOperationsTableTableManager(
    _$AppDatabase db,
    $PendingSyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSyncOperationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingSyncOperationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingSyncOperationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> clientOperationId = const Value.absent(),
                Value<String> operationType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingSyncOperationsCompanion(
                clientOperationId: clientOperationId,
                operationType: operationType,
                entityId: entityId,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String clientOperationId,
                required String operationType,
                required String entityId,
                required String payload,
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingSyncOperationsCompanion.insert(
                clientOperationId: clientOperationId,
                operationType: operationType,
                entityId: entityId,
                payload: payload,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingSyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSyncOperationsTable,
      PendingSyncOperation,
      $$PendingSyncOperationsTableFilterComposer,
      $$PendingSyncOperationsTableOrderingComposer,
      $$PendingSyncOperationsTableAnnotationComposer,
      $$PendingSyncOperationsTableCreateCompanionBuilder,
      $$PendingSyncOperationsTableUpdateCompanionBuilder,
      (
        PendingSyncOperation,
        BaseReferences<
          _$AppDatabase,
          $PendingSyncOperationsTable,
          PendingSyncOperation
        >,
      ),
      PendingSyncOperation,
      PrefetchHooks Function()
    >;
typedef $$CacheMetadataTableCreateCompanionBuilder =
    CacheMetadataCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CacheMetadataTableUpdateCompanionBuilder =
    CacheMetadataCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CacheMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableFilterComposer({
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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableOrderingComposer({
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheMetadataTable> {
  $$CacheMetadataTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CacheMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheMetadataTable,
          CacheMetadataData,
          $$CacheMetadataTableFilterComposer,
          $$CacheMetadataTableOrderingComposer,
          $$CacheMetadataTableAnnotationComposer,
          $$CacheMetadataTableCreateCompanionBuilder,
          $$CacheMetadataTableUpdateCompanionBuilder,
          (
            CacheMetadataData,
            BaseReferences<
              _$AppDatabase,
              $CacheMetadataTable,
              CacheMetadataData
            >,
          ),
          CacheMetadataData,
          PrefetchHooks Function()
        > {
  $$CacheMetadataTableTableManager(_$AppDatabase db, $CacheMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CacheMetadataCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheMetadataTable,
      CacheMetadataData,
      $$CacheMetadataTableFilterComposer,
      $$CacheMetadataTableOrderingComposer,
      $$CacheMetadataTableAnnotationComposer,
      $$CacheMetadataTableCreateCompanionBuilder,
      $$CacheMetadataTableUpdateCompanionBuilder,
      (
        CacheMetadataData,
        BaseReferences<_$AppDatabase, $CacheMetadataTable, CacheMetadataData>,
      ),
      CacheMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedCoursesTableTableManager get cachedCourses =>
      $$CachedCoursesTableTableManager(_db, _db.cachedCourses);
  $$CachedModulesTableTableManager get cachedModules =>
      $$CachedModulesTableTableManager(_db, _db.cachedModules);
  $$CachedLessonsTableTableManager get cachedLessons =>
      $$CachedLessonsTableTableManager(_db, _db.cachedLessons);
  $$CachedLessonStepsTableTableManager get cachedLessonSteps =>
      $$CachedLessonStepsTableTableManager(_db, _db.cachedLessonSteps);
  $$LocalLessonProgressTableTableManager get localLessonProgress =>
      $$LocalLessonProgressTableTableManager(_db, _db.localLessonProgress);
  $$PendingSyncOperationsTableTableManager get pendingSyncOperations =>
      $$PendingSyncOperationsTableTableManager(_db, _db.pendingSyncOperations);
  $$CacheMetadataTableTableManager get cacheMetadata =>
      $$CacheMetadataTableTableManager(_db, _db.cacheMetadata);
}
