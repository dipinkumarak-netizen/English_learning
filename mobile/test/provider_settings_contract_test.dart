import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/core/errors/error_mapper.dart';
import 'package:nilaspeak_mobile/features/settings/presentation/provider_settings_providers.dart';

void main() {
  test('maps display labels to backend provider values', () {
    expect(providerApiValue('Disabled'), 'none');
    expect(providerApiValue('Mock (development)'), 'mock');
    expect(providerApiValue('OpenAI-compatible'), 'openai');
  });

  test('serializes disabled provider using the exact backend payload', () {
    expect(
      buildProviderPayload(
        provider: 'Disabled',
        apiKey: 'must-be-cleared',
        model: 'must-be-cleared',
        baseUrl: 'must-be-cleared',
        voice: 'must-be-cleared',
        enabled: true,
      ),
      {
        'provider': 'none',
        'api_key': '',
        'model': '',
        'base_url': '',
        'voice': '',
        'enabled': false,
      },
    );
  });

  test('disabled provider cannot be enabled or tested', () {
    expect(canTestProvider('Disabled'), isFalse);
    expect(canTestProvider('none'), isFalse);
    expect(canTestProvider('OpenAI-compatible'), isTrue);
  });

  test('backend 400 maps to a user-friendly provider message', () {
    final request = RequestOptions(path: '/api/v1/settings/providers/ai');
    final error = DioException(
      requestOptions: request,
      response: Response<dynamic>(
        requestOptions: request,
        statusCode: 400,
        data: {'detail': 'Provider base URL contains a secret'},
      ),
    );

    final mapped = mapDioError(error);
    expect(mapped.message, contains('provider settings'));
    expect(mapped.message, isNot(contains('secret')));
    expect(mapped.toString(), isNot(contains("Instance of")));
  });
}
