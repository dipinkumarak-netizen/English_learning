import 'dart:convert';

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
      if (token == null) throw StateError('No session');
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
      if (token == null) throw StateError('No session');
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
    if (token == null) throw StateError('No session');
    return _client.get('/api/v1/lessons/$id', accessToken: token);
  }

  Future<Map<String, dynamic>> startLesson(String id) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    return _client.post('/api/v1/lessons/$id/start', accessToken: token);
  }

  Future<Map<String, dynamic>> completeStep(
    String lessonId,
    String stepId,
    String operationId,
  ) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
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
    if (token == null) throw StateError('No session');
    return _client.post(
      '/api/v1/exercises/$exerciseId/attempts',
      accessToken: token,
      data: {'answer': answer, 'client_operation_id': operationId},
    );
  }

  Future<Map<String, dynamic>> completeLesson(String lessonId) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    return _client.post(
      '/api/v1/lessons/$lessonId/complete',
      accessToken: token,
    );
  }
}
