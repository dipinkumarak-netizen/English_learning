import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class CachedCourses extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  IntColumn get contentVersion => integer()();
  DateTimeColumn get cachedAt => dateTime()();
  BoolColumn get isStale => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedModules extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text()();
  TextColumn get payload => text()();
  IntColumn get contentVersion => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedLessons extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text()();
  TextColumn get payload => text()();
  IntColumn get contentVersion => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedLessonSteps extends Table {
  TextColumn get id => text()();
  TextColumn get lessonId => text()();
  TextColumn get payload => text()();
  IntColumn get contentVersion => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalLessonProgress extends Table {
  TextColumn get lessonId => text()();
  TextColumn get currentStepId => text().nullable()();
  TextColumn get completedStepIds => text()();
  RealColumn get score => real().withDefault(const Constant(0))();
  TextColumn get syncState =>
      text().withDefault(const Constant('local-only'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {lessonId};
}

class PendingSyncOperations extends Table {
  TextColumn get clientOperationId => text()();
  TextColumn get operationType => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {clientOperationId};
}

class CacheMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    CachedCourses,
    CachedModules,
    CachedLessons,
    CachedLessonSteps,
    LocalLessonProgress,
    PendingSyncOperations,
    CacheMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> cacheCourse(String id, String payload, int version) =>
      into(cachedCourses).insertOnConflictUpdate(
        CachedCoursesCompanion.insert(
          id: id,
          payload: payload,
          contentVersion: version,
          cachedAt: DateTime.now(),
        ),
      );

  Future<void> enqueueProgress(PendingSyncOperationsCompanion operation) =>
      into(pendingSyncOperations).insertOnConflictUpdate(operation);

  Future<List<PendingSyncOperation>> pendingOperations() => (select(
    pendingSyncOperations,
  )..where((row) => row.syncStatus.equals('pending'))).get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}nilaspeak.sqlite',
    );
    return NativeDatabase(file);
  });
}
