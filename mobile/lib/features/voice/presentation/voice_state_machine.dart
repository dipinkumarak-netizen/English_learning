enum VoiceState {
  idle,
  requestingPermission,
  ready,
  recording,
  stopping,
  recorded,
  validating,
  uploading,
  transcribing,
  transcriptReady,
  sendingToTutor,
  synthesising,
  playingTutorAudio,
  completed,
  cancelled,
  failed,
}

bool canTransition(VoiceState from, VoiceState to) {
  if (from == to) return true;
  const transitions = <VoiceState, Set<VoiceState>>{
    VoiceState.idle: {VoiceState.requestingPermission},
    VoiceState.requestingPermission: {VoiceState.ready, VoiceState.failed},
    VoiceState.ready: {VoiceState.recording, VoiceState.cancelled},
    VoiceState.recording: {
      VoiceState.stopping,
      VoiceState.cancelled,
      VoiceState.failed,
    },
    VoiceState.stopping: {VoiceState.recorded, VoiceState.failed},
    VoiceState.recorded: {
      VoiceState.validating,
      VoiceState.recording,
      VoiceState.cancelled,
    },
    VoiceState.validating: {VoiceState.uploading, VoiceState.failed},
    VoiceState.uploading: {VoiceState.transcribing, VoiceState.failed},
    VoiceState.transcribing: {VoiceState.transcriptReady, VoiceState.failed},
    VoiceState.transcriptReady: {
      VoiceState.sendingToTutor,
      VoiceState.cancelled,
    },
    VoiceState.sendingToTutor: {VoiceState.completed, VoiceState.failed},
    VoiceState.synthesising: {VoiceState.completed, VoiceState.failed},
    VoiceState.playingTutorAudio: {VoiceState.completed, VoiceState.failed},
    VoiceState.completed: {
      VoiceState.synthesising,
      VoiceState.playingTutorAudio,
      VoiceState.recording,
    },
    VoiceState.cancelled: {VoiceState.ready, VoiceState.recording},
    VoiceState.failed: {
      VoiceState.ready,
      VoiceState.recording,
      VoiceState.validating,
    },
  };
  return transitions[from]?.contains(to) ?? false;
}
