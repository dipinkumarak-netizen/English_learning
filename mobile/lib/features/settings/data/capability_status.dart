import '../../../core/config/app_config.dart';

class CapabilityStatus {
  const CapabilityStatus({
    required this.transportState,
    required this.registrationAvailable,
    required this.ai,
    required this.stt,
    required this.tts,
    required this.maxAudioDurationSeconds,
    required this.maxUploadBytes,
    required this.providerMutationsAllowed,
  });

  factory CapabilityStatus.fromJson(
    Map<String, dynamic> json,
  ) => CapabilityStatus(
    transportState: json['transport_state'] as String? ?? 'insecure_or_invalid',
    registrationAvailable: json['registration_available'] as bool? ?? false,
    ai: CapabilityState.fromJson(json['ai']),
    stt: CapabilityState.fromJson(json['stt']),
    tts: CapabilityState.fromJson(json['tts']),
    maxAudioDurationSeconds: json['max_audio_duration_seconds'] as int? ?? 60,
    maxUploadBytes: json['max_upload_bytes'] as int? ?? 5000000,
    providerMutationsAllowed:
        json['provider_mutations_allowed'] as bool? ?? false,
  );

  final String transportState;
  final bool registrationAvailable;
  final CapabilityState ai;
  final CapabilityState stt;
  final CapabilityState tts;
  final int maxAudioDurationSeconds;
  final int maxUploadBytes;
  final bool providerMutationsAllowed;

  bool get isSecure => transportState == 'secure_https';
  bool get isPrivateHttp => transportState == 'private_http';
  String get transportLabel => switch (transportState) {
    'secure_https' => 'HTTPS secure',
    'private_http' => 'HTTP private development',
    _ => 'Invalid or insecure configuration',
  };
}

class CapabilityState {
  const CapabilityState({
    required this.state,
    required this.credentialSource,
    required this.usable,
    required this.provider,
    required this.providerType,
    required this.preview,
    required this.validationMessage,
  });

  factory CapabilityState.fromJson(Object? value) {
    final json = value is Map
        ? Map<String, dynamic>.from(value)
        : const <String, dynamic>{};
    return CapabilityState(
      state: json['state'] as String? ?? 'disabled',
      credentialSource: json['credential_source'] as String? ?? 'none',
      usable: json['usable'] as bool? ?? false,
      provider: json['provider'] as String? ?? 'none',
      providerType:
          json['provider_type'] as String? ??
          (json['state'] as String? ?? 'disabled'),
      preview: json['preview'] as bool? ?? false,
      validationMessage: json['validation_message'] as String?,
    );
  }

  final String state;
  final String credentialSource;
  final bool usable;
  final String provider;
  final String providerType;
  final bool preview;
  final String? validationMessage;

  String get label => switch (state) {
    'mock' => 'Mock (development)',
    'real' => 'Configured real provider',
    _ => 'Disabled',
  };

  String get sourceLabel => switch (credentialSource) {
    'user_encrypted' => 'Encrypted account credential',
    'environment' => 'Server environment',
    _ => 'None',
  };
}

String backendTransportLabel() {
  if (AppConfig.apiBaseUrlError != null) return 'Invalid configuration';
  final uri = Uri.tryParse(AppConfig.apiBaseUrl);
  if (uri?.scheme == 'https') return 'HTTPS secure';
  if (uri?.scheme == 'http') return 'HTTP private development';
  return 'Invalid configuration';
}
