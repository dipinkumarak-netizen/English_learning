import '../../../core/network/api_client.dart';

class ProviderSetting {
  const ProviderSetting({
    required this.capability,
    required this.provider,
    required this.configured,
    required this.enabled,
    this.keyLast4,
    this.model,
    this.baseUrl,
    this.voice,
    this.lastTestStatus,
    this.lastTestedAt,
    this.updatedAt,
  });

  final String capability;
  final String provider;
  final bool configured;
  final bool enabled;
  final String? keyLast4;
  final String? model;
  final String? baseUrl;
  final String? voice;
  final String? lastTestStatus;
  final DateTime? lastTestedAt;
  final DateTime? updatedAt;

  factory ProviderSetting.fromJson(Map<String, dynamic> json) => ProviderSetting(
    capability: json['capability'] as String,
    provider: json['provider'] as String? ?? 'none',
    configured: json['configured'] as bool? ?? false,
    enabled: json['enabled'] as bool? ?? false,
    keyLast4: json['key_last4'] as String?,
    model: json['model'] as String?,
    baseUrl: json['base_url'] as String?,
    voice: json['voice'] as String?,
    lastTestStatus: json['last_test_status'] as String?,
    lastTestedAt: _date(json['last_tested_at']),
    updatedAt: _date(json['updated_at']),
  );

  static DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;
}

class ProviderSettingsRepository {
  ProviderSettingsRepository(this._client, this._readToken);

  final ApiClient _client;
  final Future<String?> Function() _readToken;

  Future<String> _token() async =>
      await _readToken() ?? (throw StateError('Sign in to manage providers.'));

  Future<List<ProviderSetting>> fetch() async {
    final response = await _client.get(
      '/api/v1/settings/providers',
      accessToken: await _token(),
    );
    return (response['providers'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ProviderSetting.fromJson)
        .toList();
  }

  Future<List<ProviderSetting>> save(
    String capability,
    Map<String, dynamic> data,
  ) async {
    final response = await _client.put(
      '/api/v1/settings/providers/$capability',
      accessToken: await _token(),
      data: data,
    );
    return _parse(response);
  }

  Future<Map<String, dynamic>> test(
    String capability,
    Map<String, dynamic> data,
  ) async => _client.post(
    '/api/v1/settings/providers/$capability/test',
    accessToken: await _token(),
    data: data,
  );

  Future<List<ProviderSetting>> deleteAll() async {
    final response = await _client.delete(
      '/api/v1/settings/providers',
      accessToken: await _token(),
    );
    return _parse(response);
  }

  List<ProviderSetting> _parse(Map<String, dynamic> response) =>
      (response['providers'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(ProviderSetting.fromJson)
          .toList();
}
