import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voice_controller.dart';
import 'voice_providers.dart';
import 'voice_state_machine.dart';
import '../../settings/presentation/provider_settings_providers.dart';
import '../../settings/presentation/capability_status_providers.dart';

class VoiceConversationScreen extends ConsumerStatefulWidget {
  const VoiceConversationScreen({required this.sessionId, super.key});
  final String sessionId;

  @override
  ConsumerState<VoiceConversationScreen> createState() =>
      _VoiceConversationScreenState();
}

class _VoiceConversationScreenState
    extends ConsumerState<VoiceConversationScreen> {
  final _transcriptController = TextEditingController();
  bool _privacyAccepted = false;

  @override
  void dispose() {
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(voiceControllerProvider(widget.sessionId));
    final notifier = ref.read(voiceControllerProvider(widget.sessionId));
    final providerSettings = ref.watch(providerSettingsProvider);
    final capabilities = ref.watch(capabilityStatusProvider);
    final sttUsable = capabilities.status?.stt.usable == true;
    if (controller.editedTranscript != null &&
        _transcriptController.text != controller.editedTranscript) {
      _transcriptController.text = controller.editedTranscript!;
    }
    return PopScope(
      onPopInvokedWithResult: (_, _) => notifier.stopTutorAudio(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Voice conversation')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Turn-based voice conversation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Record one turn, review the transcript, then send it to your text tutor.',
            ),
            const SizedBox(height: 16),
            if (!_privacyAccepted)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Before your first recording',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Audio is sent to the NilaSpeak backend for transcription. Recordings are temporary and are not stored permanently by default. You can cancel or edit the transcript before sending it.',
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            setState(() => _privacyAccepted = true),
                        child: const Text('I understand'),
                      ),
                    ],
                  ),
                ),
              ),
            if (_privacyAccepted) ...[
              if (providerSettings.providers.isNotEmpty)
                _ProviderStatusBanner(settings: providerSettings),
              if (capabilities.status != null && !sttUsable)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Speech-to-text is disabled or unavailable. Enable a configured STT provider before recording.',
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              _StatusCard(controller: controller),
              const SizedBox(height: 16),
              if (controller.errorMessage != null) ...[
                Text(
                  controller.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                if (controller.permissionPermanentlyDenied)
                  OutlinedButton(
                    onPressed: notifier.openMicrophoneSettings,
                    child: const Text('Open Settings'),
                  )
                else if (controller.permissionDenied)
                  OutlinedButton(
                    onPressed: notifier.startRecording,
                    child: const Text('Retry microphone permission'),
                  ),
              ],
              Center(
                child: FilledButton.icon(
                  onPressed: controller.state == VoiceState.recording
                      ? notifier.stopRecording
                      : controller.canRecord && sttUsable
                      ? notifier.startRecording
                      : null,
                  icon: Icon(
                    controller.state == VoiceState.recording
                        ? Icons.stop
                        : Icons.mic,
                  ),
                  label: Text(
                    controller.state == VoiceState.recording
                        ? 'Stop recording'
                        : 'Record turn',
                  ),
                ),
              ),
              if (controller.state == VoiceState.recorded) ...[
                Text(
                  'Recording ready (${controller.recordingSeconds}s).',
                  textAlign: TextAlign.center,
                ),
                FilledButton(
                  onPressed: () => notifier.beginTurn(widget.sessionId),
                  child: const Text('Review transcript'),
                ),
                TextButton(
                  onPressed: notifier.cancelRecording,
                  child: const Text('Cancel and rerecord'),
                ),
              ],
              if (controller.state == VoiceState.transcriptReady ||
                  controller.state == VoiceState.sendingToTutor) ...[
                const SizedBox(height: 20),
                Text(
                  'Review transcript',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _transcriptController,
                  maxLines: 4,
                  onChanged: notifier.updateTranscript,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: providerSettings.stt?.provider == 'mock'
                        ? 'Recognised speech (mock)'
                        : 'Recognised speech',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: controller.state == VoiceState.sendingToTutor
                      ? null
                      : notifier.submitTranscript,
                  child: const Text('Confirm and send'),
                ),
              ],
              if (controller.tutorMessage != null)
                _TutorResponse(
                  controller: controller,
                  mockTts: providerSettings.tts?.provider == 'mock',
                  onSynthesis: notifier.synthesiseTutorReply,
                  onPlay: notifier.playTutorAudio,
                  onStop: notifier.stopTutorAudio,
                  onReplay: notifier.replayTutorAudio,
                  onSpeed: notifier.setPlaybackSpeed,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProviderStatusBanner extends StatelessWidget {
  const _ProviderStatusBanner({required this.settings});
  final ProviderSettingsController settings;

  @override
  Widget build(BuildContext context) {
    String label(String? provider, bool? enabled) {
      if (provider == 'mock') return 'mock (development)';
      if (provider == 'openai' && enabled == true) return 'real provider';
      return 'disabled';
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Backend providers — STT: ${label(settings.stt?.provider, settings.stt?.enabled)}, '
          'TTS: ${label(settings.tts?.provider, settings.tts?.enabled)}. '
          'Mock output is for development only.',
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});
  final VoiceController controller;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(
        controller.state == VoiceState.recording ? Icons.mic : Icons.graphic_eq,
      ),
      title: Text(_label(controller.state)),
      subtitle: Text(
        controller.state == VoiceState.recording
            ? '${controller.recordingSeconds}/60 seconds'
            : 'Maximum recording duration: 60 seconds',
      ),
    ),
  );

  String _label(VoiceState state) => switch (state) {
    VoiceState.idle => 'Tap Record turn to request microphone access',
    VoiceState.requestingPermission => 'Checking microphone permission',
    VoiceState.ready => 'Recorder ready',
    VoiceState.recording => 'Recording',
    VoiceState.uploading => 'Uploading securely',
    VoiceState.transcribing => 'Transcribing',
    VoiceState.transcriptReady => 'Transcript ready',
    VoiceState.sendingToTutor => 'Sending to tutor',
    VoiceState.synthesising => 'Creating tutor audio',
    VoiceState.playingTutorAudio => 'Playing tutor audio',
    VoiceState.failed => 'Needs attention',
    _ => 'Voice recorder is not active',
  };
}

class _TutorResponse extends StatelessWidget {
  const _TutorResponse({
    required this.controller,
    required this.mockTts,
    required this.onSynthesis,
    required this.onPlay,
    required this.onStop,
    required this.onReplay,
    required this.onSpeed,
  });
  final VoiceController controller;
  final bool mockTts;
  final VoidCallback onSynthesis;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onReplay;
  final ValueChanged<double> onSpeed;

  @override
  Widget build(BuildContext context) {
    final message = controller.tutorMessage!;
    final structured = message['structured_response'] as Map<String, dynamic>?;
    return Card(
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tutor response',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message['tutor_reply'] as String? ?? ''),
            if (structured?['corrected_sentence'] is String) ...[
              const Divider(),
              Text('Correction: ${structured!['corrected_sentence']}'),
            ],
            if (structured?['explanation_ml'] is String)
              Text('Malayalam explanation: ${structured!['explanation_ml']}'),
            const SizedBox(height: 12),
            if (controller.tutorAudioId == null)
              FilledButton.icon(
                onPressed: onSynthesis,
                icon: const Icon(Icons.volume_up),
                label: Text(
                  controller.state == VoiceState.failed
                      ? 'Retry voice'
                      : mockTts
                      ? 'Create tutor audio (mock)'
                      : 'Create tutor audio',
                ),
              )
            else
              Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    onPressed: onPlay,
                    tooltip: 'Play',
                    icon: const Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: onStop,
                    tooltip: 'Stop',
                    icon: const Icon(Icons.stop),
                  ),
                  IconButton(
                    onPressed: onReplay,
                    tooltip: 'Replay',
                    icon: const Icon(Icons.replay),
                  ),
                  DropdownButton<double>(
                    value: 1.0,
                    items: const [
                      DropdownMenuItem(value: .75, child: Text('.75x')),
                      DropdownMenuItem(value: 1.0, child: Text('1x')),
                      DropdownMenuItem(value: 1.25, child: Text('1.25x')),
                    ],
                    onChanged: (value) {
                      if (value != null) onSpeed(value);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
