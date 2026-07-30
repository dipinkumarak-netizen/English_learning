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
