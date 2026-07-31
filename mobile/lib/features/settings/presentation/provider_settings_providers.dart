import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import '../data/provider_settings_repository.dart';

final providerSettingsRepositoryProvider = Provider<ProviderSettingsRepository>(
  (ref) => ProviderSettingsRepository(
    ref.watch(apiClientProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final providerSettingsProvider =
    ChangeNotifierProvider.autoDispose<ProviderSettingsController>((ref) {
      final controller = ProviderSettingsController(
        ref.watch(providerSettingsRepositoryProvider),
      );
      controller.load();
      return controller;
    });

class ProviderSettingsController extends ChangeNotifier {
  ProviderSettingsController(this._repository);

  final ProviderSettingsRepository _repository;
  List<ProviderSetting> providers = const [];
  bool loading = false;
  bool saving = false;
  bool testing = false;
  String? error;
  String? testMessage;

  ProviderSetting? get ai => _find('ai');
  ProviderSetting? get stt => _find('stt');
  ProviderSetting? get tts => _find('tts');

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      providers = await _repository.fetch();
    } catch (exception) {
      error = _safeMessage(exception);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> save({
    required String provider,
    required String apiKey,
    required String aiModel,
    required String sttModel,
    required String ttsModel,
    required String voice,
    required bool enabled,
  }) async {
    saving = true;
    error = null;
    notifyListeners();
    try {
      for (final capability in const ['ai', 'stt', 'tts']) {
        final data = <String, dynamic>{
          'provider': provider,
          'enabled': enabled,
          'api_key': apiKey.isEmpty ? null : apiKey,
          'base_url': null,
          'voice': voice,
          'model': switch (capability) {
            'ai' => aiModel,
            'stt' => sttModel,
            _ => ttsModel,
          },
        };
        providers = await _repository.save(capability, data);
      }
      return true;
    } catch (exception) {
      error = _safeMessage(exception);
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  Future<bool> testConnection({
    required String capability,
    required String provider,
    required String apiKey,
    required String model,
    required String voice,
  }) async {
    testing = true;
    testMessage = null;
    notifyListeners();
    try {
      final response = await _repository.test(capability, {
        'provider': provider,
        'api_key': apiKey.isEmpty ? null : apiKey,
        'model': model,
        'voice': voice,
        'base_url': null,
      });
      testMessage = response['message'] as String? ?? 'Connection test complete.';
      return response['status'] == 'success';
    } catch (exception) {
      testMessage = _safeMessage(exception);
      return false;
    } finally {
      testing = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCredentials() async {
    saving = true;
    error = null;
    notifyListeners();
    try {
      providers = await _repository.deleteAll();
      return true;
    } catch (exception) {
      error = _safeMessage(exception);
      return false;
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  ProviderSetting? _find(String capability) => providers
      .where((item) => item.capability == capability)
      .cast<ProviderSetting?>()
      .firstOrNull;

  String _safeMessage(Object exception) {
    final message = exception.toString();
    return message.replaceFirst('Exception: ', '');
  }
}

extension on Iterable<ProviderSetting?> {
  ProviderSetting? get firstOrNull => isEmpty ? null : first;
}
