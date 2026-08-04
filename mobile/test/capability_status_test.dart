import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/settings/data/capability_status.dart';

void main() {
  test('parses safe capability metadata without secrets', () {
    final status = CapabilityStatus.fromJson({
      'transport_state': 'secure_https',
      'registration_available': false,
      'provider_mutations_allowed': true,
      'max_audio_duration_seconds': 60,
      'max_upload_bytes': 5000000,
      'ai': {
        'state': 'real',
        'credential_source': 'user_encrypted',
        'usable': true,
        'provider': 'openai',
      },
      'stt': {
        'state': 'mock',
        'credential_source': 'environment',
        'usable': true,
        'provider': 'mock',
      },
      'tts': {
        'state': 'disabled',
        'credential_source': 'none',
        'usable': false,
        'provider': 'none',
      },
    });
    expect(status.isSecure, isTrue);
    expect(status.transportLabel, 'HTTPS secure');
    expect(status.ai.sourceLabel, 'Encrypted account credential');
    expect(status.stt.label, 'Mock (development)');
    expect(status.tts.usable, isFalse);
  });

  test('identifies private HTTP transport', () {
    final status = CapabilityStatus.fromJson({
      'transport_state': 'private_http',
      'ai': {},
      'stt': {},
      'tts': {},
    });
    expect(status.isPrivateHttp, isTrue);
    expect(status.providerMutationsAllowed, isFalse);
  });
}
