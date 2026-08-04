import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../authentication/presentation/auth_controller.dart';
import '../data/capability_status.dart';
import '../data/capability_status_repository.dart';

enum ConnectionStatus {
  notTested,
  testing,
  connected,
  unreachable,
  invalidConfiguration,
}

final capabilityStatusRepositoryProvider = Provider<CapabilityStatusRepository>(
  (ref) => CapabilityStatusRepository(
    ref.watch(apiClientProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final capabilityStatusProvider =
    ChangeNotifierProvider<CapabilityStatusController>((ref) {
      ref.watch(authStateProvider);
      final controller = CapabilityStatusController(
        ref.watch(capabilityStatusRepositoryProvider),
      );
      controller.load();
      return controller;
    });

class CapabilityStatusController extends ChangeNotifier {
  CapabilityStatusController(this._repository);
  final CapabilityStatusSource _repository;
  CapabilityStatus? status;
  bool loading = false;
  String? error;
  ConnectionStatus connectionStatus = AppConfig.apiBaseUrlError == null
      ? ConnectionStatus.notTested
      : ConnectionStatus.invalidConfiguration;

  bool get testing => connectionStatus == ConnectionStatus.testing;

  String get connectionStatusLabel => switch (connectionStatus) {
    ConnectionStatus.notTested => 'Not tested',
    ConnectionStatus.testing => 'Testing…',
    ConnectionStatus.connected => 'Connected',
    ConnectionStatus.unreachable => 'Unreachable',
    ConnectionStatus.invalidConfiguration => 'Invalid configuration',
  };

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      status = await _repository.fetch();
    } catch (_) {
      error = 'Backend capability status is unavailable.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> testConnection() async {
    if (AppConfig.apiBaseUrlError != null) {
      connectionStatus = ConnectionStatus.invalidConfiguration;
      error = AppConfig.apiBaseUrlError;
      notifyListeners();
      return;
    }
    connectionStatus = ConnectionStatus.testing;
    error = null;
    notifyListeners();
    try {
      final health = await _repository.health();
      if (health['status'] != 'ok') {
        throw StateError('Backend health check failed.');
      }
      status = await _repository.fetch();
      connectionStatus = ConnectionStatus.connected;
    } catch (_) {
      connectionStatus = ConnectionStatus.unreachable;
      error = 'The backend is unreachable or capability discovery failed.';
    }
    notifyListeners();
  }
}
