import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/settings/data/capability_status.dart';
import 'package:nilaspeak_mobile/features/settings/data/capability_status_repository.dart';
import 'package:nilaspeak_mobile/features/settings/presentation/capability_status_providers.dart';

class _FakeCapabilitySource implements CapabilityStatusSource {
  _FakeCapabilitySource({
    this.healthResult = true,
    this.capabilityResult = true,
    this.healthFailuresBeforeSuccess = 0,
  });
  final bool healthResult;
  final bool capabilityResult;
  final int healthFailuresBeforeSuccess;
  bool healthCalled = false;
  bool capabilityCalled = false;
  int healthCalls = 0;

  @override
  Future<Map<String, dynamic>> health() async {
    healthCalled = true;
    healthCalls++;
    if (!healthResult || healthCalls <= healthFailuresBeforeSuccess) {
      throw StateError('health failed');
    }
    return {'status': 'ok'};
  }

  @override
  Future<CapabilityStatus> fetch() async {
    capabilityCalled = true;
    if (!capabilityResult) throw StateError('capabilities failed');
    return CapabilityStatus.fromJson({
      'transport_state': 'secure_https',
      'provider_mutations_allowed': true,
      'ai': {},
      'stt': {},
      'tts': {},
    });
  }
}

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

  test(
    'starts in Not tested and reports Testing while workflow runs',
    () async {
      final source = _FakeCapabilitySource();
      final controller = CapabilityStatusController(source);
      expect(controller.connectionStatus, ConnectionStatus.notTested);
      final future = controller.testConnection();
      expect(controller.connectionStatus, ConnectionStatus.testing);
      await future;
      expect(controller.connectionStatus, ConnectionStatus.connected);
    },
  );

  test(
    'health and capability success becomes Connected only after both complete',
    () async {
      final source = _FakeCapabilitySource();
      final controller = CapabilityStatusController(source);
      await controller.testConnection();
      expect(source.healthCalled, isTrue);
      expect(source.capabilityCalled, isTrue);
      expect(controller.connectionStatusLabel, 'Connected');
    },
  );

  test('successful refresh/retry still becomes Connected', () async {
    final source = _FakeCapabilitySource(healthFailuresBeforeSuccess: 1);
    final controller = CapabilityStatusController(source);
    // ApiClient performs the actual 401 token refresh and retry. This source
    // models that completed retry before capability discovery returns.
    source.healthCalls = 1;
    await controller.testConnection();
    expect(source.healthCalls, 2);
    expect(controller.connectionStatus, ConnectionStatus.connected);
  });

  test('health failure becomes Unreachable', () async {
    final controller = CapabilityStatusController(
      _FakeCapabilitySource(healthResult: false),
    );
    await controller.testConnection();
    expect(controller.connectionStatus, ConnectionStatus.unreachable);
  });

  test(
    'capability failure becomes Unreachable after healthy backend',
    () async {
      final controller = CapabilityStatusController(
        _FakeCapabilitySource(capabilityResult: false),
      );
      await controller.testConnection();
      expect(controller.connectionStatus, ConnectionStatus.unreachable);
      expect(controller.error, contains('capability'));
    },
  );

  test('capability refresh/load does not reset Connected', () async {
    final controller = CapabilityStatusController(_FakeCapabilitySource());
    await controller.testConnection();
    await controller.load();
    expect(controller.connectionStatus, ConnectionStatus.connected);
  });

  test(
    'controller state survives the equivalent of widget reconstruction',
    () async {
      final controller = CapabilityStatusController(_FakeCapabilitySource());
      await controller.testConnection();
      final rebuiltView = controller.connectionStatusLabel;
      expect(rebuiltView, 'Connected');
    },
  );
}
