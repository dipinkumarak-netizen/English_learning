import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/core/network/api_client.dart';
import 'package:nilaspeak_mobile/features/authentication/data/token_storage.dart';

class MemoryTokenStorage implements TokenStorage {
  String? access = 'expired-access';
  String? refresh = 'refresh-token';
  int writes = 0;
  int clears = 0;

  @override
  Future<String?> readAccessToken() async => access;

  @override
  Future<String?> readRefreshToken() async => refresh;

  @override
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    access = accessToken;
    refresh = refreshToken;
    writes++;
  }

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
    clears++;
  }
}

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter({this.refreshFails = false, this.delayRefresh = false});
  final bool refreshFails;
  final bool delayRefresh;
  int refreshCalls = 0;
  int protectedCalls = 0;
  Completer<void>? refreshGate;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.path == '/api/v1/auth/refresh') {
      refreshCalls++;
      if (delayRefresh) {
        refreshGate ??= Completer<void>();
        await refreshGate!.future;
      }
      if (refreshFails) {
        return ResponseBody.fromString('{}', 401, headers: _jsonHeaders);
      }
      return ResponseBody.fromString(
        jsonEncode({
          'access_token': 'fresh-access',
          'refresh_token': 'fresh-refresh',
        }),
        200,
        headers: _jsonHeaders,
      );
    }
    protectedCalls++;
    if (options.headers['Authorization'] == 'Bearer fresh-access') {
      return ResponseBody.fromString(
        jsonEncode({'ok': true}),
        200,
        headers: _jsonHeaders,
      );
    }
    return ResponseBody.fromString('{}', 401, headers: _jsonHeaders);
  }

  @override
  void close({bool force = false}) {}
}

const _jsonHeaders = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

void main() {
  test('refreshes once and retries the failed request', () async {
    final tokens = MemoryTokenStorage();
    final adapter = FakeAdapter();
    final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
      ..httpClientAdapter = adapter;
    final client = ApiClient(dio: dio, tokens: tokens);

    expect(await client.get('/protected', accessToken: 'expired-access'), {
      'ok': true,
    });
    expect(adapter.refreshCalls, 1);
    expect(adapter.protectedCalls, 2);
    expect(tokens.writes, 1);
  });

  test('clears tokens when refresh fails', () async {
    final tokens = MemoryTokenStorage();
    final adapter = FakeAdapter(refreshFails: true);
    final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
      ..httpClientAdapter = adapter;
    final client = ApiClient(dio: dio, tokens: tokens);

    await expectLater(
      client.get('/protected', accessToken: 'expired-access'),
      throwsException,
    );
    expect(adapter.refreshCalls, 1);
    expect(tokens.clears, 1);
    expect(tokens.access, isNull);
  });

  test('coalesces concurrent refresh requests', () async {
    final tokens = MemoryTokenStorage();
    final adapter = FakeAdapter(delayRefresh: true);
    final dio = Dio(BaseOptions(baseUrl: 'https://test.local'))
      ..httpClientAdapter = adapter;
    final client = ApiClient(dio: dio, tokens: tokens);
    final first = client.get('/one', accessToken: 'expired-access');
    final second = client.get('/two', accessToken: 'expired-access');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(adapter.refreshGate, isNotNull);
    adapter.refreshGate!.complete();

    await Future.wait([first, second]);
    expect(adapter.refreshCalls, 1);
    expect(tokens.writes, 1);
  });
}
