import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../errors/error_mapper.dart';
import '../logging/app_logger.dart';
import 'api_endpoints.dart';

final class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 10),
              headers: {'Accept': 'application/json'},
            ),
          );

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path, {String? accessToken}) =>
      _request(
        () => _dio.get<Map<String, dynamic>>(
          path,
          options: _options(accessToken),
        ),
      );

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    String? accessToken,
  }) => _request(
    () => _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(accessToken),
    ),
  );

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
    String? accessToken,
  }) => _request(
    () => _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      options: _options(accessToken),
    ),
  );

  Options _options(String? accessToken) => Options(
    headers: {if (accessToken != null) 'Authorization': 'Bearer $accessToken'},
  );

  Future<Map<String, dynamic>> _request(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      final response = await request();
      return response.data ?? <String, dynamic>{};
    } catch (error, stackTrace) {
      final mapped = mapDioError(error);
      AppLogger.instance.error('API request failed', mapped, stackTrace);
      throw mapped;
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
