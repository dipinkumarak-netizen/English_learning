import 'package:permission_handler/permission_handler.dart';

import 'voice_state_machine.dart';

enum MicrophoneAccess {
  notRequested,
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
}

MicrophoneAccess classifyMicrophoneAccess(
  PermissionStatus status, {
  required bool requested,
}) {
  if (!requested && status == PermissionStatus.denied) {
    return MicrophoneAccess.notRequested;
  }
  if (status == PermissionStatus.granted) return MicrophoneAccess.granted;
  if (status == PermissionStatus.permanentlyDenied) {
    return MicrophoneAccess.permanentlyDenied;
  }
  if (status == PermissionStatus.restricted) return MicrophoneAccess.restricted;
  if (status == PermissionStatus.limited) return MicrophoneAccess.limited;
  return MicrophoneAccess.denied;
}

bool recordTurnButtonEnabled(VoiceState state) =>
    state == VoiceState.idle ||
    state == VoiceState.ready ||
    state == VoiceState.recorded ||
    state == VoiceState.cancelled;

const recordingConfigurationFallbacks = <String>[
  'aacLc-16000Hz-64000bps-mono-m4a',
  'aacLc-44100Hz-96000bps-mono-m4a',
];

String recorderFailureMessage(Object error) =>
    'Recorder could not start: $error. Use text tutor or try again.';

String? audioFileExtension(String? contentType) =>
    switch (contentType?.split(';').first.trim().toLowerCase()) {
      'audio/mpeg' || 'audio/mp3' => '.mp3',
      'audio/wav' || 'audio/wave' => '.wav',
      'audio/ogg' => '.ogg',
      'audio/opus' => '.opus',
      _ => null,
    };
