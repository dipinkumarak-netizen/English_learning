import 'package:dio/dio.dart';

import '../../features/authentication/data/token_storage.dart';
import '../config/app_config.dart';
import '../errors/error_mapper.dart';
import '../logging/app_logger.dart';
import 'api_endpoints.dart';

final class ApiClient {
  ApiClient({Dio? dio, TokenStorage? tokens})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Accept': 'application/json'},
            ),
          ),
      // The Dio initializer requires a separate initializer-list entry.
      // ignore: prefer_initializing_formals
      _tokens = tokens;

  final Dio _dio;
  final TokenStorage? _tokens;
  Future<bool>? _refreshing;

  Future<Map<String, dynamic>> get(String path, {String? accessToken}) =>
      _request(
        (token) =>
            _dio.get<Map<String, dynamic>>(path, options: _options(token)),
        accessToken,
      );

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    String? accessToken,
  }) => _request(
    (token) => _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(token),
    ),
    accessToken,
  );

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    String? accessToken,
  }) => _request(
    (token) => _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(token),
    ),
    accessToken,
  );

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? data,
    String? accessToken,
  }) => _request(
    (token) => _dio.patch<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(token),
    ),
    accessToken,
  );

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required FormData data,
    String? accessToken,
  }) => _request(
    (token) => _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(token),
    ),
    accessToken,
  );

  Future<List<int>> downloadBytes(String path, {String? accessToken}) async {
    final response = await downloadAudio(path, accessToken: accessToken);
    return response.bytes;
  }

  Future<({List<int> bytes, String? contentType})> downloadAudio(
    String path, {
    String? accessToken,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        path,
        options: _options(
          accessToken,
        ).copyWith(responseType: ResponseType.bytes),
      );
      return (
        bytes: response.data ?? const <int>[],
        contentType: response.headers.value(Headers.contentTypeHeader),
      );
    } catch (error, stackTrace) {
      final mapped = mapDioError(error);
      AppLogger.instance.error('API download failed', mapped, stackTrace);
      throw mapped;
    }
  }

  Future<void> delete(String path, {String? accessToken}) async {
    try {
      await _dio.delete<void>(path, options: _options(accessToken));
    } catch (error, stackTrace) {
      final mapped = mapDioError(error);
      AppLogger.instance.error('API delete failed', mapped, stackTrace);
      throw mapped;
    }
  }

  Options _options(String? accessToken) => Options(
    headers: {if (accessToken != null) 'Authorization': 'Bearer $accessToken'},
  );

  Future<Map<String, dynamic>> _request(
    Future<Response<Map<String, dynamic>>> Function(String? token) request,
    String? accessToken,
  ) async {
    try {
      final response = await request(accessToken);
      return response.data ?? <String, dynamic>{};
    } catch (error, stackTrace) {
      if (error is DioException &&
          error.response?.statusCode == 401 &&
          accessToken != null) {
        if (await _refreshTokens()) {
          try {
            final retry = await request(await _tokens?.readAccessToken());
            return retry.data ?? <String, dynamic>{};
          } catch (retryError) {
            final mappedRetry = mapDioError(retryError);
            AppLogger.instance.error(
              'API retry failed',
              mappedRetry,
              stackTrace,
            );
            throw mappedRetry;
          }
        }
      }
      final mapped = mapDioError(error);
      AppLogger.instance.error('API request failed', mapped, stackTrace);
      throw mapped;
    }
  }

  Future<bool> _refreshTokens() {
    final existing = _refreshing;
    if (existing != null) return existing;
    final refresh = _performRefresh();
    _refreshing = refresh;
    refresh.whenComplete(() => _refreshing = null);
    return refresh;
  }

  Future<bool> _performRefresh() async {
    final tokens = _tokens;
    if (tokens == null) return false;
    final refreshToken = await tokens.readRefreshToken();
    if (refreshToken == null) return false;
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data;
      final accessToken = data?['access_token'];
      final nextRefreshToken = data?['refresh_token'];
      if (accessToken is! String || nextRefreshToken is! String) {
        await tokens.clear();
        return false;
      }
      await tokens.writeTokens(
        accessToken: accessToken,
        refreshToken: nextRefreshToken,
      );
      return true;
    } catch (_) {
      await tokens.clear();
      return false;
    }
  }

  Future<Map<String, dynamic>> health() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.health,
      );
      return response.data ?? <String, dynamic>{};
    } catch (error, stackTrace) {
      final mapped = mapDioError(error);
      AppLogger.instance.error('Health request failed', mapped, stackTrace);
      throw mapped;
    }
  }
}
