import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/core/local/app_database.dart';
import 'package:nilaspeak_mobile/core/network/api_client.dart';
import 'package:nilaspeak_mobile/features/authentication/data/token_storage.dart';
import 'package:nilaspeak_mobile/features/voice/data/voice_repository.dart';

class _Tokens implements TokenStorage {
  String? access = 'expired-access';

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => 'refresh-token';

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
  }

  @override
  Future<void> clear() async => access = null;
}

class _TranscriptionAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (options.uri.path == '/api/v1/auth/refresh') {
      return ResponseBody.fromString(
        jsonEncode({
          'access_token': 'fresh-access',
          'refresh_token': 'fresh-refresh',
        }),
        200,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    if (options.method == 'POST' &&
        options.uri.path.endsWith('/transcribe') &&
        options.uri.queryParameters['operation_id'] == 'stt-operation-1' &&
        options.headers['Authorization'] == 'Bearer fresh-access') {
      return ResponseBody.fromString(
        jsonEncode({'transcript': 'I am practising English.'}),
        200,
        headers: const {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromString('{}', 401);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'transcription uses POST and preserves query through auth refresh',
    () async {
      final adapter = _TranscriptionAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
        ..httpClientAdapter = adapter;
      final database = AppDatabase();
      addTearDown(database.close);
      final tokens = _Tokens();
      final repository = VoiceRepository(
        ApiClient(dio: dio, tokens: tokens),
        database,
        tokens.readAccessToken,
      );

      final result = await repository.transcribe('turn-1', 'stt-operation-1');

      expect(result['transcript'], 'I am practising English.');
      final transcriptionRequests = adapter.requests
          .where((request) => request.uri.path.endsWith('/transcribe'))
          .toList();
      expect(transcriptionRequests, hasLength(2));
      expect(
        transcriptionRequests.every((request) => request.method == 'POST'),
        isTrue,
      );
      expect(
        transcriptionRequests.every(
          (request) =>
              request.uri.queryParameters['operation_id'] == 'stt-operation-1',
        ),
        isTrue,
      );
    },
  );
}
