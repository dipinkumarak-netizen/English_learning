import 'environment.dart';

abstract final class AppConfig {
  static const appName = 'NilaSpeak';
  static const version = '0.1.0';
  static const environment = Environment.appEnv;
  static final apiBaseUrl = Environment.normalizeApiBaseUrl(
    Environment.apiBaseUrl,
  );
  static final apiBaseUrlError = _validate(apiBaseUrl);

  static String? _validate(String value) =>
      Environment.validateApiBaseUrl(value, environment: environment);
}
