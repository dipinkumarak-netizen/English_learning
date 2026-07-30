sealed class AppError implements Exception {
  const AppError(this.message);
  final String message;
}

final class NetworkError extends AppError {
  const NetworkError(super.message);
}

final class OfflineError extends AppError {
  const OfflineError(super.message);
}

final class UnknownAppError extends AppError {
  const UnknownAppError(super.message);
}
