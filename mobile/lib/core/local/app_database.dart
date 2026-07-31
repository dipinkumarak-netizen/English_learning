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

class CachedTutorConversations extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedTutorMessages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedTutorMistakes extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedTutorSummaries extends Table {
  TextColumn get conversationId => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {conversationId};
}

class TutorDrafts extends Table {
  TextColumn get conversationId => text()();
  TextColumn get draftText => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {conversationId};
}

class CachedVoiceSessions extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CachedVoiceTurns extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get payload => text()();
  TextColumn get tutorAudioId => text().nullable()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class VoicePreferences extends Table {
  TextColumn get id => text()();
  TextColumn get payload => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class LocalLearnerProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant('Learner'))();
  TextColumn get nativeLanguage => text().withDefault(const Constant('ml'))();
  TextColumn get explanationLanguage =>
      text().withDefault(const Constant('ml'))();
  TextColumn get confidenceLevel => text().nullable()();
  TextColumn get learningGoals => text().withDefault(const Constant('[]'))();
  TextColumn get difficultAreas => text().withDefault(const Constant('[]'))();
  IntColumn get dailyStudyMinutes => integer().nullable()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  TextColumn get placementResult => text().nullable()();
  TextColumn get learningPlanSummary => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
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
    CachedTutorConversations,
    CachedTutorMessages,
    CachedTutorMistakes,
    CachedTutorSummaries,
    TutorDrafts,
    CachedVoiceSessions,
    CachedVoiceTurns,
    VoicePreferences,
    LocalLearnerProfiles,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(cachedTutorConversations);
        await m.createTable(cachedTutorMessages);
        await m.createTable(cachedTutorMistakes);
        await m.createTable(cachedTutorSummaries);
        await m.createTable(tutorDrafts);
      }
      if (from < 3) await m.createTable(localLearnerProfiles);
      if (from < 4) {
        await m.createTable(cachedVoiceSessions);
        await m.createTable(cachedVoiceTurns);
        await m.createTable(voicePreferences);
      }
    },
  );

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

  Future<void> cacheTutorConversation(String id, String payload) =>
      into(cachedTutorConversations).insertOnConflictUpdate(
        CachedTutorConversationsCompanion.insert(
          id: id,
          payload: payload,
          cachedAt: DateTime.now(),
        ),
      );

  Future<void> cacheTutorMessage(
    String id,
    String conversationId,
    String payload,
  ) => into(cachedTutorMessages).insertOnConflictUpdate(
    CachedTutorMessagesCompanion.insert(
      id: id,
      conversationId: conversationId,
      payload: payload,
      cachedAt: DateTime.now(),
    ),
  );

  Future<LocalLearnerProfile?> localProfile() =>
      select(localLearnerProfiles).getSingleOrNull();

  Future<void> saveLocalProfile(LocalLearnerProfilesCompanion profile) =>
      into(localLearnerProfiles).insertOnConflictUpdate(profile);

  Future<void> resetLocalLearningData() async {
    await delete(localLearnerProfiles).go();
    await delete(localLessonProgress).go();
    await delete(pendingSyncOperations).go();
    await delete(cachedTutorConversations).go();
    await delete(cachedTutorMessages).go();
    await delete(cachedTutorMistakes).go();
    await delete(cachedTutorSummaries).go();
    await delete(tutorDrafts).go();
  }
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
