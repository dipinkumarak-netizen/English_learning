import 'package:flutter_test/flutter_test.dart';
import 'package:nilaspeak_mobile/features/voice/presentation/voice_state_machine.dart';

void main() {
  test('accepts the turn-based recording and processing path', () {
    expect(
      canTransition(VoiceState.idle, VoiceState.requestingPermission),
      isTrue,
    );
    expect(canTransition(VoiceState.ready, VoiceState.recording), isTrue);
    expect(canTransition(VoiceState.recording, VoiceState.stopping), isTrue);
    expect(canTransition(VoiceState.stopping, VoiceState.recorded), isTrue);
    expect(canTransition(VoiceState.recorded, VoiceState.validating), isTrue);
    expect(
      canTransition(VoiceState.transcribing, VoiceState.transcriptReady),
      isTrue,
    );
    expect(
      canTransition(VoiceState.transcriptReady, VoiceState.sendingToTutor),
      isTrue,
    );
    expect(
      canTransition(VoiceState.sendingToTutor, VoiceState.completed),
      isTrue,
    );
  });

  test('rejects unsafe duplicate or out-of-order operations', () {
    expect(canTransition(VoiceState.uploading, VoiceState.recording), isFalse);
    expect(
      canTransition(VoiceState.playingTutorAudio, VoiceState.recording),
      isFalse,
    );
    expect(
      canTransition(VoiceState.transcriptReady, VoiceState.uploading),
      isFalse,
    );
    expect(canTransition(VoiceState.stopping, VoiceState.stopping), isTrue);
  });
}
