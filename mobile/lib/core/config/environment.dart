abstract final class Environment {
  static const appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );
  static const rawApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    final candidate = rawApiBaseUrl.trim();
    if (candidate.isEmpty && appEnv == 'development') {
      return 'http://10.0.2.2:8000';
    }
    return candidate;
  }

  static String normalizeApiBaseUrl(String value) =>
      value.trim().replaceFirst(RegExp(r'/+$'), '');

  static String? validateApiBaseUrl(
    String value, {
    required String environment,
  }) {
    final normalized = normalizeApiBaseUrl(value);
    if (normalized.isEmpty) return 'API_BASE_URL is missing.';
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        !uri.hasScheme ||
        uri.host.isEmpty ||
        !{'http', 'https'}.contains(uri.scheme)) {
      return 'API_BASE_URL must be an HTTP or HTTPS URL with a host.';
    }
    if (uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      return 'API_BASE_URL must not contain credentials, query parameters, or fragments.';
    }
    if (environment != 'development' &&
        {'localhost', '10.0.2.2', '192.168.1.4'}.contains(uri.host)) {
      return 'API_BASE_URL points to a stale development host.';
    }
    return null;
  }
}
