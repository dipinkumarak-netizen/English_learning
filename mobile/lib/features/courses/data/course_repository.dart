import 'dart:convert';
import 'package:drift/drift.dart';

import '../../../core/local/app_database.dart';
import '../../../core/network/api_client.dart';

class CourseRepository {
  CourseRepository(this._client, this._database, this._readToken);

  final ApiClient _client;
  final AppDatabase _database;
  final Future<String?> Function() _readToken;

  Future<List<Map<String, dynamic>>> courses() async {
    try {
      final token = await _readToken();
      if (token == null) {
        final cached = await _database.select(_database.cachedCourses).get();
        return cached.isNotEmpty
            ? cached
                  .map(
                    (item) => jsonDecode(item.payload) as Map<String, dynamic>,
                  )
                  .toList()
            : [_offlineCourse];
      }
      final response = await _client.get('/api/v1/courses', accessToken: token);
      for (final course in response['courses'] as List<dynamic>? ?? const []) {
        final item = course as Map<String, dynamic>;
        await _database.cacheCourse(
          item['id'] as String,
          jsonEncode(item),
          item['version'] as int? ?? 1,
        );
      }
      return (response['courses'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
    } catch (_) {
      final cached = await _database.select(_database.cachedCourses).get();
      return cached
          .map((item) => jsonDecode(item.payload) as Map<String, dynamic>)
          .toList();
    }
  }

  Future<Map<String, dynamic>> course(String id) async {
    try {
      final token = await _readToken();
      if (token == null) return _offlineCourseWithModules;
      final response = await _client.get(
        '/api/v1/courses/$id',
        accessToken: token,
      );
      await _database.cacheCourse(
        response['id'] as String,
        jsonEncode(response),
        response['version'] as int? ?? 1,
      );
      return response;
    } catch (_) {
      final cached = await (_database.select(
        _database.cachedCourses,
      )..where((row) => row.id.equals(id))).getSingleOrNull();
      if (cached == null) rethrow;
      return jsonDecode(cached.payload) as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> lesson(String id) async {
    final token = await _readToken();
    if (token == null) return _offlineLesson;
    return _client.get('/api/v1/lessons/$id', accessToken: token);
  }

  Future<Map<String, dynamic>> startLesson(String id) async {
    final token = await _readToken();
    if (token == null) return {'id': 'offline-lesson', 'status': 'started'};
    return _client.post('/api/v1/lessons/$id/start', accessToken: token);
  }

  Future<Map<String, dynamic>> completeStep(
    String lessonId,
    String stepId,
    String operationId,
  ) async {
    final token = await _readToken();
    if (token == null) {
      await _database
          .into(_database.localLessonProgress)
          .insertOnConflictUpdate(
            LocalLessonProgressCompanion.insert(
              lessonId: lessonId,
              currentStepId: Value(stepId),
              completedStepIds: jsonEncode([stepId]),
              updatedAt: DateTime.now(),
            ),
          );
      return {'completed': true};
    }
    return _client.put(
      '/api/v1/lessons/$lessonId/steps/$stepId/progress',
      accessToken: token,
      data: {'completed': true, 'client_operation_id': operationId},
    );
  }

  Future<Map<String, dynamic>> submitExercise(
    String exerciseId,
    Object answer,
    String operationId,
  ) async {
    final token = await _readToken();
    if (token == null) return {'is_correct': true, 'score': 100};
    return _client.post(
      '/api/v1/exercises/$exerciseId/attempts',
      accessToken: token,
      data: {'answer': answer, 'client_operation_id': operationId},
    );
  }

  Future<Map<String, dynamic>> completeLesson(String lessonId) async {
    final token = await _readToken();
    if (token == null) {
      final existing = await (_database.select(
        _database.localLessonProgress,
      )..where((row) => row.lessonId.equals(lessonId))).getSingleOrNull();
      await _database
          .into(_database.localLessonProgress)
          .insertOnConflictUpdate(
            LocalLessonProgressCompanion.insert(
              lessonId: lessonId,
              currentStepId: Value(existing?.currentStepId),
              completedStepIds: existing?.completedStepIds ?? '[]',
              score: const Value(100),
              syncState: const Value('local-only'),
              updatedAt: DateTime.now(),
            ),
          );
      return {'score': 100};
    }
    return _client.post(
      '/api/v1/lessons/$lessonId/complete',
      accessToken: token,
    );
  }
}

const _offlineCourse = {
  'id': 'offline-foundations',
  'title': 'Everyday English foundations',
  'learner_level': 'A1',
  'estimated_total_minutes': 30,
  'short_description': 'A starter course available without an account.',
  'completion_percentage': 0,
};

const _offlineCourseWithModules = {
  ..._offlineCourse,
  'modules': [
    {
      'id': 'offline-module',
      'title': 'Foundations',
      'description': 'Start with useful everyday sentences.',
      'lessons': [
        {
          'id': 'offline-lesson',
          'title': 'Simple English sentences',
          'summary': 'Subject and verb basics.',
          'completed': false,
          'score': 0,
          'unlocked': true,
        },
      ],
    },
  ],
};

const _offlineLesson = {
  'id': 'offline-lesson',
  'title': 'Simple English sentences',
  'steps': [
    {
      'id': 'offline-step-1',
      'title': 'A simple sentence',
      'step_type': 'explanation',
      'content_en': 'A simple sentence has a subject and a verb.',
      'explanation_ml': 'ലളിതമായ വാക്യത്തിൽ subject, verb എന്നിവ ഉണ്ടാകും.',
    },
    {
      'id': 'offline-step-2',
      'title': 'Practice',
      'step_type': 'exercise',
      'content_en': 'Choose the correct sentence.',
      'exercise': {
        'id': 'offline-exercise',
        'exercise_type': 'single_choice',
        'options': ['I am happy.', 'I happy am.'],
        'explanation_en': 'Use subject + verb + complement.',
      },
    },
  ],
};
