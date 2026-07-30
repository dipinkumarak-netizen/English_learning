import 'environment.dart';

abstract final class AppConfig {
  static const appName = 'NilaSpeak';
  static const version = '0.1.0';
  static const environment = Environment.appEnv;
  static const apiBaseUrl = Environment.apiBaseUrl;
}
