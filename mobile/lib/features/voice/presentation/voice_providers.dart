import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import '../data/voice_repository.dart';
import 'voice_controller.dart';

final voiceRepositoryProvider = Provider<VoiceRepository>(
  (ref) => VoiceRepository(
    ref.watch(apiClientProvider),
    ref.watch(databaseProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final voiceControllerProvider = ChangeNotifierProvider.autoDispose
    .family<VoiceController, String>((ref, sessionId) {
      final controller = VoiceController(ref.watch(voiceRepositoryProvider));
      controller.sessionId = sessionId;
      return controller;
    });
