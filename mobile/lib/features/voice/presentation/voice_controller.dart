import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../data/voice_repository.dart';
import 'voice_state_machine.dart';
import 'voice_readiness.dart';

class VoiceController extends ChangeNotifier {
  VoiceController(
    this._repository, {
    AudioRecorder? recorder,
    AudioPlayer? player,
  }) : _recorder = recorder ?? AudioRecorder(),
       _player = player ?? AudioPlayer();

  final VoiceRepository _repository;
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  VoiceState state = VoiceState.idle;
  String? errorMessage;
  PermissionStatus microphonePermission = PermissionStatus.denied;
  bool permissionRequested = false;
  bool recorderReady = false;
  String? selectedEncoder;
  String? sessionId;
  String? turnId;
  String? recordingPath;
  int recordingSeconds = 0;
  String? transcript;
  String? editedTranscript;
  Map<String, dynamic>? tutorMessage;
  String? tutorAudioId;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  Timer? _timer;

  static const maxRecordingSeconds = 60;

  bool get canRecord => recordTurnButtonEnabled(state);

  bool get permissionDenied =>
      permissionRequested &&
      (microphonePermission == PermissionStatus.denied ||
          microphonePermission == PermissionStatus.restricted);

  bool get permissionPermanentlyDenied =>
      microphonePermission == PermissionStatus.permanentlyDenied;

  Future<bool> requestMicrophone() async {
    state = VoiceState.requestingPermission;
    notifyListeners();
    final status = await Permission.microphone.request();
    permissionRequested = true;
    microphonePermission = status;
    if (status.isGranted) {
      await _prepareRecorder();
      notifyListeners();
      return recorderReady;
    }
    state = VoiceState.failed;
    errorMessage = status.isPermanentlyDenied
        ? 'Microphone access is blocked. Open Settings to enable it, or use text tutor.'
        : 'Microphone access is required for voice tutor. You can use text tutor instead.';
    notifyListeners();
    return false;
  }

  Future<void> openMicrophoneSettings() => openAppSettings();

