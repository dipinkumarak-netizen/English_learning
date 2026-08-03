import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/core/config/environment.dart';

void main() {
  test('normalizes trailing slashes and accepts a LAN backend', () {
    expect(
      Environment.normalizeApiBaseUrl('http://192.168.1.50:8000///'),
      'http://192.168.1.50:8000',
    );
    expect(
      Environment.validateApiBaseUrl(
        'http://192.168.1.50:8000',
        environment: 'production',
      ),
      isNull,
    );
  });

  test('rejects stale development hosts for production builds', () {
    expect(
      Environment.validateApiBaseUrl(
        'http://10.0.2.2:8000',
        environment: 'production',
      ),
      isNotNull,
    );
    expect(
      Environment.validateApiBaseUrl('', environment: 'production'),
      'API_BASE_URL is missing.',
    );
  });
}
