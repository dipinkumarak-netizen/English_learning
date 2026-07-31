import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nilaspeak_mobile/features/voice/presentation/voice_readiness.dart';
import 'package:nilaspeak_mobile/features/voice/presentation/voice_state_machine.dart';

void main() {
  test('session-created idle state keeps Record turn enabled', () {
    expect(recordTurnButtonEnabled(VoiceState.idle), isTrue);
    expect(
      classifyMicrophoneAccess(PermissionStatus.denied, requested: false),
      MicrophoneAccess.notRequested,
    );
  });

  test('granted and ready state enables Record turn', () {
    expect(recordTurnButtonEnabled(VoiceState.ready), isTrue);
    expect(
      classifyMicrophoneAccess(PermissionStatus.granted, requested: true),
      MicrophoneAccess.granted,
    );
  });

  test('denied and permanently denied states are distinguishable', () {
    expect(
      classifyMicrophoneAccess(PermissionStatus.denied, requested: true),
      MicrophoneAccess.denied,
    );
    expect(
      classifyMicrophoneAccess(
        PermissionStatus.permanentlyDenied,
        requested: true,
      ),
      MicrophoneAccess.permanentlyDenied,
    );
    expect(
      classifyMicrophoneAccess(PermissionStatus.restricted, requested: true),
      MicrophoneAccess.restricted,
    );
    expect(
      classifyMicrophoneAccess(PermissionStatus.limited, requested: true),
      MicrophoneAccess.limited,
    );
  });

  test('loading/processing states never enable duplicate recording', () {
    expect(recordTurnButtonEnabled(VoiceState.requestingPermission), isFalse);
    expect(recordTurnButtonEnabled(VoiceState.uploading), isFalse);
    expect(recordTurnButtonEnabled(VoiceState.transcribing), isFalse);
    expect(recordTurnButtonEnabled(VoiceState.playingTutorAudio), isFalse);
  });

  test('AAC recorder fallback profiles and real error text are exposed', () {
    expect(recordingConfigurationFallbacks, hasLength(2));
    expect(
      recorderFailureMessage(StateError('encoder unavailable')),
      contains('encoder unavailable'),
    );
  });
}