  Future<void> startRecording() async {
    if (!canRecord || state == VoiceState.playingTutorAudio) return;
    if (!await requestMicrophone()) return;
    final directory = await getTemporaryDirectory();
    recordingPath =
        '${directory.path}${Platform.pathSeparator}nilaspeak-${DateTime.now().microsecondsSinceEpoch}.m4a';
    try {
      selectedEncoder = null;
      final configs = <RecordConfig>[
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 64000,
          sampleRate: 16000,
          numChannels: 1,
        ),
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 96000,
          sampleRate: 44100,
          numChannels: 1,
        ),
      ];
      Object? lastError;
      for (final config in configs) {
        if (!await _recorder.isEncoderSupported(config.encoder)) continue;
        try {
          await _recorder.start(config, path: recordingPath!);
          selectedEncoder =
              '${config.encoder.name}-${config.sampleRate}Hz-${config.bitRate}bps';
          lastError = null;
          break;
        } catch (error) {
          lastError = error;
        }
      }
      if (lastError != null || selectedEncoder == null) {
        throw StateError(
          lastError?.toString() ?? 'AAC-LC is not supported on this device.',
        );
      }
      state = VoiceState.recording;
      recordingSeconds = 0;
      errorMessage = null;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        recordingSeconds++;
        if (recordingSeconds >= maxRecordingSeconds) await stopRecording();
        notifyListeners();
      });
      notifyListeners();
    } catch (error) {
      state = VoiceState.failed;
      errorMessage = recorderFailureMessage(error);
      notifyListeners();
    }
  }

  Future<void> _prepareRecorder() async {
    recorderReady = false;
    selectedEncoder = null;
    try {
      final supported = await _recorder.isEncoderSupported(AudioEncoder.aacLc);
      if (!supported) {
        state = VoiceState.failed;
        errorMessage = 'AAC-LC/M4A recording is not supported on this device.';
        notifyListeners();
        return;
      }
    } catch (error) {
      state = VoiceState.failed;
      errorMessage = recorderFailureMessage(error);
      notifyListeners();
      return;
    }
    recorderReady = true;
    state = VoiceState.ready;
    errorMessage = null;
  }

  Future<void> stopRecording() async {
    if (state != VoiceState.recording) return;
    state = VoiceState.stopping;
    notifyListeners();
    _timer?.cancel();
    try {
      final path = await _recorder.stop();
      if (path == null ||
          !File(path).existsSync() ||
          File(path).lengthSync() == 0) {
        state = VoiceState.failed;
        errorMessage = 'The recording was empty. Please try again.';
      } else {
        recordingPath = path;
        state = VoiceState.recorded;
      }
    } catch (_) {
      state = VoiceState.failed;
      errorMessage = 'The recording could not be saved.';
    }
    notifyListeners();
  }

  Future<void> cancelRecording() async {
    _timer?.cancel();
    if (state == VoiceState.recording) await _recorder.cancel();
    final path = recordingPath;
    if (path != null) {
      try {
        await File(path).delete();
      } catch (_) {
        // Temporary cleanup is best-effort.
      }
    }
    recordingPath = null;
    recordingSeconds = 0;
    state = VoiceState.cancelled;
    notifyListeners();
  }

  Future<void> beginTurn(String voiceSessionId) async {
    if (state != VoiceState.recorded || recordingPath == null) return;
    sessionId = voiceSessionId;
    state = VoiceState.validating;
    notifyListeners();
    try {
      final operation = _operationId('turn');
      final turn = await _repository.createTurn(voiceSessionId, operation);
      turnId = turn['id'] as String;
      state = VoiceState.uploading;
      notifyListeners();
      await _repository.uploadAudio(
        turnId!,
        recordingPath!,
        recordingSeconds.clamp(1, maxRecordingSeconds),
        _operationId('upload'),
      );
      state = VoiceState.transcribing;
      notifyListeners();
      final result = await _repository.transcribe(turnId!, _operationId('stt'));
      transcript = result['transcript'] as String?;
      editedTranscript = transcript;
      state = VoiceState.transcriptReady;
      notifyListeners();
    } catch (_) {
      state = VoiceState.failed;
      errorMessage =
          'Voice upload or transcription failed. You can retry or use text tutor.';
      notifyListeners();
    }
  }

  Future<void> updateTranscript(String value) async {
    editedTranscript = value;
    notifyListeners();
  }

  Future<void> submitTranscript() async {
    if (turnId == null || (editedTranscript ?? '').trim().isEmpty) return;
    state = VoiceState.sendingToTutor;
    notifyListeners();
    try {
      await _repository.editTranscript(turnId!, editedTranscript!.trim());
      final response = await _repository.submit(
        turnId!,
        _operationId('submit'),
      );
      tutorMessage = response['message'] as Map<String, dynamic>?;
      state = VoiceState.completed;
      notifyListeners();
    } catch (_) {
      state = VoiceState.failed;
      errorMessage =
          'The tutor could not process this transcript. Please retry.';
      notifyListeners();
    }
  }

  Future<void> synthesiseTutorReply() async {
    if (turnId == null) return;
    state = VoiceState.synthesising;
    notifyListeners();
    try {
      final response = await _repository.synthesise(
        turnId!,
        _operationId('tts'),
      );
      tutorAudioId = response['audio_id'] as String?;
      if (tutorAudioId == null) throw StateError('No audio returned');
      final audio = await _repository.audio(tutorAudioId!);
      if (audio.bytes.isEmpty) {
        throw StateError('Tutor audio download was empty');
      }
      final extension = audioFileExtension(audio.contentType);
      if (extension == null) {
        throw StateError('Tutor audio format is not supported.');
      }
      final directory = await getTemporaryDirectory();
      final path =
          '${directory.path}${Platform.pathSeparator}nilaspeak-tutor$extension';
      await File(path).writeAsBytes(audio.bytes, flush: true);
      if (!File(path).existsSync() || File(path).lengthSync() == 0) {
        throw StateError('Tutor audio could not be cached locally.');
      }
      await _player.setFilePath(path);
      duration = _player.duration ?? Duration.zero;
      state = VoiceState.completed;
      notifyListeners();
    } catch (_) {
      state = VoiceState.failed;
      errorMessage =
          'Tutor audio is unavailable. The text tutor response is still available.';
      notifyListeners();
    }
  }

  Future<void> playTutorAudio() async {
    if (tutorAudioId == null) return;
    if (_player.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
    }
    state = VoiceState.playingTutorAudio;
    notifyListeners();
    await _player.play();
    state = VoiceState.completed;
    notifyListeners();
  }

  Future<void> stopTutorAudio() async {
    await _player.stop();
    state = VoiceState.completed;
    notifyListeners();
  }

  Future<void> replayTutorAudio() async {
    await _player.seek(Duration.zero);
    await playTutorAudio();
  }

  Future<void> setPlaybackSpeed(double speed) => _player.setSpeed(speed);

  String _operationId(String prefix) =>
      'mobile-voice-$prefix-${DateTime.now().microsecondsSinceEpoch}';

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
