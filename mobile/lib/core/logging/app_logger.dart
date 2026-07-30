import 'dart:developer' as developer;

final class AppLogger {
  AppLogger._();
  static final instance = AppLogger._();

  void info(String message) => developer.log(message, name: 'NilaSpeak');
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      developer.log(
        message,
        name: 'NilaSpeak',
        error: error,
        stackTrace: stackTrace,
        level: 1000,
      );
}
