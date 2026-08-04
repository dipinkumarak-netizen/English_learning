import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_error.dart';
import '../../authentication/presentation/auth_controller.dart';
import '../data/provider_settings_repository.dart';

const providerLabelToApiValue = <String, String>{
  'Disabled': 'none',
  'Mock (development)': 'mock',
  'OpenAI-compatible': 'openai',
};

String providerApiValue(String value) =>
    providerLabelToApiValue[value] ?? value;

bool canTestProvider(String provider) => providerApiValue(provider) != 'none';

Map<String, dynamic> buildProviderPayload({
  required String provider,
  required String apiKey,
  required String model,
  required String baseUrl,
  required String voice,
  required bool enabled,
}) {
  final apiProvider = providerApiValue(provider);
  if (apiProvider == 'none') {
    return {
      'provider': 'none',
      'api_key': '',
      'model': '',
      'base_url': '',
      'voice': '',
      'enabled': false,
    };
  }
  return {
    'provider': apiProvider,
    'api_key': apiKey,
    'model': model,
    'base_url': baseUrl,
    'voice': voice,
    'enabled': enabled,
  };
}

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
        final data = buildProviderPayload(
          provider: provider,
          apiKey: apiKey,
          model: switch (capability) {
            'ai' => aiModel,
            'stt' => sttModel,
            _ => ttsModel,
          },
          baseUrl: '',
          voice: voice,
          enabled: enabled,
        );
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

  Future<bool> saveCapability({
    required String capability,
    required String provider,
    required String apiKey,
    required String model,
    required String voice,
    required bool enabled,
    required bool transportAllowsMutation,
  }) async {
    if (!transportAllowsMutation) {
      error = 'Provider credentials require an HTTPS backend connection.';
      notifyListeners();
      return false;
    }
    saving = true;
    error = null;
    notifyListeners();
    try {
      providers = await _repository.save(
        capability,
        buildProviderPayload(
          provider: provider,
          apiKey: apiKey,
          model: model,
          baseUrl: '',
          voice: voice,
          enabled: enabled,
        ),
      );
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
    bool transportAllowsMutation = true,
  }) async {
    if (!transportAllowsMutation) {
      testMessage = 'Provider credentials require an HTTPS backend connection.';
      notifyListeners();
      return false;
    }
    if (!canTestProvider(provider)) {
      testMessage = 'Enable a provider before testing the connection.';
      notifyListeners();
      return false;
    }
    testing = true;
    testMessage = null;
    notifyListeners();
    try {
      final response = await _repository.test(
        capability,
        buildProviderPayload(
          provider: provider,
          apiKey: apiKey,
          model: model,
          baseUrl: '',
          voice: voice,
          enabled: true,
        ),
      );
      testMessage =
          response['message'] as String? ?? 'Connection test complete.';
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

  Future<bool> deleteCapability(
    String capability, {
    required bool transportAllowsMutation,
  }) async {
    if (!transportAllowsMutation) {
      error = 'Provider credentials require an HTTPS backend connection.';
      notifyListeners();
      return false;
    }
    saving = true;
    error = null;
    notifyListeners();
    try {
      providers = await _repository.delete(capability);
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

  String _safeMessage(Object exception) => exception is AppError
      ? exception.message
      : 'The provider settings request failed. Please try again.';
}

extension on Iterable<ProviderSetting?> {
  ProviderSetting? get firstOrNull => isEmpty ? null : first;
}
