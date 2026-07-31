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

class $CachedTutorConversationsTable extends CachedTutorConversations
    with TableInfo<$CachedTutorConversationsTable, CachedTutorConversation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTutorConversationsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tutor_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTutorConversation> instance, {
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
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedTutorConversation map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTutorConversation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedTutorConversationsTable createAlias(String alias) {
    return $CachedTutorConversationsTable(attachedDatabase, alias);
  }
}

class CachedTutorConversation extends DataClass
    implements Insertable<CachedTutorConversation> {
  final String id;
  final String payload;
  final DateTime cachedAt;
  const CachedTutorConversation({
    required this.id,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedTutorConversationsCompanion toCompanion(bool nullToAbsent) {
    return CachedTutorConversationsCompanion(
      id: Value(id),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedTutorConversation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTutorConversation(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedTutorConversation copyWith({
    String? id,
    String? payload,
    DateTime? cachedAt,
  }) => CachedTutorConversation(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedTutorConversation copyWithCompanion(
    CachedTutorConversationsCompanion data,
  ) {
    return CachedTutorConversation(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorConversation(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTutorConversation &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class CachedTutorConversationsCompanion
    extends UpdateCompanion<CachedTutorConversation> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedTutorConversationsCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTutorConversationsCompanion.insert({
    required String id,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedTutorConversation> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTutorConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedTutorConversationsCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
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
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorConversationsCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTutorMessagesTable extends CachedTutorMessages
    with TableInfo<$CachedTutorMessagesTable, CachedTutorMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTutorMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
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
  @override
  List<GeneratedColumn> get $columns => [id, conversationId, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tutor_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTutorMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedTutorMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTutorMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedTutorMessagesTable createAlias(String alias) {
    return $CachedTutorMessagesTable(attachedDatabase, alias);
  }
}

class CachedTutorMessage extends DataClass
    implements Insertable<CachedTutorMessage> {
  final String id;
  final String conversationId;
  final String payload;
  final DateTime cachedAt;
  const CachedTutorMessage({
    required this.id,
    required this.conversationId,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedTutorMessagesCompanion toCompanion(bool nullToAbsent) {
    return CachedTutorMessagesCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedTutorMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTutorMessage(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedTutorMessage copyWith({
    String? id,
    String? conversationId,
    String? payload,
    DateTime? cachedAt,
  }) => CachedTutorMessage(
    id: id ?? this.id,
    conversationId: conversationId ?? this.conversationId,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedTutorMessage copyWithCompanion(CachedTutorMessagesCompanion data) {
    return CachedTutorMessage(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorMessage(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conversationId, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTutorMessage &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class CachedTutorMessagesCompanion extends UpdateCompanion<CachedTutorMessage> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedTutorMessagesCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTutorMessagesCompanion.insert({
    required String id,
    required String conversationId,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       conversationId = Value(conversationId),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedTutorMessage> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTutorMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? conversationId,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedTutorMessagesCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorMessagesCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTutorMistakesTable extends CachedTutorMistakes
    with TableInfo<$CachedTutorMistakesTable, CachedTutorMistake> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTutorMistakesTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tutor_mistakes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTutorMistake> instance, {
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
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedTutorMistake map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTutorMistake(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedTutorMistakesTable createAlias(String alias) {
    return $CachedTutorMistakesTable(attachedDatabase, alias);
  }
}

class CachedTutorMistake extends DataClass
    implements Insertable<CachedTutorMistake> {
  final String id;
  final String payload;
  final DateTime cachedAt;
  const CachedTutorMistake({
    required this.id,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedTutorMistakesCompanion toCompanion(bool nullToAbsent) {
    return CachedTutorMistakesCompanion(
      id: Value(id),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedTutorMistake.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTutorMistake(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedTutorMistake copyWith({
    String? id,
    String? payload,
    DateTime? cachedAt,
  }) => CachedTutorMistake(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedTutorMistake copyWithCompanion(CachedTutorMistakesCompanion data) {
    return CachedTutorMistake(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorMistake(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTutorMistake &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class CachedTutorMistakesCompanion extends UpdateCompanion<CachedTutorMistake> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedTutorMistakesCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTutorMistakesCompanion.insert({
    required String id,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedTutorMistake> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTutorMistakesCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedTutorMistakesCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
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
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorMistakesCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedTutorSummariesTable extends CachedTutorSummaries
    with TableInfo<$CachedTutorSummariesTable, CachedTutorSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedTutorSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
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
  @override
  List<GeneratedColumn> get $columns => [conversationId, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_tutor_summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedTutorSummary> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {conversationId};
  @override
  CachedTutorSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedTutorSummary(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedTutorSummariesTable createAlias(String alias) {
    return $CachedTutorSummariesTable(attachedDatabase, alias);
  }
}

class CachedTutorSummary extends DataClass
    implements Insertable<CachedTutorSummary> {
  final String conversationId;
  final String payload;
  final DateTime cachedAt;
  const CachedTutorSummary({
    required this.conversationId,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedTutorSummariesCompanion toCompanion(bool nullToAbsent) {
    return CachedTutorSummariesCompanion(
      conversationId: Value(conversationId),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedTutorSummary.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedTutorSummary(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedTutorSummary copyWith({
    String? conversationId,
    String? payload,
    DateTime? cachedAt,
  }) => CachedTutorSummary(
    conversationId: conversationId ?? this.conversationId,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedTutorSummary copyWithCompanion(CachedTutorSummariesCompanion data) {
    return CachedTutorSummary(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorSummary(')
          ..write('conversationId: $conversationId, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(conversationId, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedTutorSummary &&
          other.conversationId == this.conversationId &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class CachedTutorSummariesCompanion
    extends UpdateCompanion<CachedTutorSummary> {
  final Value<String> conversationId;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedTutorSummariesCompanion({
    this.conversationId = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedTutorSummariesCompanion.insert({
    required String conversationId,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedTutorSummary> custom({
    Expression<String>? conversationId,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedTutorSummariesCompanion copyWith({
    Value<String>? conversationId,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedTutorSummariesCompanion(
      conversationId: conversationId ?? this.conversationId,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedTutorSummariesCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TutorDraftsTable extends TutorDrafts
    with TableInfo<$TutorDraftsTable, TutorDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TutorDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _draftTextMeta = const VerificationMeta(
    'draftText',
  );
  @override
  late final GeneratedColumn<String> draftText = GeneratedColumn<String>(
    'draft_text',
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
  List<GeneratedColumn> get $columns => [conversationId, draftText, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tutor_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TutorDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('draft_text')) {
      context.handle(
        _draftTextMeta,
        draftText.isAcceptableOrUnknown(data['draft_text']!, _draftTextMeta),
      );
    } else if (isInserting) {
      context.missing(_draftTextMeta);
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
  Set<GeneratedColumn> get $primaryKey => {conversationId};
  @override
  TutorDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TutorDraft(
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      draftText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}draft_text'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TutorDraftsTable createAlias(String alias) {
    return $TutorDraftsTable(attachedDatabase, alias);
  }
}

class TutorDraft extends DataClass implements Insertable<TutorDraft> {
  final String conversationId;
  final String draftText;
  final DateTime updatedAt;
  const TutorDraft({
    required this.conversationId,
    required this.draftText,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['conversation_id'] = Variable<String>(conversationId);
    map['draft_text'] = Variable<String>(draftText);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TutorDraftsCompanion toCompanion(bool nullToAbsent) {
    return TutorDraftsCompanion(
      conversationId: Value(conversationId),
      draftText: Value(draftText),
      updatedAt: Value(updatedAt),
    );
  }

  factory TutorDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TutorDraft(
      conversationId: serializer.fromJson<String>(json['conversationId']),
      draftText: serializer.fromJson<String>(json['draftText']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'conversationId': serializer.toJson<String>(conversationId),
      'draftText': serializer.toJson<String>(draftText),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TutorDraft copyWith({
    String? conversationId,
    String? draftText,
    DateTime? updatedAt,
  }) => TutorDraft(
    conversationId: conversationId ?? this.conversationId,
    draftText: draftText ?? this.draftText,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TutorDraft copyWithCompanion(TutorDraftsCompanion data) {
    return TutorDraft(
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      draftText: data.draftText.present ? data.draftText.value : this.draftText,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TutorDraft(')
          ..write('conversationId: $conversationId, ')
          ..write('draftText: $draftText, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(conversationId, draftText, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TutorDraft &&
          other.conversationId == this.conversationId &&
          other.draftText == this.draftText &&
          other.updatedAt == this.updatedAt);
}

class TutorDraftsCompanion extends UpdateCompanion<TutorDraft> {
  final Value<String> conversationId;
  final Value<String> draftText;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TutorDraftsCompanion({
    this.conversationId = const Value.absent(),
    this.draftText = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TutorDraftsCompanion.insert({
    required String conversationId,
    required String draftText,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : conversationId = Value(conversationId),
       draftText = Value(draftText),
       updatedAt = Value(updatedAt);
  static Insertable<TutorDraft> custom({
    Expression<String>? conversationId,
    Expression<String>? draftText,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (conversationId != null) 'conversation_id': conversationId,
      if (draftText != null) 'draft_text': draftText,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TutorDraftsCompanion copyWith({
    Value<String>? conversationId,
    Value<String>? draftText,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TutorDraftsCompanion(
      conversationId: conversationId ?? this.conversationId,
      draftText: draftText ?? this.draftText,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (draftText.present) {
      map['draft_text'] = Variable<String>(draftText.value);
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
    return (StringBuffer('TutorDraftsCompanion(')
          ..write('conversationId: $conversationId, ')
          ..write('draftText: $draftText, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedVoiceSessionsTable extends CachedVoiceSessions
    with TableInfo<$CachedVoiceSessionsTable, CachedVoiceSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedVoiceSessionsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_voice_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedVoiceSession> instance, {
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
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedVoiceSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedVoiceSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedVoiceSessionsTable createAlias(String alias) {
    return $CachedVoiceSessionsTable(attachedDatabase, alias);
  }
}

class CachedVoiceSession extends DataClass
    implements Insertable<CachedVoiceSession> {
  final String id;
  final String payload;
  final DateTime cachedAt;
  const CachedVoiceSession({
    required this.id,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedVoiceSessionsCompanion toCompanion(bool nullToAbsent) {
    return CachedVoiceSessionsCompanion(
      id: Value(id),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedVoiceSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedVoiceSession(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedVoiceSession copyWith({
    String? id,
    String? payload,
    DateTime? cachedAt,
  }) => CachedVoiceSession(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedVoiceSession copyWithCompanion(CachedVoiceSessionsCompanion data) {
    return CachedVoiceSession(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedVoiceSession(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedVoiceSession &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class CachedVoiceSessionsCompanion extends UpdateCompanion<CachedVoiceSession> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedVoiceSessionsCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedVoiceSessionsCompanion.insert({
    required String id,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedVoiceSession> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedVoiceSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedVoiceSessionsCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
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
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedVoiceSessionsCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedVoiceTurnsTable extends CachedVoiceTurns
    with TableInfo<$CachedVoiceTurnsTable, CachedVoiceTurn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedVoiceTurnsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tutorAudioIdMeta = const VerificationMeta(
    'tutorAudioId',
  );
  @override
  late final GeneratedColumn<String> tutorAudioId = GeneratedColumn<String>(
    'tutor_audio_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    payload,
    tutorAudioId,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_voice_turns';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedVoiceTurn> instance, {
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
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('tutor_audio_id')) {
      context.handle(
        _tutorAudioIdMeta,
        tutorAudioId.isAcceptableOrUnknown(
          data['tutor_audio_id']!,
          _tutorAudioIdMeta,
        ),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedVoiceTurn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedVoiceTurn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      tutorAudioId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tutor_audio_id'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedVoiceTurnsTable createAlias(String alias) {
    return $CachedVoiceTurnsTable(attachedDatabase, alias);
  }
}

class CachedVoiceTurn extends DataClass implements Insertable<CachedVoiceTurn> {
  final String id;
  final String sessionId;
  final String payload;
  final String? tutorAudioId;
  final DateTime cachedAt;
  const CachedVoiceTurn({
    required this.id,
    required this.sessionId,
    required this.payload,
    this.tutorAudioId,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || tutorAudioId != null) {
      map['tutor_audio_id'] = Variable<String>(tutorAudioId);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedVoiceTurnsCompanion toCompanion(bool nullToAbsent) {
    return CachedVoiceTurnsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      payload: Value(payload),
      tutorAudioId: tutorAudioId == null && nullToAbsent
          ? const Value.absent()
          : Value(tutorAudioId),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedVoiceTurn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedVoiceTurn(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      payload: serializer.fromJson<String>(json['payload']),
      tutorAudioId: serializer.fromJson<String?>(json['tutorAudioId']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'payload': serializer.toJson<String>(payload),
      'tutorAudioId': serializer.toJson<String?>(tutorAudioId),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedVoiceTurn copyWith({
    String? id,
    String? sessionId,
    String? payload,
    Value<String?> tutorAudioId = const Value.absent(),
    DateTime? cachedAt,
  }) => CachedVoiceTurn(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    payload: payload ?? this.payload,
    tutorAudioId: tutorAudioId.present ? tutorAudioId.value : this.tutorAudioId,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedVoiceTurn copyWithCompanion(CachedVoiceTurnsCompanion data) {
    return CachedVoiceTurn(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      payload: data.payload.present ? data.payload.value : this.payload,
      tutorAudioId: data.tutorAudioId.present
          ? data.tutorAudioId.value
          : this.tutorAudioId,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedVoiceTurn(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('payload: $payload, ')
          ..write('tutorAudioId: $tutorAudioId, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, payload, tutorAudioId, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedVoiceTurn &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.payload == this.payload &&
          other.tutorAudioId == this.tutorAudioId &&
          other.cachedAt == this.cachedAt);
}

class CachedVoiceTurnsCompanion extends UpdateCompanion<CachedVoiceTurn> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> payload;
  final Value<String?> tutorAudioId;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedVoiceTurnsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.payload = const Value.absent(),
    this.tutorAudioId = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedVoiceTurnsCompanion.insert({
    required String id,
    required String sessionId,
    required String payload,
    this.tutorAudioId = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<CachedVoiceTurn> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? payload,
    Expression<String>? tutorAudioId,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (payload != null) 'payload': payload,
      if (tutorAudioId != null) 'tutor_audio_id': tutorAudioId,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedVoiceTurnsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? payload,
    Value<String?>? tutorAudioId,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CachedVoiceTurnsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      payload: payload ?? this.payload,
      tutorAudioId: tutorAudioId ?? this.tutorAudioId,
      cachedAt: cachedAt ?? this.cachedAt,
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
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (tutorAudioId.present) {
      map['tutor_audio_id'] = Variable<String>(tutorAudioId.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedVoiceTurnsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('payload: $payload, ')
          ..write('tutorAudioId: $tutorAudioId, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VoicePreferencesTable extends VoicePreferences
    with TableInfo<$VoicePreferencesTable, VoicePreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VoicePreferencesTable(this.attachedDatabase, [this._alias]);
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
  List<GeneratedColumn> get $columns => [id, payload, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'voice_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<VoicePreference> instance, {
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
  VoicePreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VoicePreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $VoicePreferencesTable createAlias(String alias) {
    return $VoicePreferencesTable(attachedDatabase, alias);
  }
}

class VoicePreference extends DataClass implements Insertable<VoicePreference> {
  final String id;
  final String payload;
  final DateTime updatedAt;
  const VoicePreference({
    required this.id,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VoicePreferencesCompanion toCompanion(bool nullToAbsent) {
    return VoicePreferencesCompanion(
      id: Value(id),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory VoicePreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VoicePreference(
      id: serializer.fromJson<String>(json['id']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VoicePreference copyWith({
    String? id,
    String? payload,
    DateTime? updatedAt,
  }) => VoicePreference(
    id: id ?? this.id,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  VoicePreference copyWithCompanion(VoicePreferencesCompanion data) {
    return VoicePreference(
      id: data.id.present ? data.id.value : this.id,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VoicePreference(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VoicePreference &&
          other.id == this.id &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class VoicePreferencesCompanion extends UpdateCompanion<VoicePreference> {
  final Value<String> id;
  final Value<String> payload;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VoicePreferencesCompanion({
    this.id = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VoicePreferencesCompanion.insert({
    required String id,
    required String payload,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<VoicePreference> custom({
    Expression<String>? id,
    Expression<String>? payload,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VoicePreferencesCompanion copyWith({
    Value<String>? id,
    Value<String>? payload,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return VoicePreferencesCompanion(
      id: id ?? this.id,
      payload: payload ?? this.payload,
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
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
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
    return (StringBuffer('VoicePreferencesCompanion(')
          ..write('id: $id, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalLearnerProfilesTable extends LocalLearnerProfiles
    with TableInfo<$LocalLearnerProfilesTable, LocalLearnerProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalLearnerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Learner'),
  );
  static const VerificationMeta _nativeLanguageMeta = const VerificationMeta(
    'nativeLanguage',
  );
  @override
  late final GeneratedColumn<String> nativeLanguage = GeneratedColumn<String>(
    'native_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ml'),
  );
  static const VerificationMeta _explanationLanguageMeta =
      const VerificationMeta('explanationLanguage');
  @override
  late final GeneratedColumn<String> explanationLanguage =
      GeneratedColumn<String>(
        'explanation_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ml'),
      );
  static const VerificationMeta _confidenceLevelMeta = const VerificationMeta(
    'confidenceLevel',
  );
  @override
  late final GeneratedColumn<String> confidenceLevel = GeneratedColumn<String>(
    'confidence_level',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learningGoalsMeta = const VerificationMeta(
    'learningGoals',
  );
  @override
  late final GeneratedColumn<String> learningGoals = GeneratedColumn<String>(
    'learning_goals',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _difficultAreasMeta = const VerificationMeta(
    'difficultAreas',
  );
  @override
  late final GeneratedColumn<String> difficultAreas = GeneratedColumn<String>(
    'difficult_areas',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dailyStudyMinutesMeta = const VerificationMeta(
    'dailyStudyMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyStudyMinutes = GeneratedColumn<int>(
    'daily_study_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _placementResultMeta = const VerificationMeta(
    'placementResult',
  );
  @override
  late final GeneratedColumn<String> placementResult = GeneratedColumn<String>(
    'placement_result',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _learningPlanSummaryMeta =
      const VerificationMeta('learningPlanSummary');
  @override
  late final GeneratedColumn<String> learningPlanSummary =
      GeneratedColumn<String>(
        'learning_plan_summary',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
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
    id,
    displayName,
    nativeLanguage,
    explanationLanguage,
    confidenceLevel,
    learningGoals,
    difficultAreas,
    dailyStudyMinutes,
    onboardingComplete,
    placementResult,
    learningPlanSummary,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_learner_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalLearnerProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('native_language')) {
      context.handle(
        _nativeLanguageMeta,
        nativeLanguage.isAcceptableOrUnknown(
          data['native_language']!,
          _nativeLanguageMeta,
        ),
      );
    }
    if (data.containsKey('explanation_language')) {
      context.handle(
        _explanationLanguageMeta,
        explanationLanguage.isAcceptableOrUnknown(
          data['explanation_language']!,
          _explanationLanguageMeta,
        ),
      );
    }
    if (data.containsKey('confidence_level')) {
      context.handle(
        _confidenceLevelMeta,
        confidenceLevel.isAcceptableOrUnknown(
          data['confidence_level']!,
          _confidenceLevelMeta,
        ),
      );
    }
    if (data.containsKey('learning_goals')) {
      context.handle(
        _learningGoalsMeta,
        learningGoals.isAcceptableOrUnknown(
          data['learning_goals']!,
          _learningGoalsMeta,
        ),
      );
    }
    if (data.containsKey('difficult_areas')) {
      context.handle(
        _difficultAreasMeta,
        difficultAreas.isAcceptableOrUnknown(
          data['difficult_areas']!,
          _difficultAreasMeta,
        ),
      );
    }
    if (data.containsKey('daily_study_minutes')) {
      context.handle(
        _dailyStudyMinutesMeta,
        dailyStudyMinutes.isAcceptableOrUnknown(
          data['daily_study_minutes']!,
          _dailyStudyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('placement_result')) {
      context.handle(
        _placementResultMeta,
        placementResult.isAcceptableOrUnknown(
          data['placement_result']!,
          _placementResultMeta,
        ),
      );
    }
    if (data.containsKey('learning_plan_summary')) {
      context.handle(
        _learningPlanSummaryMeta,
        learningPlanSummary.isAcceptableOrUnknown(
          data['learning_plan_summary']!,
          _learningPlanSummaryMeta,
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
  LocalLearnerProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLearnerProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      nativeLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native_language'],
      )!,
      explanationLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_language'],
      )!,
      confidenceLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence_level'],
      ),
      learningGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_goals'],
      )!,
      difficultAreas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficult_areas'],
      )!,
      dailyStudyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_study_minutes'],
      ),
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      placementResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placement_result'],
      ),
      learningPlanSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_plan_summary'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LocalLearnerProfilesTable createAlias(String alias) {
    return $LocalLearnerProfilesTable(attachedDatabase, alias);
  }
}

class LocalLearnerProfile extends DataClass
    implements Insertable<LocalLearnerProfile> {
  final String id;
  final String displayName;
  final String nativeLanguage;
  final String explanationLanguage;
  final String? confidenceLevel;
  final String learningGoals;
  final String difficultAreas;
  final int? dailyStudyMinutes;
  final bool onboardingComplete;
  final String? placementResult;
  final String? learningPlanSummary;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LocalLearnerProfile({
    required this.id,
    required this.displayName,
    required this.nativeLanguage,
    required this.explanationLanguage,
    this.confidenceLevel,
    required this.learningGoals,
    required this.difficultAreas,
    this.dailyStudyMinutes,
    required this.onboardingComplete,
    this.placementResult,
    this.learningPlanSummary,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['native_language'] = Variable<String>(nativeLanguage);
    map['explanation_language'] = Variable<String>(explanationLanguage);
    if (!nullToAbsent || confidenceLevel != null) {
      map['confidence_level'] = Variable<String>(confidenceLevel);
    }
    map['learning_goals'] = Variable<String>(learningGoals);
    map['difficult_areas'] = Variable<String>(difficultAreas);
    if (!nullToAbsent || dailyStudyMinutes != null) {
      map['daily_study_minutes'] = Variable<int>(dailyStudyMinutes);
    }
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    if (!nullToAbsent || placementResult != null) {
      map['placement_result'] = Variable<String>(placementResult);
    }
    if (!nullToAbsent || learningPlanSummary != null) {
      map['learning_plan_summary'] = Variable<String>(learningPlanSummary);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalLearnerProfilesCompanion toCompanion(bool nullToAbsent) {
    return LocalLearnerProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      nativeLanguage: Value(nativeLanguage),
      explanationLanguage: Value(explanationLanguage),
      confidenceLevel: confidenceLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceLevel),
      learningGoals: Value(learningGoals),
      difficultAreas: Value(difficultAreas),
      dailyStudyMinutes: dailyStudyMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyStudyMinutes),
      onboardingComplete: Value(onboardingComplete),
      placementResult: placementResult == null && nullToAbsent
          ? const Value.absent()
          : Value(placementResult),
      learningPlanSummary: learningPlanSummary == null && nullToAbsent
          ? const Value.absent()
          : Value(learningPlanSummary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalLearnerProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLearnerProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      nativeLanguage: serializer.fromJson<String>(json['nativeLanguage']),
      explanationLanguage: serializer.fromJson<String>(
        json['explanationLanguage'],
      ),
      confidenceLevel: serializer.fromJson<String?>(json['confidenceLevel']),
      learningGoals: serializer.fromJson<String>(json['learningGoals']),
      difficultAreas: serializer.fromJson<String>(json['difficultAreas']),
      dailyStudyMinutes: serializer.fromJson<int?>(json['dailyStudyMinutes']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      placementResult: serializer.fromJson<String?>(json['placementResult']),
      learningPlanSummary: serializer.fromJson<String?>(
        json['learningPlanSummary'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'nativeLanguage': serializer.toJson<String>(nativeLanguage),
      'explanationLanguage': serializer.toJson<String>(explanationLanguage),
      'confidenceLevel': serializer.toJson<String?>(confidenceLevel),
      'learningGoals': serializer.toJson<String>(learningGoals),
      'difficultAreas': serializer.toJson<String>(difficultAreas),
      'dailyStudyMinutes': serializer.toJson<int?>(dailyStudyMinutes),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'placementResult': serializer.toJson<String?>(placementResult),
      'learningPlanSummary': serializer.toJson<String?>(learningPlanSummary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalLearnerProfile copyWith({
    String? id,
    String? displayName,
    String? nativeLanguage,
    String? explanationLanguage,
    Value<String?> confidenceLevel = const Value.absent(),
    String? learningGoals,
    String? difficultAreas,
    Value<int?> dailyStudyMinutes = const Value.absent(),
    bool? onboardingComplete,
    Value<String?> placementResult = const Value.absent(),
    Value<String?> learningPlanSummary = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LocalLearnerProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    nativeLanguage: nativeLanguage ?? this.nativeLanguage,
    explanationLanguage: explanationLanguage ?? this.explanationLanguage,
    confidenceLevel: confidenceLevel.present
        ? confidenceLevel.value
        : this.confidenceLevel,
    learningGoals: learningGoals ?? this.learningGoals,
    difficultAreas: difficultAreas ?? this.difficultAreas,
    dailyStudyMinutes: dailyStudyMinutes.present
        ? dailyStudyMinutes.value
        : this.dailyStudyMinutes,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    placementResult: placementResult.present
        ? placementResult.value
        : this.placementResult,
    learningPlanSummary: learningPlanSummary.present
        ? learningPlanSummary.value
        : this.learningPlanSummary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LocalLearnerProfile copyWithCompanion(LocalLearnerProfilesCompanion data) {
    return LocalLearnerProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      nativeLanguage: data.nativeLanguage.present
          ? data.nativeLanguage.value
          : this.nativeLanguage,
      explanationLanguage: data.explanationLanguage.present
          ? data.explanationLanguage.value
          : this.explanationLanguage,
      confidenceLevel: data.confidenceLevel.present
          ? data.confidenceLevel.value
          : this.confidenceLevel,
      learningGoals: data.learningGoals.present
          ? data.learningGoals.value
          : this.learningGoals,
      difficultAreas: data.difficultAreas.present
          ? data.difficultAreas.value
          : this.difficultAreas,
      dailyStudyMinutes: data.dailyStudyMinutes.present
          ? data.dailyStudyMinutes.value
          : this.dailyStudyMinutes,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      placementResult: data.placementResult.present
          ? data.placementResult.value
          : this.placementResult,
      learningPlanSummary: data.learningPlanSummary.present
          ? data.learningPlanSummary.value
          : this.learningPlanSummary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLearnerProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('nativeLanguage: $nativeLanguage, ')
          ..write('explanationLanguage: $explanationLanguage, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('learningGoals: $learningGoals, ')
          ..write('difficultAreas: $difficultAreas, ')
          ..write('dailyStudyMinutes: $dailyStudyMinutes, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('placementResult: $placementResult, ')
          ..write('learningPlanSummary: $learningPlanSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    nativeLanguage,
    explanationLanguage,
    confidenceLevel,
    learningGoals,
    difficultAreas,
    dailyStudyMinutes,
    onboardingComplete,
    placementResult,
    learningPlanSummary,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLearnerProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.nativeLanguage == this.nativeLanguage &&
          other.explanationLanguage == this.explanationLanguage &&
          other.confidenceLevel == this.confidenceLevel &&
          other.learningGoals == this.learningGoals &&
          other.difficultAreas == this.difficultAreas &&
          other.dailyStudyMinutes == this.dailyStudyMinutes &&
          other.onboardingComplete == this.onboardingComplete &&
          other.placementResult == this.placementResult &&
          other.learningPlanSummary == this.learningPlanSummary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalLearnerProfilesCompanion
    extends UpdateCompanion<LocalLearnerProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> nativeLanguage;
  final Value<String> explanationLanguage;
  final Value<String?> confidenceLevel;
  final Value<String> learningGoals;
  final Value<String> difficultAreas;
  final Value<int?> dailyStudyMinutes;
  final Value<bool> onboardingComplete;
  final Value<String?> placementResult;
  final Value<String?> learningPlanSummary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalLearnerProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.explanationLanguage = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.learningGoals = const Value.absent(),
    this.difficultAreas = const Value.absent(),
    this.dailyStudyMinutes = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.placementResult = const Value.absent(),
    this.learningPlanSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalLearnerProfilesCompanion.insert({
    required String id,
    this.displayName = const Value.absent(),
    this.nativeLanguage = const Value.absent(),
    this.explanationLanguage = const Value.absent(),
    this.confidenceLevel = const Value.absent(),
    this.learningGoals = const Value.absent(),
    this.difficultAreas = const Value.absent(),
    this.dailyStudyMinutes = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.placementResult = const Value.absent(),
    this.learningPlanSummary = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LocalLearnerProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? nativeLanguage,
    Expression<String>? explanationLanguage,
    Expression<String>? confidenceLevel,
    Expression<String>? learningGoals,
    Expression<String>? difficultAreas,
    Expression<int>? dailyStudyMinutes,
    Expression<bool>? onboardingComplete,
    Expression<String>? placementResult,
    Expression<String>? learningPlanSummary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (nativeLanguage != null) 'native_language': nativeLanguage,
      if (explanationLanguage != null)
        'explanation_language': explanationLanguage,
      if (confidenceLevel != null) 'confidence_level': confidenceLevel,
      if (learningGoals != null) 'learning_goals': learningGoals,
      if (difficultAreas != null) 'difficult_areas': difficultAreas,
      if (dailyStudyMinutes != null) 'daily_study_minutes': dailyStudyMinutes,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (placementResult != null) 'placement_result': placementResult,
      if (learningPlanSummary != null)
        'learning_plan_summary': learningPlanSummary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalLearnerProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? nativeLanguage,
    Value<String>? explanationLanguage,
    Value<String?>? confidenceLevel,
    Value<String>? learningGoals,
    Value<String>? difficultAreas,
    Value<int?>? dailyStudyMinutes,
    Value<bool>? onboardingComplete,
    Value<String?>? placementResult,
    Value<String?>? learningPlanSummary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LocalLearnerProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      explanationLanguage: explanationLanguage ?? this.explanationLanguage,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      learningGoals: learningGoals ?? this.learningGoals,
      difficultAreas: difficultAreas ?? this.difficultAreas,
      dailyStudyMinutes: dailyStudyMinutes ?? this.dailyStudyMinutes,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      placementResult: placementResult ?? this.placementResult,
      learningPlanSummary: learningPlanSummary ?? this.learningPlanSummary,
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
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (nativeLanguage.present) {
      map['native_language'] = Variable<String>(nativeLanguage.value);
    }
    if (explanationLanguage.present) {
      map['explanation_language'] = Variable<String>(explanationLanguage.value);
    }
    if (confidenceLevel.present) {
      map['confidence_level'] = Variable<String>(confidenceLevel.value);
    }
    if (learningGoals.present) {
      map['learning_goals'] = Variable<String>(learningGoals.value);
    }
    if (difficultAreas.present) {
      map['difficult_areas'] = Variable<String>(difficultAreas.value);
    }
    if (dailyStudyMinutes.present) {
      map['daily_study_minutes'] = Variable<int>(dailyStudyMinutes.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (placementResult.present) {
      map['placement_result'] = Variable<String>(placementResult.value);
    }
    if (learningPlanSummary.present) {
      map['learning_plan_summary'] = Variable<String>(
        learningPlanSummary.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('LocalLearnerProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('nativeLanguage: $nativeLanguage, ')
          ..write('explanationLanguage: $explanationLanguage, ')
          ..write('confidenceLevel: $confidenceLevel, ')
          ..write('learningGoals: $learningGoals, ')
          ..write('difficultAreas: $difficultAreas, ')
          ..write('dailyStudyMinutes: $dailyStudyMinutes, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('placementResult: $placementResult, ')
          ..write('learningPlanSummary: $learningPlanSummary, ')
          ..write('createdAt: $createdAt, ')
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
  late final $CachedTutorConversationsTable cachedTutorConversations =
      $CachedTutorConversationsTable(this);
  late final $CachedTutorMessagesTable cachedTutorMessages =
      $CachedTutorMessagesTable(this);
  late final $CachedTutorMistakesTable cachedTutorMistakes =
      $CachedTutorMistakesTable(this);
  late final $CachedTutorSummariesTable cachedTutorSummaries =
      $CachedTutorSummariesTable(this);
  late final $TutorDraftsTable tutorDrafts = $TutorDraftsTable(this);
  late final $CachedVoiceSessionsTable cachedVoiceSessions =
      $CachedVoiceSessionsTable(this);
  late final $CachedVoiceTurnsTable cachedVoiceTurns = $CachedVoiceTurnsTable(
    this,
  );
  late final $VoicePreferencesTable voicePreferences = $VoicePreferencesTable(
    this,
  );
  late final $LocalLearnerProfilesTable localLearnerProfiles =
      $LocalLearnerProfilesTable(this);
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
    cachedTutorConversations,
    cachedTutorMessages,
    cachedTutorMistakes,
    cachedTutorSummaries,
    tutorDrafts,
    cachedVoiceSessions,
    cachedVoiceTurns,
    voicePreferences,
    localLearnerProfiles,
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
typedef $$CachedTutorConversationsTableCreateCompanionBuilder =
    CachedTutorConversationsCompanion Function({
      required String id,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedTutorConversationsTableUpdateCompanionBuilder =
    CachedTutorConversationsCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedTutorConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTutorConversationsTable> {
  $$CachedTutorConversationsTableFilterComposer({
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

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTutorConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTutorConversationsTable> {
  $$CachedTutorConversationsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTutorConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTutorConversationsTable> {
  $$CachedTutorConversationsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedTutorConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTutorConversationsTable,
          CachedTutorConversation,
          $$CachedTutorConversationsTableFilterComposer,
          $$CachedTutorConversationsTableOrderingComposer,
          $$CachedTutorConversationsTableAnnotationComposer,
          $$CachedTutorConversationsTableCreateCompanionBuilder,
          $$CachedTutorConversationsTableUpdateCompanionBuilder,
          (
            CachedTutorConversation,
            BaseReferences<
              _$AppDatabase,
              $CachedTutorConversationsTable,
              CachedTutorConversation
            >,
          ),
          CachedTutorConversation,
          PrefetchHooks Function()
        > {
  $$CachedTutorConversationsTableTableManager(
    _$AppDatabase db,
    $CachedTutorConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTutorConversationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedTutorConversationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedTutorConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorConversationsCompanion(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorConversationsCompanion.insert(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTutorConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTutorConversationsTable,
      CachedTutorConversation,
      $$CachedTutorConversationsTableFilterComposer,
      $$CachedTutorConversationsTableOrderingComposer,
      $$CachedTutorConversationsTableAnnotationComposer,
      $$CachedTutorConversationsTableCreateCompanionBuilder,
      $$CachedTutorConversationsTableUpdateCompanionBuilder,
      (
        CachedTutorConversation,
        BaseReferences<
          _$AppDatabase,
          $CachedTutorConversationsTable,
          CachedTutorConversation
        >,
      ),
      CachedTutorConversation,
      PrefetchHooks Function()
    >;
typedef $$CachedTutorMessagesTableCreateCompanionBuilder =
    CachedTutorMessagesCompanion Function({
      required String id,
      required String conversationId,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedTutorMessagesTableUpdateCompanionBuilder =
    CachedTutorMessagesCompanion Function({
      Value<String> id,
      Value<String> conversationId,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedTutorMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTutorMessagesTable> {
  $$CachedTutorMessagesTableFilterComposer({
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

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTutorMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTutorMessagesTable> {
  $$CachedTutorMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTutorMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTutorMessagesTable> {
  $$CachedTutorMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedTutorMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTutorMessagesTable,
          CachedTutorMessage,
          $$CachedTutorMessagesTableFilterComposer,
          $$CachedTutorMessagesTableOrderingComposer,
          $$CachedTutorMessagesTableAnnotationComposer,
          $$CachedTutorMessagesTableCreateCompanionBuilder,
          $$CachedTutorMessagesTableUpdateCompanionBuilder,
          (
            CachedTutorMessage,
            BaseReferences<
              _$AppDatabase,
              $CachedTutorMessagesTable,
              CachedTutorMessage
            >,
          ),
          CachedTutorMessage,
          PrefetchHooks Function()
        > {
  $$CachedTutorMessagesTableTableManager(
    _$AppDatabase db,
    $CachedTutorMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTutorMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTutorMessagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedTutorMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorMessagesCompanion(
                id: id,
                conversationId: conversationId,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String conversationId,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorMessagesCompanion.insert(
                id: id,
                conversationId: conversationId,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTutorMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTutorMessagesTable,
      CachedTutorMessage,
      $$CachedTutorMessagesTableFilterComposer,
      $$CachedTutorMessagesTableOrderingComposer,
      $$CachedTutorMessagesTableAnnotationComposer,
      $$CachedTutorMessagesTableCreateCompanionBuilder,
      $$CachedTutorMessagesTableUpdateCompanionBuilder,
      (
        CachedTutorMessage,
        BaseReferences<
          _$AppDatabase,
          $CachedTutorMessagesTable,
          CachedTutorMessage
        >,
      ),
      CachedTutorMessage,
      PrefetchHooks Function()
    >;
typedef $$CachedTutorMistakesTableCreateCompanionBuilder =
    CachedTutorMistakesCompanion Function({
      required String id,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedTutorMistakesTableUpdateCompanionBuilder =
    CachedTutorMistakesCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedTutorMistakesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTutorMistakesTable> {
  $$CachedTutorMistakesTableFilterComposer({
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

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTutorMistakesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTutorMistakesTable> {
  $$CachedTutorMistakesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTutorMistakesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTutorMistakesTable> {
  $$CachedTutorMistakesTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedTutorMistakesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTutorMistakesTable,
          CachedTutorMistake,
          $$CachedTutorMistakesTableFilterComposer,
          $$CachedTutorMistakesTableOrderingComposer,
          $$CachedTutorMistakesTableAnnotationComposer,
          $$CachedTutorMistakesTableCreateCompanionBuilder,
          $$CachedTutorMistakesTableUpdateCompanionBuilder,
          (
            CachedTutorMistake,
            BaseReferences<
              _$AppDatabase,
              $CachedTutorMistakesTable,
              CachedTutorMistake
            >,
          ),
          CachedTutorMistake,
          PrefetchHooks Function()
        > {
  $$CachedTutorMistakesTableTableManager(
    _$AppDatabase db,
    $CachedTutorMistakesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTutorMistakesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTutorMistakesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedTutorMistakesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorMistakesCompanion(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorMistakesCompanion.insert(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTutorMistakesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTutorMistakesTable,
      CachedTutorMistake,
      $$CachedTutorMistakesTableFilterComposer,
      $$CachedTutorMistakesTableOrderingComposer,
      $$CachedTutorMistakesTableAnnotationComposer,
      $$CachedTutorMistakesTableCreateCompanionBuilder,
      $$CachedTutorMistakesTableUpdateCompanionBuilder,
      (
        CachedTutorMistake,
        BaseReferences<
          _$AppDatabase,
          $CachedTutorMistakesTable,
          CachedTutorMistake
        >,
      ),
      CachedTutorMistake,
      PrefetchHooks Function()
    >;
typedef $$CachedTutorSummariesTableCreateCompanionBuilder =
    CachedTutorSummariesCompanion Function({
      required String conversationId,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedTutorSummariesTableUpdateCompanionBuilder =
    CachedTutorSummariesCompanion Function({
      Value<String> conversationId,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedTutorSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedTutorSummariesTable> {
  $$CachedTutorSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedTutorSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedTutorSummariesTable> {
  $$CachedTutorSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedTutorSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedTutorSummariesTable> {
  $$CachedTutorSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedTutorSummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedTutorSummariesTable,
          CachedTutorSummary,
          $$CachedTutorSummariesTableFilterComposer,
          $$CachedTutorSummariesTableOrderingComposer,
          $$CachedTutorSummariesTableAnnotationComposer,
          $$CachedTutorSummariesTableCreateCompanionBuilder,
          $$CachedTutorSummariesTableUpdateCompanionBuilder,
          (
            CachedTutorSummary,
            BaseReferences<
              _$AppDatabase,
              $CachedTutorSummariesTable,
              CachedTutorSummary
            >,
          ),
          CachedTutorSummary,
          PrefetchHooks Function()
        > {
  $$CachedTutorSummariesTableTableManager(
    _$AppDatabase db,
    $CachedTutorSummariesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedTutorSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedTutorSummariesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedTutorSummariesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> conversationId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorSummariesCompanion(
                conversationId: conversationId,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedTutorSummariesCompanion.insert(
                conversationId: conversationId,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedTutorSummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedTutorSummariesTable,
      CachedTutorSummary,
      $$CachedTutorSummariesTableFilterComposer,
      $$CachedTutorSummariesTableOrderingComposer,
      $$CachedTutorSummariesTableAnnotationComposer,
      $$CachedTutorSummariesTableCreateCompanionBuilder,
      $$CachedTutorSummariesTableUpdateCompanionBuilder,
      (
        CachedTutorSummary,
        BaseReferences<
          _$AppDatabase,
          $CachedTutorSummariesTable,
          CachedTutorSummary
        >,
      ),
      CachedTutorSummary,
      PrefetchHooks Function()
    >;
typedef $$TutorDraftsTableCreateCompanionBuilder =
    TutorDraftsCompanion Function({
      required String conversationId,
      required String draftText,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TutorDraftsTableUpdateCompanionBuilder =
    TutorDraftsCompanion Function({
      Value<String> conversationId,
      Value<String> draftText,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TutorDraftsTableFilterComposer
    extends Composer<_$AppDatabase, $TutorDraftsTable> {
  $$TutorDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get draftText => $composableBuilder(
    column: $table.draftText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TutorDraftsTableOrderingComposer
    extends Composer<_$AppDatabase, $TutorDraftsTable> {
  $$TutorDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get draftText => $composableBuilder(
    column: $table.draftText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TutorDraftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TutorDraftsTable> {
  $$TutorDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get draftText =>
      $composableBuilder(column: $table.draftText, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TutorDraftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TutorDraftsTable,
          TutorDraft,
          $$TutorDraftsTableFilterComposer,
          $$TutorDraftsTableOrderingComposer,
          $$TutorDraftsTableAnnotationComposer,
          $$TutorDraftsTableCreateCompanionBuilder,
          $$TutorDraftsTableUpdateCompanionBuilder,
          (
            TutorDraft,
            BaseReferences<_$AppDatabase, $TutorDraftsTable, TutorDraft>,
          ),
          TutorDraft,
          PrefetchHooks Function()
        > {
  $$TutorDraftsTableTableManager(_$AppDatabase db, $TutorDraftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TutorDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TutorDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TutorDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> conversationId = const Value.absent(),
                Value<String> draftText = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TutorDraftsCompanion(
                conversationId: conversationId,
                draftText: draftText,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String conversationId,
                required String draftText,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TutorDraftsCompanion.insert(
                conversationId: conversationId,
                draftText: draftText,
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

typedef $$TutorDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TutorDraftsTable,
      TutorDraft,
      $$TutorDraftsTableFilterComposer,
      $$TutorDraftsTableOrderingComposer,
      $$TutorDraftsTableAnnotationComposer,
      $$TutorDraftsTableCreateCompanionBuilder,
      $$TutorDraftsTableUpdateCompanionBuilder,
      (
        TutorDraft,
        BaseReferences<_$AppDatabase, $TutorDraftsTable, TutorDraft>,
      ),
      TutorDraft,
      PrefetchHooks Function()
    >;
typedef $$CachedVoiceSessionsTableCreateCompanionBuilder =
    CachedVoiceSessionsCompanion Function({
      required String id,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedVoiceSessionsTableUpdateCompanionBuilder =
    CachedVoiceSessionsCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedVoiceSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedVoiceSessionsTable> {
  $$CachedVoiceSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedVoiceSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedVoiceSessionsTable> {
  $$CachedVoiceSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedVoiceSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedVoiceSessionsTable> {
  $$CachedVoiceSessionsTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedVoiceSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedVoiceSessionsTable,
          CachedVoiceSession,
          $$CachedVoiceSessionsTableFilterComposer,
          $$CachedVoiceSessionsTableOrderingComposer,
          $$CachedVoiceSessionsTableAnnotationComposer,
          $$CachedVoiceSessionsTableCreateCompanionBuilder,
          $$CachedVoiceSessionsTableUpdateCompanionBuilder,
          (
            CachedVoiceSession,
            BaseReferences<
              _$AppDatabase,
              $CachedVoiceSessionsTable,
              CachedVoiceSession
            >,
          ),
          CachedVoiceSession,
          PrefetchHooks Function()
        > {
  $$CachedVoiceSessionsTableTableManager(
    _$AppDatabase db,
    $CachedVoiceSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedVoiceSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedVoiceSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedVoiceSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedVoiceSessionsCompanion(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedVoiceSessionsCompanion.insert(
                id: id,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedVoiceSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedVoiceSessionsTable,
      CachedVoiceSession,
      $$CachedVoiceSessionsTableFilterComposer,
      $$CachedVoiceSessionsTableOrderingComposer,
      $$CachedVoiceSessionsTableAnnotationComposer,
      $$CachedVoiceSessionsTableCreateCompanionBuilder,
      $$CachedVoiceSessionsTableUpdateCompanionBuilder,
      (
        CachedVoiceSession,
        BaseReferences<
          _$AppDatabase,
          $CachedVoiceSessionsTable,
          CachedVoiceSession
        >,
      ),
      CachedVoiceSession,
      PrefetchHooks Function()
    >;
typedef $$CachedVoiceTurnsTableCreateCompanionBuilder =
    CachedVoiceTurnsCompanion Function({
      required String id,
      required String sessionId,
      required String payload,
      Value<String?> tutorAudioId,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CachedVoiceTurnsTableUpdateCompanionBuilder =
    CachedVoiceTurnsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> payload,
      Value<String?> tutorAudioId,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CachedVoiceTurnsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedVoiceTurnsTable> {
  $$CachedVoiceTurnsTableFilterComposer({
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

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tutorAudioId => $composableBuilder(
    column: $table.tutorAudioId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedVoiceTurnsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedVoiceTurnsTable> {
  $$CachedVoiceTurnsTableOrderingComposer({
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

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tutorAudioId => $composableBuilder(
    column: $table.tutorAudioId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedVoiceTurnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedVoiceTurnsTable> {
  $$CachedVoiceTurnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get tutorAudioId => $composableBuilder(
    column: $table.tutorAudioId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedVoiceTurnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedVoiceTurnsTable,
          CachedVoiceTurn,
          $$CachedVoiceTurnsTableFilterComposer,
          $$CachedVoiceTurnsTableOrderingComposer,
          $$CachedVoiceTurnsTableAnnotationComposer,
          $$CachedVoiceTurnsTableCreateCompanionBuilder,
          $$CachedVoiceTurnsTableUpdateCompanionBuilder,
          (
            CachedVoiceTurn,
            BaseReferences<
              _$AppDatabase,
              $CachedVoiceTurnsTable,
              CachedVoiceTurn
            >,
          ),
          CachedVoiceTurn,
          PrefetchHooks Function()
        > {
  $$CachedVoiceTurnsTableTableManager(
    _$AppDatabase db,
    $CachedVoiceTurnsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedVoiceTurnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedVoiceTurnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedVoiceTurnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> tutorAudioId = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedVoiceTurnsCompanion(
                id: id,
                sessionId: sessionId,
                payload: payload,
                tutorAudioId: tutorAudioId,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String payload,
                Value<String?> tutorAudioId = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedVoiceTurnsCompanion.insert(
                id: id,
                sessionId: sessionId,
                payload: payload,
                tutorAudioId: tutorAudioId,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedVoiceTurnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedVoiceTurnsTable,
      CachedVoiceTurn,
      $$CachedVoiceTurnsTableFilterComposer,
      $$CachedVoiceTurnsTableOrderingComposer,
      $$CachedVoiceTurnsTableAnnotationComposer,
      $$CachedVoiceTurnsTableCreateCompanionBuilder,
      $$CachedVoiceTurnsTableUpdateCompanionBuilder,
      (
        CachedVoiceTurn,
        BaseReferences<_$AppDatabase, $CachedVoiceTurnsTable, CachedVoiceTurn>,
      ),
      CachedVoiceTurn,
      PrefetchHooks Function()
    >;
typedef $$VoicePreferencesTableCreateCompanionBuilder =
    VoicePreferencesCompanion Function({
      required String id,
      required String payload,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$VoicePreferencesTableUpdateCompanionBuilder =
    VoicePreferencesCompanion Function({
      Value<String> id,
      Value<String> payload,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$VoicePreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $VoicePreferencesTable> {
  $$VoicePreferencesTableFilterComposer({
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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VoicePreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $VoicePreferencesTable> {
  $$VoicePreferencesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VoicePreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VoicePreferencesTable> {
  $$VoicePreferencesTableAnnotationComposer({
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

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VoicePreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VoicePreferencesTable,
          VoicePreference,
          $$VoicePreferencesTableFilterComposer,
          $$VoicePreferencesTableOrderingComposer,
          $$VoicePreferencesTableAnnotationComposer,
          $$VoicePreferencesTableCreateCompanionBuilder,
          $$VoicePreferencesTableUpdateCompanionBuilder,
          (
            VoicePreference,
            BaseReferences<
              _$AppDatabase,
              $VoicePreferencesTable,
              VoicePreference
            >,
          ),
          VoicePreference,
          PrefetchHooks Function()
        > {
  $$VoicePreferencesTableTableManager(
    _$AppDatabase db,
    $VoicePreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VoicePreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VoicePreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VoicePreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VoicePreferencesCompanion(
                id: id,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String payload,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => VoicePreferencesCompanion.insert(
                id: id,
                payload: payload,
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

typedef $$VoicePreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VoicePreferencesTable,
      VoicePreference,
      $$VoicePreferencesTableFilterComposer,
      $$VoicePreferencesTableOrderingComposer,
      $$VoicePreferencesTableAnnotationComposer,
      $$VoicePreferencesTableCreateCompanionBuilder,
      $$VoicePreferencesTableUpdateCompanionBuilder,
      (
        VoicePreference,
        BaseReferences<_$AppDatabase, $VoicePreferencesTable, VoicePreference>,
      ),
      VoicePreference,
      PrefetchHooks Function()
    >;
typedef $$LocalLearnerProfilesTableCreateCompanionBuilder =
    LocalLearnerProfilesCompanion Function({
      required String id,
      Value<String> displayName,
      Value<String> nativeLanguage,
      Value<String> explanationLanguage,
      Value<String?> confidenceLevel,
      Value<String> learningGoals,
      Value<String> difficultAreas,
      Value<int?> dailyStudyMinutes,
      Value<bool> onboardingComplete,
      Value<String?> placementResult,
      Value<String?> learningPlanSummary,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LocalLearnerProfilesTableUpdateCompanionBuilder =
    LocalLearnerProfilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> nativeLanguage,
      Value<String> explanationLanguage,
      Value<String?> confidenceLevel,
      Value<String> learningGoals,
      Value<String> difficultAreas,
      Value<int?> dailyStudyMinutes,
      Value<bool> onboardingComplete,
      Value<String?> placementResult,
      Value<String?> learningPlanSummary,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LocalLearnerProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalLearnerProfilesTable> {
  $$LocalLearnerProfilesTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nativeLanguage => $composableBuilder(
    column: $table.nativeLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationLanguage => $composableBuilder(
    column: $table.explanationLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficultAreas => $composableBuilder(
    column: $table.difficultAreas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyStudyMinutes => $composableBuilder(
    column: $table.dailyStudyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placementResult => $composableBuilder(
    column: $table.placementResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningPlanSummary => $composableBuilder(
    column: $table.learningPlanSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalLearnerProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalLearnerProfilesTable> {
  $$LocalLearnerProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nativeLanguage => $composableBuilder(
    column: $table.nativeLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationLanguage => $composableBuilder(
    column: $table.explanationLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficultAreas => $composableBuilder(
    column: $table.difficultAreas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyStudyMinutes => $composableBuilder(
    column: $table.dailyStudyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placementResult => $composableBuilder(
    column: $table.placementResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningPlanSummary => $composableBuilder(
    column: $table.learningPlanSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalLearnerProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalLearnerProfilesTable> {
  $$LocalLearnerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nativeLanguage => $composableBuilder(
    column: $table.nativeLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanationLanguage => $composableBuilder(
    column: $table.explanationLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidenceLevel => $composableBuilder(
    column: $table.confidenceLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningGoals => $composableBuilder(
    column: $table.learningGoals,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficultAreas => $composableBuilder(
    column: $table.difficultAreas,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyStudyMinutes => $composableBuilder(
    column: $table.dailyStudyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placementResult => $composableBuilder(
    column: $table.placementResult,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningPlanSummary => $composableBuilder(
    column: $table.learningPlanSummary,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalLearnerProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalLearnerProfilesTable,
          LocalLearnerProfile,
          $$LocalLearnerProfilesTableFilterComposer,
          $$LocalLearnerProfilesTableOrderingComposer,
          $$LocalLearnerProfilesTableAnnotationComposer,
          $$LocalLearnerProfilesTableCreateCompanionBuilder,
          $$LocalLearnerProfilesTableUpdateCompanionBuilder,
          (
            LocalLearnerProfile,
            BaseReferences<
              _$AppDatabase,
              $LocalLearnerProfilesTable,
              LocalLearnerProfile
            >,
          ),
          LocalLearnerProfile,
          PrefetchHooks Function()
        > {
  $$LocalLearnerProfilesTableTableManager(
    _$AppDatabase db,
    $LocalLearnerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalLearnerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalLearnerProfilesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalLearnerProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> nativeLanguage = const Value.absent(),
                Value<String> explanationLanguage = const Value.absent(),
                Value<String?> confidenceLevel = const Value.absent(),
                Value<String> learningGoals = const Value.absent(),
                Value<String> difficultAreas = const Value.absent(),
                Value<int?> dailyStudyMinutes = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String?> placementResult = const Value.absent(),
                Value<String?> learningPlanSummary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalLearnerProfilesCompanion(
                id: id,
                displayName: displayName,
                nativeLanguage: nativeLanguage,
                explanationLanguage: explanationLanguage,
                confidenceLevel: confidenceLevel,
                learningGoals: learningGoals,
                difficultAreas: difficultAreas,
                dailyStudyMinutes: dailyStudyMinutes,
                onboardingComplete: onboardingComplete,
                placementResult: placementResult,
                learningPlanSummary: learningPlanSummary,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> displayName = const Value.absent(),
                Value<String> nativeLanguage = const Value.absent(),
                Value<String> explanationLanguage = const Value.absent(),
                Value<String?> confidenceLevel = const Value.absent(),
                Value<String> learningGoals = const Value.absent(),
                Value<String> difficultAreas = const Value.absent(),
                Value<int?> dailyStudyMinutes = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String?> placementResult = const Value.absent(),
                Value<String?> learningPlanSummary = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LocalLearnerProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                nativeLanguage: nativeLanguage,
                explanationLanguage: explanationLanguage,
                confidenceLevel: confidenceLevel,
                learningGoals: learningGoals,
                difficultAreas: difficultAreas,
                dailyStudyMinutes: dailyStudyMinutes,
                onboardingComplete: onboardingComplete,
                placementResult: placementResult,
                learningPlanSummary: learningPlanSummary,
                createdAt: createdAt,
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

typedef $$LocalLearnerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalLearnerProfilesTable,
      LocalLearnerProfile,
      $$LocalLearnerProfilesTableFilterComposer,
      $$LocalLearnerProfilesTableOrderingComposer,
      $$LocalLearnerProfilesTableAnnotationComposer,
      $$LocalLearnerProfilesTableCreateCompanionBuilder,
      $$LocalLearnerProfilesTableUpdateCompanionBuilder,
      (
        LocalLearnerProfile,
        BaseReferences<
          _$AppDatabase,
          $LocalLearnerProfilesTable,
          LocalLearnerProfile
        >,
      ),
      LocalLearnerProfile,
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
  $$CachedTutorConversationsTableTableManager get cachedTutorConversations =>
      $$CachedTutorConversationsTableTableManager(
        _db,
        _db.cachedTutorConversations,
      );
  $$CachedTutorMessagesTableTableManager get cachedTutorMessages =>
      $$CachedTutorMessagesTableTableManager(_db, _db.cachedTutorMessages);
  $$CachedTutorMistakesTableTableManager get cachedTutorMistakes =>
      $$CachedTutorMistakesTableTableManager(_db, _db.cachedTutorMistakes);
  $$CachedTutorSummariesTableTableManager get cachedTutorSummaries =>
      $$CachedTutorSummariesTableTableManager(_db, _db.cachedTutorSummaries);
  $$TutorDraftsTableTableManager get tutorDrafts =>
      $$TutorDraftsTableTableManager(_db, _db.tutorDrafts);
  $$CachedVoiceSessionsTableTableManager get cachedVoiceSessions =>
      $$CachedVoiceSessionsTableTableManager(_db, _db.cachedVoiceSessions);
  $$CachedVoiceTurnsTableTableManager get cachedVoiceTurns =>
      $$CachedVoiceTurnsTableTableManager(_db, _db.cachedVoiceTurns);
  $$VoicePreferencesTableTableManager get voicePreferences =>
      $$VoicePreferencesTableTableManager(_db, _db.voicePreferences);
  $$LocalLearnerProfilesTableTableManager get localLearnerProfiles =>
      $$LocalLearnerProfilesTableTableManager(_db, _db.localLearnerProfiles);
}
