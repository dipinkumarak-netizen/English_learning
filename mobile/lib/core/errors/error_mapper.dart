import 'package:dio/dio.dart';

import 'app_error.dart';

AppError mapDioError(Object error) {
  if (error is DioException && error.type == DioExceptionType.connectionError) {
    return const OfflineError('No network connection.');
  }
  if (error is DioException) {
    return NetworkError(error.message ?? 'Network request failed.');
  }
  return UnknownAppError(error.toString());
}
