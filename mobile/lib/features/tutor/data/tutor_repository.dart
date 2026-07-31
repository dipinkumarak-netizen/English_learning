import 'dart:convert';

import '../../../core/local/app_database.dart';
import '../../../core/network/api_client.dart';

class TutorRepository {
  TutorRepository(this._client, this._database, this._readToken);
  final ApiClient _client;
  final AppDatabase _database;
  final Future<String?> Function() _readToken;

  Future<Map<String, dynamic>> modes() => _get('/api/v1/tutor/modes');

  Future<List<Map<String, dynamic>>> conversations() async {
    try {
      final response = await _get('/api/v1/tutor/conversations');
      for (final item
          in response['conversations'] as List<dynamic>? ?? const []) {
        final map = item as Map<String, dynamic>;
        await _database.cacheTutorConversation(
          map['id'] as String,
          jsonEncode(map),
        );
      }
      return (response['conversations'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
    } catch (_) {
      final cached = await _database
          .select(_database.cachedTutorConversations)
          .get();
      return cached
          .map((item) => jsonDecode(item.payload) as Map<String, dynamic>)
          .toList();
    }
  }

  Future<Map<String, dynamic>> createConversation(
    String mode,
    String correctionMode,
  ) => _post('/api/v1/tutor/conversations', {
    'mode': mode,
    'correction_mode': correctionMode,
  });

  Future<List<Map<String, dynamic>>> messages(String conversationId) async {
    try {
      final response = await _get(
        '/api/v1/tutor/conversations/$conversationId/messages',
      );
      for (final item in response['messages'] as List<dynamic>? ?? const []) {
        final map = item as Map<String, dynamic>;
        await _database.cacheTutorMessage(
          map['id'] as String,
          conversationId,
          jsonEncode(map),
        );
      }
      return (response['messages'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();
    } catch (_) {
      final cached = await (_database.select(
        _database.cachedTutorMessages,
      )..where((row) => row.conversationId.equals(conversationId))).get();
      return cached
          .map((item) => jsonDecode(item.payload) as Map<String, dynamic>)
          .toList();
    }
  }

  Future<Map<String, dynamic>> send(
    String conversationId,
    String text,
    String operationId,
  ) => _post('/api/v1/tutor/conversations/$conversationId/messages', {
    'text': text,
    'client_operation_id': operationId,
  });

  Future<Map<String, dynamic>> complete(String conversationId) =>
      _post('/api/v1/tutor/conversations/$conversationId/complete', null);

  Future<Map<String, dynamic>> usage() => _get('/api/v1/tutor/usage');

  Future<Map<String, dynamic>> mistakes() => _get('/api/v1/tutor/mistakes');

  Future<Map<String, dynamic>> updateMistake(
    String id,
    Map<String, dynamic> data,
  ) => _put('/api/v1/tutor/mistakes/$id', data);

  Future<Map<String, dynamic>> _get(String path) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    return _client.get(path, accessToken: token);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic>? data,
  ) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    return _client.post(path, data: data, accessToken: token);
  }

  Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> data,
  ) async {
    final token = await _readToken();
    if (token == null) throw StateError('No session');
    return _client.put(path, data: data, accessToken: token);
  }
}
