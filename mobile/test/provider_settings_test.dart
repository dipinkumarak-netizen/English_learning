import 'package:flutter_test/flutter_test.dart';

import 'package:nilaspeak_mobile/features/settings/data/provider_settings_repository.dart';

void main() {
  test('parses only the masked provider summary', () {
    final setting = ProviderSetting.fromJson({
      'capability': 'ai',
      'provider': 'openai',
      'configured': true,
      'enabled': true,
      'key_last4': '1234',
      'model': 'gpt-test',
      'last_test_status': 'success',
      'updated_at': '2026-07-31T10:00:00Z',
      'api_key': 'must-not-be-used',
      'encrypted_api_key': 'must-not-be-used',
    });

    expect(setting.keyLast4, '1234');
    expect(setting.configured, isTrue);
    expect(setting.provider, 'openai');
    expect(setting.model, 'gpt-test');
    expect(setting.updatedAt, isNotNull);
  });

  test('missing secret fields never create a local key value', () {
    final setting = ProviderSetting.fromJson({
      'capability': 'stt',
      'provider': 'none',
      'configured': false,
      'enabled': false,
    });

    expect(setting.keyLast4, isNull);
  });
}
