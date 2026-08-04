import 'package:dio/dio.dart';

import 'app_error.dart';

AppError mapDioError(Object error) {
  if (error is DioException) {
    final status = error.response?.statusCode;
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const OfflineError('The backend connection timed out.');
    }
    if (error.type == DioExceptionType.connectionError) {
      return const OfflineError('The backend is unreachable.');
    }
    if (status == 403 && error.requestOptions.path.endsWith('/auth/register')) {
      return const NetworkError('Registration is currently disabled.');
    }
    if (status == 400) {
      final detail = error.response?.data is Map
          ? (error.response?.data as Map)['detail']?.toString().toLowerCase()
          : null;
      if (detail?.contains('base url') == true) {
        return const NetworkError(
          'The provider settings were rejected because the base URL is invalid or not allowed.',
        );
      }
      return const NetworkError(
        'The provider settings were rejected. Check the selected provider and try again.',
      );
    }
    final message = status == null
        ? 'The backend request failed.'
        : switch (status) {
            401 => 'Your session expired. Continuing in local mode.',
            403 => 'This action is not allowed.',
            409 =>
              'The account already exists or conflicts with existing data.',
            422 => 'The server rejected the submitted details.',
            429 => 'Too many requests. Please try again later.',
            >= 500 => 'The backend is temporarily unavailable.',
            _ => 'The backend request failed.',
          };
    return NetworkError(message);
  }
  return const UnknownAppError('Unexpected application error.');
}
