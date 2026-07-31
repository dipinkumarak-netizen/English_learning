import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../core/local/app_database.dart';
import '../../../core/network/api_client.dart';

class VoiceRepository {
  VoiceRepository(this._client, this._database, this._readToken);

  final ApiClient _client;
  final AppDatabase _database;
  final Future<String?> Function() _readToken;

  Future<String> _token() async =>
      await _readToken() ??
      (throw StateError('Voice conversation requires sign-in.'));

  Future<Map<String, dynamic>> createSession(String conversationId) async {
    final response = await _client.post(
      '/api/v1/voice/sessions',
      accessToken: await _token(),
      data: {'conversation_id': conversationId, 'recording_mode': 'tap'},
    );
    await _database
        .into(_database.cachedVoiceSessions)
        .insertOnConflictUpdate(
          CachedVoiceSessionsCompanion.insert(
            id: response['id'] as String,
            payload: jsonEncode(response),
            cachedAt: DateTime.now(),
          ),
        );
    return response;
  }

  Future<Map<String, dynamic>> createTurn(
    String sessionId,
    String operationId,
  ) async => _client.postMultipart(
    '/api/v1/voice/sessions/$sessionId/turns',
    accessToken: await _token(),
    data: FormData.fromMap({'client_operation_id': operationId}),
  );

  Future<Map<String, dynamic>> uploadAudio(
    String turnId,
    String path,
    int durationSeconds,
    String operationId,
  ) async => _client.postMultipart(
    '/api/v1/voice/turns/$turnId/audio',
    accessToken: await _token(),
    data: FormData.fromMap({
      'audio': await MultipartFile.fromFile(path, filename: 'recording.m4a'),
      'declared_duration_seconds': durationSeconds,
      'operation_id': operationId,
    }),
  );

  Future<Map<String, dynamic>> transcribe(
    String turnId,
    String operationId,
  ) async => _client.get(
    '/api/v1/voice/turns/$turnId/transcribe?operation_id=$operationId',
    accessToken: await _token(),
  );

  Future<Map<String, dynamic>> editTranscript(
    String turnId,
    String transcript,
  ) async => _client.patch(
    '/api/v1/voice/turns/$turnId/transcript',
    accessToken: await _token(),
    data: {'transcript': transcript},
  );

  Future<Map<String, dynamic>> submit(
    String turnId,
    String operationId,
  ) async => _client.post(
    '/api/v1/voice/turns/$turnId/submit',
    accessToken: await _token(),
    data: {'client_operation_id': operationId},
  );

  Future<Map<String, dynamic>> synthesise(
    String turnId,
    String operationId,
  ) async => _client.post(
    '/api/v1/voice/turns/$turnId/synthesise',
    accessToken: await _token(),
    data: {'client_operation_id': operationId, 'text_kind': 'reply'},
  );

  Future<List<int>> audio(String audioId) async => _client.downloadBytes(
    '/api/v1/voice/audio/$audioId',
    accessToken: await _token(),
  );

  Future<void> cacheTurn(String sessionId, Map<String, dynamic> turn) async {
    await _database
        .into(_database.cachedVoiceTurns)
        .insertOnConflictUpdate(
          CachedVoiceTurnsCompanion.insert(
            id: turn['id'] as String,
            sessionId: sessionId,
            payload: jsonEncode(turn),
            tutorAudioId: Value(turn['tutor_audio_id'] as String?),
            cachedAt: DateTime.now(),
          ),
        );
  }
}
